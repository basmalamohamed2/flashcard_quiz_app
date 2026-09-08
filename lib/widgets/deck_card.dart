import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/constants/context_extensions.dart';
import 'package:flashcard_quiz_app/models/deck_model.dart';
import 'package:flutter/material.dart';

class DeckCard extends StatelessWidget {
  final DeckModel deck;
  final VoidCallback onTap;

  const DeckCard({super.key, required this.deck, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Color(deck.colorValue);
    final dueCount = deck.cards.where((c) => c.isDue).length;
    final cardCount = deck.cards.length;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: context.colorSurface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(context.isDarkMode ? 0.25 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.style_rounded, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(deck.name, style: AppTextStyles.heading2(context)),
                  const SizedBox(height: 4),
                  Text(
                    '$cardCount card${cardCount == 1 ? '' : 's'}'
                    '${dueCount > 0 ? ' · $dueCount due for review' : ''}',
                    style: AppTextStyles.bodySecondary(context),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: context.colorTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
