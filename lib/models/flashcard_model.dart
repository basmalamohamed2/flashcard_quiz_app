class FlashcardModel {
  final String question;
  final List<String> options;
  final String correctAnswer;

  const FlashcardModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  FlashcardModel copyWith({
    String? question,
    List<String>? options,
    String? correctAnswer,
  }) {
    return FlashcardModel(
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
    );
  }
}
