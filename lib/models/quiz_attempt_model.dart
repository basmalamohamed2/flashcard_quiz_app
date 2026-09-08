class QuizAttemptModel {
  final String deckId;
  final String deckName;
  final int score;
  final int total;
  final DateTime date;

  const QuizAttemptModel({
    required this.deckId,
    required this.deckName,
    required this.score,
    required this.total,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'deckId': deckId,
    'deckName': deckName,
    'score': score,
    'total': total,
    'date': date.toIso8601String(),
  };

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) {
    return QuizAttemptModel(
      deckId: json['deckId'] as String,
      deckName: json['deckName'] as String,
      score: json['score'] as int,
      total: json['total'] as int,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
