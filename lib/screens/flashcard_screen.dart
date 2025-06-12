import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/data/flashcards_data.dart';
import 'package:flutter/material.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int currentIndex = 0;
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
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
                      FlashcardData.flashcards[currentIndex]['question']!,
                      style: const TextStyle(
                        fontSize: 24,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    if (showAnswer)
                      Text(
                        FlashcardData.flashcards[currentIndex]['answer']!,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 68, 110, 110),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        minimumSize: const Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          showAnswer = !showAnswer;
                        });
                      },
                      child: Text(
                        showAnswer ? 'Hide Answer' : 'Show Answer',
                        style: const TextStyle(
                          color: AppColors.backgroundColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    minimumSize: const Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed:
                      currentIndex > 0
                          ? () {
                            setState(() {
                              currentIndex--;
                              showAnswer = false;
                            });
                          }
                          : null,
                  child: const Text(
                    'Previous',
                    style: TextStyle(
                      color: AppColors.backgroundColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    minimumSize: const Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed:
                      currentIndex < FlashcardData.flashcards.length - 1
                          ? () {
                            setState(() {
                              currentIndex++;
                              showAnswer = false;
                            });
                          }
                          : null,
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: AppColors.backgroundColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
