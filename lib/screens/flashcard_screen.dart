import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/data/flashcards_data.dart';
import 'package:flashcard_quiz_app/widgets/custom_button.dart';
import 'package:flashcard_quiz_app/widgets/options_tile.dart';
import 'package:flutter/material.dart';
import 'quiz_result_screen.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int currentIndex = 0;
  int? selectedIndex;
  bool answered = false;
  int score = 0;

  void _selectOption(int idx, String option, String correctAnswer) {
    if (answered) return;
    setState(() {
      selectedIndex = idx;
      answered = true;
      if (option == correctAnswer) score++;
    });
  }

  void _next(int totalQuestions) {
    if (currentIndex < totalQuestions - 1) {
      setState(() {
        currentIndex++;
        selectedIndex = null;
        answered = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(score: score, total: totalQuestions),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final flashcards = FlashcardData.flashcards;
    final total = flashcards.length;
    final flashcard = flashcards[currentIndex];
    final correctAnswer = flashcard.correctAnswer;
    final isLast = currentIndex == total - 1;
    final isCorrectSelection =
        selectedIndex != null &&
        flashcard.options[selectedIndex!] == correctAnswer;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question ${currentIndex + 1} of $total',
          style: AppTextStyles.heading2,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          ClipRRect(
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / total,
              minHeight: 6,
              backgroundColor: AppColors.border,
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
                      color: AppColors.surface,
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
                      style: AppTextStyles.heading1,
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
                      onTap: () => _selectOption(idx, option, correctAnswer),
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
                            isCorrectSelection
                                ? 'Correct! Well done.'
                                : 'Not quite — the correct answer is highlighted above.',
                            style: AppTextStyles.bodySecondary,
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
                onPressed: () => _next(total),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
