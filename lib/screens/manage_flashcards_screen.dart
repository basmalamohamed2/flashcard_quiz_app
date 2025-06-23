import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/data/flashcards_data.dart';
import 'package:flashcard_quiz_app/screens/add_flashcard_screen.dart';
import 'package:flutter/material.dart';

class ManageFlashcardsScreen extends StatefulWidget {
  const ManageFlashcardsScreen({super.key});

  @override
  State<ManageFlashcardsScreen> createState() => _ManageFlashcardsScreenState();
}

class _ManageFlashcardsScreenState extends State<ManageFlashcardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.appBackgroundGradient),
        child:
            FlashcardData.flashcards.isEmpty
                ? const Center(
                  child: Text(
                    'No flashcards available.',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(16).copyWith(bottom: 80),
                  itemCount: FlashcardData.flashcards.length,
                  itemBuilder: (context, index) {
                    final flashcard = FlashcardData.flashcards[index];
                    if (!flashcard.containsKey('question') ||
                        !flashcard.containsKey('correctAnswer')) {
                      return const Center(
                        child: Text(
                          'Invalid flashcard data.',
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      );
                    }
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          flashcard['question']!,
                          style: const TextStyle(color: AppColors.textColor),
                        ),
                        subtitle: Text(
                          flashcard['correctAnswer']!,
                          style: const TextStyle(color: AppColors.textColor),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: AppColors.accentColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  FlashcardData.removeFlashcard(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFlashcardScreen()),
          );
        },
        child: const Icon(Icons.add, color: AppColors.backgroundColor),
      ),
    );
  }
}
