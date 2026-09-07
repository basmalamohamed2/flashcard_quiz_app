import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/data/flashcards_data.dart';
import 'package:flashcard_quiz_app/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'flashcard_form_screen.dart';

class ManageFlashcardsScreen extends StatefulWidget {
  const ManageFlashcardsScreen({super.key});

  @override
  State<ManageFlashcardsScreen> createState() => _ManageFlashcardsScreenState();
}

class _ManageFlashcardsScreenState extends State<ManageFlashcardsScreen> {
  Future<void> _addFlashcard() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FlashcardFormScreen()),
    );
    if (mounted) setState(() {});
  }

  Future<void> _editFlashcard(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => FlashcardFormScreen(
              editIndex: index,
              existingFlashcard: FlashcardData.flashcards[index],
            ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _confirmDelete(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Delete flashcard?'),
            content: const Text('This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      setState(() {
        FlashcardData.removeFlashcard(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final flashcards = FlashcardData.flashcards;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Flashcards', style: AppTextStyles.heading2),
      ),
      body:
          flashcards.isEmpty
              ? const EmptyState(
                icon: Icons.style_outlined,
                title: 'No flashcards yet',
                message: 'Tap the button below to add your first flashcard.',
              )
              : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  final flashcard = flashcards[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(flashcard.question, style: AppTextStyles.heading2),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 14,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  flashcard.correctAnswer,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.success,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _editFlashcard(index),
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: AppColors.secondary,
                              ),
                              label: const Text(
                                'Edit',
                                style: TextStyle(color: AppColors.secondary),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _confirmDelete(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: AppColors.error,
                              ),
                              label: const Text(
                                'Delete',
                                style: TextStyle(color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addFlashcard,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Flashcard',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
