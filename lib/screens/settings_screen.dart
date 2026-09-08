import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/constants/context_extensions.dart';
import 'package:flashcard_quiz_app/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.heading2(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('APPEARANCE', style: AppTextStyles.caption(context)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: context.colorSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.colorBorder),
            ),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Dark mode', style: AppTextStyles.body(context)),
              subtitle: Text(
                'Easier on the eyes at night',
                style: AppTextStyles.bodySecondary(context),
              ),
              value: provider.isDarkMode,
              activeColor: AppColors.primary,
              onChanged: (value) => provider.toggleDarkMode(value),
            ),
          ),
        ],
      ),
    );
  }
}
