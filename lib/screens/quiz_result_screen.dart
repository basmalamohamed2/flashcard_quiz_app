import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/screens/flashcard_screen.dart';
import 'package:flashcard_quiz_app/screens/home_screen.dart';
import 'package:flashcard_quiz_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class QuizResultScreen extends StatelessWidget {
  final String deckId;
  final int score;
  final int total;

  const QuizResultScreen({
    super.key,
    required this.deckId,
    required this.score,
    required this.total,
  });

  double get _percentage => total == 0 ? 0 : score / total;

  String get _message {
    final pct = _percentage * 100;
    if (pct >= 80) return 'Excellent work!';
    if (pct >= 50) return 'Good job, keep going!';
    return "Keep practicing, you'll get there!";
  }

  IconData get _icon {
    final pct = _percentage * 100;
    if (pct >= 80) return Icons.emoji_events_rounded;
    if (pct >= 50) return Icons.thumb_up_rounded;
    return Icons.trending_up_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final pct = (_percentage * 100).round();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: AppColors.heroLinearGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_icon, color: Colors.white, size: 32),
                    const SizedBox(height: 6),
                    Text(
                      '$pct%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                _message,
                style: AppTextStyles.heading1(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You answered $score out of $total questions correctly.',
                style: AppTextStyles.bodySecondary(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Retry Quiz',
                icon: Icons.refresh_rounded,
                expand: true,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FlashcardScreen(deckId: deckId),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Back to Home',
                icon: Icons.home_rounded,
                variant: ButtonVariant.outline,
                expand: true,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
