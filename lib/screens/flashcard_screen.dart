import 'dart:async';

import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/models/quiz_attempt_model.dart';
import 'package:flashcard_quiz_app/providers/app_provider.dart';
import 'package:flashcard_quiz_app/screens/quiz_result_screen.dart';
import 'package:flashcard_quiz_app/widgets/custom_button.dart';
import 'package:flashcard_quiz_app/widgets/options_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashcardScreen extends StatefulWidget {
  final String deckId;

  const FlashcardScreen({super.key, required this.deckId});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  static const int _secondsPerQuestion = 20;

  int currentIndex = 0;
  int? selectedIndex;
  bool answered = false;
  int score = 0;
  int secondsLeft = _secondsPerQuestion;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    secondsLeft = _secondsPerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (secondsLeft <= 1) {
        timer.cancel();
        if (!answered) _timeUp();
      } else {
        setState(() => secondsLeft--);
      }
    });
  }

  void _timeUp() {
    final deck = context.read<AppProvider>().deckById(widget.deckId);
    if (deck == null) return;
    final card = deck.cards[currentIndex];
    setState(() {
      answered = true;
      selectedIndex = null;
    });
    context.read<AppProvider>().recordAnswer(widget.deckId, card.id, false);
  }

  void _selectOption(
    int idx,
    String option,
    String correctAnswer,
    String cardId,
  ) {
    if (answered) return;
    _timer?.cancel();
    final isCorrect = option == correctAnswer;
    setState(() {
      selectedIndex = idx;
      answered = true;
      if (isCorrect) score++;
    });
    context.read<AppProvider>().recordAnswer(widget.deckId, cardId, isCorrect);
  }

  void _next(int totalQuestions, String deckName) {
    if (currentIndex < totalQuestions - 1) {
      setState(() {
        currentIndex++;
        selectedIndex = null;
        answered = false;
      });
      _startTimer();
    } else {
      context.read<AppProvider>().recordQuizAttempt(
        QuizAttemptModel(
          deckId: widget.deckId,
          deckName: deckName,
          score: score,
          total: totalQuestions,
          date: DateTime.now(),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => QuizResultScreen(
                deckId: widget.deckId,
                score: score,
                total: totalQuestions,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deck = context.watch<AppProvider>().deckById(widget.deckId);

    if (deck == null || deck.cards.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No flashcards to quiz.')),
      );
    }

    final total = deck.cards.length;
    final flashcard = deck.cards[currentIndex];
    final correctAnswer = flashcard.correctAnswer;
    final isLast = currentIndex == total - 1;
    final isCorrectSelection =
        selectedIndex != null &&
        flashcard.options[selectedIndex!] == correctAnswer;
    final timeRanOut = answered && selectedIndex == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question ${currentIndex + 1} of $total',
          style: AppTextStyles.heading2(context),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 18,
                    color:
                        secondsLeft <= 5 ? AppColors.error : AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${secondsLeft}s',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color:
                          secondsLeft <= 5
                              ? AppColors.error
                              : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ClipRRect(
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / total,
              minHeight: 6,
              backgroundColor: AppColors.disabled,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      flashcard.question,
                      style: AppTextStyles.heading1(context),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...flashcard.options.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final option = entry.value;
                    final letter = String.fromCharCode(65 + idx);

                    OptionState state;
                    if (!answered) {
                      state = OptionState.normal;
                    } else if (option == correctAnswer) {
                      state = OptionState.correctReveal;
                    } else if (idx == selectedIndex) {
                      state = OptionState.selectedWrong;
                    } else {
                      state = OptionState.disabled;
                    }

                    return OptionTile(
                      letter: letter,
                      text: option,
                      state: state,
                      onTap:
                          () => _selectOption(
                            idx,
                            option,
                            correctAnswer,
                            flashcard.id,
                          ),
                    );
                  }),
                  if (answered) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isCorrectSelection
                              ? Icons.emoji_events_rounded
                              : Icons.info_outline_rounded,
                          color:
                              isCorrectSelection
                                  ? AppColors.success
                                  : AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            timeRanOut
                                ? "Time's up! The correct answer is highlighted above."
                                : isCorrectSelection
                                ? 'Correct! Well done.'
                                : 'Not quite — the correct answer is highlighted above.',
                            style: AppTextStyles.bodySecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: CustomButton(
                text: isLast ? 'Finish Quiz' : 'Next Question',
                icon: isLast ? Icons.flag_rounded : Icons.arrow_forward_rounded,
                expand: true,
                enabled: answered,
                onPressed: () => _next(total, deck.name),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
