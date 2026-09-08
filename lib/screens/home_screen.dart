import 'package:flashcard_quiz_app/providers/app_provider.dart';
import 'package:flashcard_quiz_app/screens/add_deck_screen.dart';
import 'package:flashcard_quiz_app/screens/deck_detail_screen.dart';
import 'package:flashcard_quiz_app/screens/import_deck_screen.dart';
import 'package:flashcard_quiz_app/screens/settings_screen.dart';
import 'package:flashcard_quiz_app/screens/statistics_screen.dart';
import 'package:flashcard_quiz_app/widgets/deck_card.dart';
import 'package:flashcard_quiz_app/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/widgets/stat_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _addDeck(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddDeckScreen()),
    );
  }

  Future<void> _importDeck(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ImportDeckScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final decks = provider.decks;
    final totalCards = provider.totalCards;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                decoration: const BoxDecoration(
                  gradient: AppColors.heroLinearGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.style_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const StatisticsScreen(),
                                    ),
                                  ),
                              icon: const Icon(
                                Icons.bar_chart_rounded,
                                color: Colors.white,
                              ),
                              tooltip: 'Statistics',
                            ),
                            IconButton(
                              onPressed:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SettingsScreen(),
                                    ),
                                  ),
                              icon: const Icon(
                                Icons.settings_rounded,
                                color: Colors.white,
                              ),
                              tooltip: 'Settings',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'QuizDeck',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Organize your flashcards into decks and\ntest your knowledge.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 16),
                    StatChip(
                      icon: Icons.layers_rounded,
                      label:
                          '${decks.length} deck${decks.length == 1 ? '' : 's'} · $totalCards card${totalCards == 1 ? '' : 's'}',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Text(
                  'Your decks',
                  style: AppTextStyles.heading1(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _importDeck(context),
                        icon: const Icon(Icons.upload_file_rounded, size: 18),
                        label: const Text('Import File'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => _addDeck(context),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('New Deck'),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (decks.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: EmptyState(
                    icon: Icons.style_outlined,
                    title: 'No decks yet',
                    message:
                        'Create a deck or import questions from a file to get started.',
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children:
                        decks
                            .map(
                              (deck) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: DeckCard(
                                  deck: deck,
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => DeckDetailScreen(
                                                deckId: deck.id,
                                              ),
                                        ),
                                      ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
