import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/data/flashcards_data.dart';
import 'package:flashcard_quiz_app/screens/manage_flashcards_screen.dart';
import 'package:flashcard_quiz_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class AddFlashcardScreen extends StatefulWidget {
  const AddFlashcardScreen({super.key});

  @override
  State<AddFlashcardScreen> createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final _questionController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();
  String? _selectedCorrectAnswer;

  @override
  void initState() {
    super.initState();
    _option1Controller.addListener(_updateDropdown);
    _option2Controller.addListener(_updateDropdown);
    _option3Controller.addListener(_updateDropdown);
  }

  @override
  void dispose() {
    _questionController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _option3Controller.dispose();
    super.dispose();
  }

  void _updateDropdown() {
    setState(() {});
  }

  void _addFlashcard() {
    final options = [
      _option1Controller.text,
      _option2Controller.text,
      _option3Controller.text,
    ];
    if (_questionController.text.isNotEmpty &&
        options.every((option) => option.isNotEmpty) &&
        _selectedCorrectAnswer != null) {
      setState(() {
        FlashcardData.flashcards.add({
          'question': _questionController.text,
          'options': options,
          'correctAnswer': _selectedCorrectAnswer,
        });
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ManageFlashcardsScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select a correct answer.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.appBackgroundGradient),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: _questionController,
                  labelText: 'Question',
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _option1Controller,
                  labelText: 'Option 1',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _option2Controller,
                  labelText: 'Option 2',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _option3Controller,
                  labelText: 'Option 3',
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  hint: const Text(
                    'Select Correct Answer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  value: _selectedCorrectAnswer,
                  items: [
                    if (_option1Controller.text.isNotEmpty)
                      DropdownMenuItem(
                        value: _option1Controller.text,
                        child: Text(_option1Controller.text),
                      ),
                    if (_option2Controller.text.isNotEmpty)
                      DropdownMenuItem(
                        value: _option2Controller.text,
                        child: Text(_option2Controller.text),
                      ),
                    if (_option3Controller.text.isNotEmpty)
                      DropdownMenuItem(
                        value: _option3Controller.text,
                        child: Text(_option3Controller.text),
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCorrectAnswer = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  onPressed: _addFlashcard,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: AppColors.backgroundColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
