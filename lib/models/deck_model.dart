import 'package:flashcard_quiz_app/models/flashcard_model.dart';

class DeckModel {
  final String id;
  final String name;
  final int colorValue;
  final List<FlashcardModel> cards;

  const DeckModel({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.cards,
  });

  DeckModel copyWith({
    String? name,
    int? colorValue,
    List<FlashcardModel>? cards,
  }) {
    return DeckModel(
      id: id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      cards: cards ?? this.cards,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'colorValue': colorValue,
    'cards': cards.map((c) => c.toJson()).toList(),
  };

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      id: json['id'] as String,
      name: json['name'] as String,
      colorValue: json['colorValue'] as int? ?? 0xFF5B5FEF,
      cards:
          (json['cards'] as List)
              .map((c) => FlashcardModel.fromJson(c as Map<String, dynamic>))
              .toList(),
    );
  }
}
