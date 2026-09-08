import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/constants/app_text_styles.dart';
import 'package:flashcard_quiz_app/models/flashcard_model.dart';
import 'package:flashcard_quiz_app/providers/app_provider.dart';
import 'package:flashcard_quiz_app/widgets/custom_button.dart';
import 'package:flashcard_quiz_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FlashcardFormScreen extends StatefulWidget {
  final String deckId;
  final FlashcardModel? existingFlashcard;

  const FlashcardFormScreen({
    super.key,
    required this.deckId,
    this.existingFlashcard,
  });

  bool get isEditing => existingFlashcard != null;

  @override
  State<FlashcardFormScreen> createState() => _FlashcardFormScreenState();
}

class _FlashcardFormScreenState extends State<FlashcardFormScreen> {
  late final TextEditingController _questionController;
  late final TextEditingController _option1Controller;
  late final TextEditingController _option2Controller;
  late final TextEditingController _option3Controller;
  String? _selectedCorrectAnswer;
  bool _showValidation = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingFlashcard;
    _questionController = TextEditingController(text: existing?.question ?? '');
    _option1Controller = TextEditingController(
      text:
          existing != null && existing.options.isNotEmpty
              ? existing.options[0]
              : '',
    );
    _option2Controller = TextEditingController(
      text:
          existing != null && existing.options.length > 1
              ? existing.options[1]
              : '',
    );
    _option3Controller = TextEditingController(
      text:
          existing != null && existing.options.length > 2
              ? existing.options[2]
              : '',
    );
    _selectedCorrectAnswer = existing?.correctAnswer;

    for (final controller in [
      _option1Controller,
      _option2Controller,
      _option3Controller,
    ]) {
      controller.addListener(_onOptionsChanged);
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _option3Controller.dispose();
    super.dispose();
  }

  void _onOptionsChanged() {
    final options = _currentOptions;
    if (_selectedCorrectAnswer != null &&
        !options.contains(_selectedCorrectAnswer)) {
      setState(() => _selectedCorrectAnswer = null);
    } else {
      setState(() {});
    }
  }

  List<String> get _currentOptions => [
    _option1Controller.text,
    _option2Controller.text,
    _option3Controller.text,
  ];

  bool get _isValid {
    final options = _currentOptions;
    return _questionController.text.trim().isNotEmpty &&
        options.every((option) => option.trim().isNotEmpty) &&
        _selectedCorrectAnswer != null;
  }

  Future<void> _save() async {
    if (!_isValid) {
      setState(() => _showValidation = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all fields and select the correct answer.',
          ),
        ),
      );
      return;
    }

    final provider = context.read<AppProvider>();

    if (widget.isEditing) {
      final updated = widget.existingFlashcard!.copyWith(
        question: _questionController.text.trim(),
        options: _currentOptions.map((option) => option.trim()).toList(),
        correctAnswer: _selectedCorrectAnswer!.trim(),
      );
      await provider.updateFlashcard(widget.deckId, updated);
    } else {
      final newCard = FlashcardModel(
        id: const Uuid().v4(),
        question: _questionController.text.trim(),
        options: _currentOptions.map((option) => option.trim()).toList(),
        correctAnswer: _selectedCorrectAnswer!.trim(),
        nextReview: DateTime.now(),
      );
      await provider.addFlashcard(widget.deckId, newCard);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final options = _currentOptions;
    final hasAnyOption = options.any((option) => option.trim().isNotEmpty);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Flashcard' : 'Add Flashcard',
          style: AppTextStyles.heading2(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QUESTION', style: AppTextStyles.caption(context)),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _questionController,
              labelText: 'e.g. What does HTML stand for?',
              icon: Icons.help_outline_rounded,
              maxLines: 2,
              hasError:
                  _showValidation && _questionController.text.trim().isEmpty,
            ),
            const SizedBox(height: 20),
            Text('OPTIONS', style: AppTextStyles.caption(context)),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _option1Controller,
              labelText: 'Option A',
              icon: Icons.looks_one_outlined,
              hasError:
                  _showValidation && _option1Controller.text.trim().isEmpty,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _option2Controller,
              labelText: 'Option B',
              icon: Icons.looks_two_outlined,
              hasError:
                  _showValidation && _option2Controller.text.trim().isEmpty,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _option3Controller,
              labelText: 'Option C',
              icon: Icons.looks_3_outlined,
              hasError:
                  _showValidation && _option3Controller.text.trim().isEmpty,
            ),
            const SizedBox(height: 20),
            Text('CORRECT ANSWER', style: AppTextStyles.caption(context)),
            const SizedBox(height: 10),
            if (hasAnyOption)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    options
                        .asMap()
                        .entries
                        .where((entry) => entry.value.trim().isNotEmpty)
                        .map((entry) {
                          final idx = entry.key;
                          final option = entry.value;
                          final letter = String.fromCharCode(65 + idx);
                          final selected = _selectedCorrectAnswer == option;
                          return ChoiceChip(
                            label: Text('$letter: $option'),
                            selected: selected,
                            onSelected: (_) {
                              setState(() => _selectedCorrectAnswer = option);
                            },
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color:
                                  selected
                                      ? Colors.white
                                      : AppTextStyles.body(context).color,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color:
                                    selected
                                        ? AppColors.primary
                                        : AppColors.disabled,
                              ),
                            ),
                          );
                        })
                        .toList(),
              )
            else
              Text(
                'Fill in the options above to choose the correct answer.',
                style: AppTextStyles.bodySecondary(context),
              ),
            const SizedBox(height: 32),
            CustomButton(
              text: widget.isEditing ? 'Save Changes' : 'Add Flashcard',
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
