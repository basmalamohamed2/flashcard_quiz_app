import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/constants/context_extensions.dart';
import 'package:flashcard_quiz_app/providers/app_provider.dart';
import 'package:flashcard_quiz_app/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<AppProvider>().history;

    final totalAttempts = history.length;
    final avgScore =
        totalAttempts == 0
            ? 0.0
            : history.fold<double>(0, (sum, h) => sum + (h.score / h.total)) /
                totalAttempts *
                100;

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics', style: AppTextStyles.heading2(context)),
      ),
      body:
          history.isEmpty
              ? const EmptyState(
                icon: Icons.bar_chart_rounded,
                title: 'No quiz history yet',
                message: 'Complete a quiz to see your stats here.',
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.quiz_rounded,
                            label: 'Quizzes taken',
                            value: '$totalAttempts',
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.trending_up_rounded,
                            label: 'Average score',
                            value: '${avgScore.round()}%',
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final attempt = history[index];
                        final pct =
                            attempt.total == 0
                                ? 0
                                : (attempt.score / attempt.total * 100).round();
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: context.colorSurface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: context.colorBorder),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$pct%',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      attempt.deckName,
                                      style: AppTextStyles.heading2(context),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${attempt.score}/${attempt.total} correct · ${_formatDate(attempt.date)}',
                                      style: AppTextStyles.bodySecondary(
                                        context,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.heading1(context)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySecondary(context)),
        ],
      ),
    );
  }
}
