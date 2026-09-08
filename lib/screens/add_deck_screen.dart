import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/providers/app_provider.dart';
import 'package:flashcard_quiz_app/widgets/custom_button.dart';
import 'package:flashcard_quiz_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddDeckScreen extends StatefulWidget {
  const AddDeckScreen({super.key});

  @override
  State<AddDeckScreen> createState() => _AddDeckScreenState();
}

class _AddDeckScreenState extends State<AddDeckScreen> {
  final _nameController = TextEditingController();
  Color _selectedColor = AppColors.deckColors.first;
  bool _showValidation = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _showValidation = true);
      return;
    }
    await context.read<AppProvider>().addDeck(
      _nameController.text.trim(),
      _selectedColor.value,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Deck', style: AppTextStyles.heading2(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DECK NAME', style: AppTextStyles.caption(context)),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _nameController,
              icon: Icons.style_outlined,
              hasError: _showValidation && _nameController.text.trim().isEmpty,
              labelText: '',
            ),
            const SizedBox(height: 24),
            Text('COLOR', style: AppTextStyles.caption(context)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  AppColors.deckColors.map((color) {
                    final selected = _selectedColor.value == color.value;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border:
                              selected
                                  ? Border.all(color: Colors.black26, width: 2)
                                  : null,
                        ),
                        child:
                            selected
                                ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 20,
                                )
                                : null,
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Create Deck',
              icon: Icons.check_rounded,
              expand: true,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
