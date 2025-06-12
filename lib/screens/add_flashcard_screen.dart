import 'package:flashcard_quiz_app/constants/app_colors.dart';
import 'package:flashcard_quiz_app/data/flashcards_data.dart';
import 'package:flutter/material.dart';

class AddFlashcardScreen extends StatefulWidget {
  const AddFlashcardScreen({super.key});

  @override
  State<AddFlashcardScreen> createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _addFlashcard() {
    if (_questionController.text.isNotEmpty && _answerController.text.isNotEmpty) {
      setState(() {
        FlashcardData.flashcards.add({
          'question': _questionController.text,
          'answer': _answerController.text,
        });
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.appBackgroundGradient, 
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Question', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _answerController,
                decoration: const InputDecoration(labelText: 'Answer', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                onPressed: _addFlashcard,
                child: const Text('Save', style: TextStyle(color: AppColors.backgroundColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}