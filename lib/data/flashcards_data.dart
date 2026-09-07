import 'package:flashcard_quiz_app/models/flashcard_model.dart';

class FlashcardData {
  FlashcardData._();

  static final List<FlashcardModel> flashcards = [
    const FlashcardModel(
      question: 'What does HTML stand for?',
      options: [
        'HyperText Markup Language',
        'High Tech Modern Language',
        'Hyper Transfer Markup Language',
      ],
      correctAnswer: 'HyperText Markup Language',
    ),
    const FlashcardModel(
      question: 'What is a variable in programming?',
      options: [
        'A named storage location for data',
        'A type of loop',
        'A function name',
      ],
      correctAnswer: 'A named storage location for data',
    ),
    const FlashcardModel(
      question: 'What does CSS do?',
      options: [
        'It styles and lays out web pages',
        'It creates databases',
        'It runs server-side code',
      ],
      correctAnswer: 'It styles and lays out web pages',
    ),
    const FlashcardModel(
      question: 'What is a function in programming?',
      options: [
        'A block of code designed to perform a specific task',
        'A data type',
        'A variable name',
      ],
      correctAnswer: 'A block of code designed to perform a specific task',
    ),
    const FlashcardModel(
      question: 'What is the purpose of a loop?',
      options: [
        'To repeat a set of instructions until a condition is met',
        'To store data',
        'To define a class',
      ],
      correctAnswer: 'To repeat a set of instructions until a condition is met',
    ),
  ];

  static void addFlashcard(FlashcardModel flashcard) {
    flashcards.add(flashcard);
  }

  static void updateFlashcard(int index, FlashcardModel flashcard) {
    if (index >= 0 && index < flashcards.length) {
      flashcards[index] = flashcard;
    }
  }

  static void removeFlashcard(int index) {
    if (index >= 0 && index < flashcards.length) {
      flashcards.removeAt(index);
    }
  }
}
