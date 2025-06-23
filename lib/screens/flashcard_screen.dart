import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/data/flashcards_data.dart';
import 'package:flashcard_quiz_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int currentIndex = 0;
  bool showAnswer = false;
  int? selectedOption;
  bool showResult = false;

  @override
  Widget build(BuildContext context) {
    final flashcard = FlashcardData.flashcards[currentIndex];
    final options = flashcard['options'] as List<String>?;
    final correctAnswer = flashcard['correctAnswer'] as String?;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.appBackgroundGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              color: AppColors.backgroundColor,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      flashcard['question']!,
                      style: const TextStyle(fontSize: 24, color: AppColors.textColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    if (options != null && !showAnswer) ...[
                      ...options.asMap().entries.map((entry) {
                        int idx = entry.key;
                        String option = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CustomButton(
                            text: 'Option ${String.fromCharCode(65 + idx)}: $option',
                            onPressed: () {
                              setState(() {
                                selectedOption = idx;
                                showResult = true;
                              });
                            },
                            backgroundColor: selectedOption == idx
                                ? (showResult && option == correctAnswer
                                    ? Colors.green
                                    : Colors.red)
                                : AppColors.secondaryColor,
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                      if (showResult)
                        Text(
                          selectedOption != null && options[selectedOption!] == correctAnswer
                              ? 'Correct!'
                              : 'Wrong! The correct answer is: $correctAnswer',
                          style: const TextStyle(fontSize: 18, color: AppColors.textColor),
                        ),
                    ] else if (showAnswer && correctAnswer != null) ...[
                      Text(
                        correctAnswer,
                        style: const TextStyle(fontSize: 20, color: AppColors.textColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          text: 'Previous',
                          onPressed: currentIndex > 0
                              ? () {
                                  setState(() {
                                    currentIndex--;
                                    showAnswer = false;
                                    selectedOption = null;
                                    showResult = false;
                                  });
                                }
                              : null,
                          enabled: currentIndex > 0,
                          backgroundColor: AppColors.secondaryColor,
                        ),
                        CustomButton(
                          text: showAnswer ? 'Hide Answer' : 'Show Answer',
                          onPressed: () {
                            setState(() {
                              showAnswer = !showAnswer;
                              if (!showAnswer) {
                                selectedOption = null;
                                showResult = false;
                              }
                            });
                          },
                          backgroundColor: AppColors.primaryColor,
                        ),
                        CustomButton(
                          text: 'Next',
                          onPressed: currentIndex < FlashcardData.flashcards.length - 1
                              ? () {
                                  setState(() {
                                    currentIndex++;
                                    showAnswer = false;
                                    selectedOption = null;
                                    showResult = false;
                                  });
                                }
                              : null,
                          enabled: currentIndex < FlashcardData.flashcards.length - 1,
                          backgroundColor: AppColors.secondaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}