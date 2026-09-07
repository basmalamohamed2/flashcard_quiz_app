import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/data/flashcards_data.dart';
import 'package:flashcard_quiz_app/widgets/action_card.dart';
import 'package:flashcard_quiz_app/widgets/stat_chip.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flashcard_screen.dart';
import 'manage_flashcards_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _startQuiz() async {
    if (FlashcardData.flashcards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add a flashcard first to start the quiz.'),
        ),
      );
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FlashcardScreen()),
    );
    if (mounted) setState(() {});
  }

  Future<void> _openManageFlashcards() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ManageFlashcardsScreen()),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final total = FlashcardData.flashcards.length;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
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
                        StatChip(
                          icon: Icons.layers_rounded,
                          label: '$total card${total == 1 ? '' : 's'}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
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
                      'Test your knowledge and grow your own\nflashcard deck.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Get started', style: AppTextStyles.heading1),
                    const SizedBox(height: 16),
                    ActionCard(
                      icon: Icons.play_circle_fill_rounded,
                      title: 'Start Quiz',
                      subtitle:
                          total > 0
                              ? 'Answer $total question${total == 1 ? '' : 's'} and test yourself'
                              : 'Add some flashcards to begin',
                      color: AppColors.primary,
                      onTap: _startQuiz,
                    ),
                    const SizedBox(height: 14),
                    ActionCard(
                      icon: Icons.dashboard_customize_rounded,
                      title: 'Manage Flashcards',
                      subtitle: 'Add, edit or remove your flashcards',
                      color: AppColors.secondary,
                      onTap: _openManageFlashcards,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
