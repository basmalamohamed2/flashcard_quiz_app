import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/providers/app_provider.dart';
import 'package:flashcard_quiz_app/utils/flashcard_parser.dart';
import 'package:flashcard_quiz_app/widgets/custom_button.dart';
import 'package:flashcard_quiz_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImportDeckScreen extends StatefulWidget {
  const ImportDeckScreen({super.key});

  @override
  State<ImportDeckScreen> createState() => _ImportDeckScreenState();
}

class _ImportDeckScreenState extends State<ImportDeckScreen> {
  final _nameController = TextEditingController();
  String? _fileName;
  ParseResult? _result;
  bool _showValidation = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'csv'],
      withData: true,
    );
    if (result == null || result.files.single.bytes == null) return;

    final content = utf8.decode(result.files.single.bytes!);
    final parsed = parseFlashcardsFromText(content);
    final fileName = result.files.single.name;

    setState(() {
      _fileName = fileName;
      _result = parsed;
      if (_nameController.text.trim().isEmpty) {
        final dotIndex = fileName.lastIndexOf('.');
        _nameController.text =
            dotIndex > 0 ? fileName.substring(0, dotIndex) : fileName;
      }
    });
  }

  Future<void> _import() async {
    final result = _result;
    final name = _nameController.text.trim();
    if (result == null || result.cards.isEmpty || name.isEmpty) {
      setState(() => _showValidation = true);
      return;
    }

    final color =
        AppColors.deckColors[name.hashCode % AppColors.deckColors.length];
    await context.read<AppProvider>().addDeckWithCards(
      name,
      color.value,
      result.cards,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;

    return Scaffold(
      appBar: AppBar(
        title: Text('Import Deck', style: AppTextStyles.heading2(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FILE FORMAT', style: AppTextStyles.caption(context)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload a .txt or .csv file with one question per line:',
                    style: AppTextStyles.bodySecondary(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Question | Option A | Option B | Option C | Correct Answer',
                    style: AppTextStyles.body(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Example:\nCapital of France? | Paris | Rome | Berlin | Paris',
                    style: AppTextStyles.bodySecondary(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('DECK NAME', style: AppTextStyles.caption(context)),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _nameController,
              icon: Icons.style_outlined,
              hasError: _showValidation && _nameController.text.trim().isEmpty,
              labelText: '',
            ),
            const SizedBox(height: 20),
            Text('FILE', style: AppTextStyles.caption(context)),
            const SizedBox(height: 8),
            CustomButton(
              text: _fileName ?? 'Choose File',
              icon: Icons.upload_file_rounded,
              variant: ButtonVariant.outline,
              expand: true,
              onPressed: _pickFile,
            ),
            if (result != null) ...[
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    result.cards.isNotEmpty
                        ? Icons.check_circle
                        : Icons.error_outline,
                    color:
                        result.cards.isNotEmpty
                            ? AppColors.success
                            : AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${result.cards.length} question${result.cards.length == 1 ? '' : 's'} parsed successfully'
                      '${result.errors.isNotEmpty ? ', ${result.errors.length} line(s) skipped.' : '.'}',
                      style: AppTextStyles.bodySecondary(context),
                    ),
                  ),
                ],
              ),
              if (result.errors.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...result.errors
                    .take(5)
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 4, left: 28),
                        child: Text(
                          '• $e',
                          style: AppTextStyles.bodySecondary(
                            context,
                          ).copyWith(color: AppColors.error),
                        ),
                      ),
                    ),
              ],
            ],
            const SizedBox(height: 32),
            CustomButton(
              text: 'Import Deck',
              icon: Icons.check_rounded,
              expand: true,
              enabled: result != null && result.cards.isNotEmpty,
              onPressed: _import,
            ),
          ],
        ),
      ),
    );
  }
}
