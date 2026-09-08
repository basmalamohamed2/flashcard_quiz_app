class FlashcardModel {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final int box;
  final DateTime nextReview;
  final int correctCount;
  final int wrongCount;

  const FlashcardModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.box = 1,
    required this.nextReview,
    this.correctCount = 0,
    this.wrongCount = 0,
  });

  bool get isDue => !nextReview.isAfter(DateTime.now());

  FlashcardModel copyWith({
    String? question,
    List<String>? options,
    String? correctAnswer,
    int? box,
    DateTime? nextReview,
    int? correctCount,
    int? wrongCount,
  }) {
    return FlashcardModel(
      id: id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      box: box ?? this.box,
      nextReview: nextReview ?? this.nextReview,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
    );
  }

  FlashcardModel withAnswer(bool wasCorrect) {
    const boxIntervalDays = [0, 1, 3, 7, 14, 30]; // index == box (1..5)
    final newBox = wasCorrect ? (box + 1).clamp(1, 5) : 1;
    final interval = boxIntervalDays[newBox];

    return copyWith(
      box: newBox,
      nextReview: DateTime.now().add(Duration(days: interval)),
      correctCount: wasCorrect ? correctCount + 1 : correctCount,
      wrongCount: wasCorrect ? wrongCount : wrongCount + 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'options': options,
    'correctAnswer': correctAnswer,
    'box': box,
    'nextReview': nextReview.toIso8601String(),
    'correctCount': correctCount,
    'wrongCount': wrongCount,
  };

  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    return FlashcardModel(
      id: json['id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correctAnswer'] as String,
      box: json['box'] as int? ?? 1,
      nextReview:
          DateTime.tryParse(json['nextReview'] as String? ?? '') ??
          DateTime.now(),
      correctCount: json['correctCount'] as int? ?? 0,
      wrongCount: json['wrongCount'] as int? ?? 0,
    );
  }
}
