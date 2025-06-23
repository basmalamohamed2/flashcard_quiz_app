class FlashcardData {
  static List<Map<String, dynamic>> flashcards = [
    {
      'question': 'What does HTML stand for?',
      'options': ['HyperText Markup Language', 'High Tech Modern Language', 'Hyper Transfer Markup Language'],
      'correctAnswer': 'HyperText Markup Language'
    },
    {
      'question': 'What is a variable in programming?',
      'options': ['A named storage location for data', 'A type of loop', 'A function name'],
      'correctAnswer': 'A named storage location for data'
    },
    {
      'question': 'What does CSS do?',
      'options': ['It styles and layouts web pages', 'It creates databases', 'It runs server-side code'],
      'correctAnswer': 'It styles and layouts web pages'
    },
    {
      'question': 'What is a function in programming?',
      'options': ['A block of code designed to perform a specific task', 'A data type', 'A variable name'],
      'correctAnswer': 'A block of code designed to perform a specific task'
    },
    {
      'question': 'What is the purpose of a loop?',
      'options': ['To repeat a set of instructions until a condition is met', 'To store data', 'To define a class'],
      'correctAnswer': 'To repeat a set of instructions until a condition is met'
    },
  ];

  static void addFlashcard(Map<String, dynamic> flashcard) {
    flashcards.add(flashcard);
  }

  static void removeFlashcard(int index) {
    if (index >= 0 && index < flashcards.length) {
      flashcards.removeAt(index);
    }
  }
}