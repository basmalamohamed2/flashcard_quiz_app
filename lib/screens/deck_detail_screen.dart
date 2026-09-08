import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/constants/context_extensions.dart';
import 'package:flashcard_quiz_app/providers/app_provider.dart';
import 'package:flashcard_quiz_app/screens/flashcard_form_screen.dart';
import 'package:flashcard_quiz_app/screens/flashcard_screen.dart';
import 'package:flashcard_quiz_app/widgets/custom_button.dart';
import 'package:flashcard_quiz_app/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeckDetailScreen extends StatelessWidget {
  final String deckId;

  const DeckDetailScreen({super.key, required this.deckId});

  Future<void> _confirmDeleteCard(BuildContext context, String cardId) async {
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
    if (confirmed == true && context.mounted) {
      await context.read<AppProvider>().removeFlashcard(deckId, cardId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final deck = provider.deckById(deckId);

    if (deck == null) {
      return const Scaffold(body: Center(child: Text('Deck not found.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(deck.name, style: AppTextStyles.heading2(context)),
      ),
      body: Column(
        children: [
          if (deck.cards.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: CustomButton(
                text:
                    'Start Quiz (${deck.cards.length} question${deck.cards.length == 1 ? '' : 's'})',
                icon: Icons.play_circle_fill_rounded,
                expand: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FlashcardScreen(deckId: deckId),
                    ),
                  );
                },
              ),
            ),
          Expanded(
            child:
                deck.cards.isEmpty
                    ? const EmptyState(
                      icon: Icons.note_add_outlined,
                      title: 'No flashcards yet',
                      message:
                          'Tap the button below to add your first flashcard.',
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                      itemCount: deck.cards.length,
                      itemBuilder: (context, index) {
                        final card = deck.cards[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.colorSurface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  context.isDarkMode ? 0.2 : 0.04,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.question,
                                style: AppTextStyles.heading2(context),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
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
                                            card.correctAnswer,
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      card.isDue
                                          ? 'Due for review'
                                          : 'Box ${card.box}/5',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => FlashcardFormScreen(
                                                deckId: deckId,
                                                existingFlashcard: card,
                                              ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                      color: AppColors.secondary,
                                    ),
                                    label: const Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed:
                                        () => _confirmDeleteCard(
                                          context,
                                          card.id,
                                        ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FlashcardFormScreen(deckId: deckId),
            ),
          );
        },
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
