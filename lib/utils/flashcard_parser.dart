import 'package:flashcard_quiz_app/models/flashcard_model.dart';
import 'package:uuid/uuid.dart';

class ParseResult {
  final List<FlashcardModel> cards;
  final List<String> errors;

  const ParseResult({required this.cards, required this.errors});
}

ParseResult parseFlashcardsFromText(String content) {
  const uuid = Uuid();
  final now = DateTime.now();
  final cards = <FlashcardModel>[];
  final errors = <String>[];

  final lines = content.split(RegExp(r'\r?\n'));

  for (var i = 0; i < lines.length; i++) {
    final rawLine = lines[i].trim();
    if (rawLine.isEmpty || rawLine.startsWith('#')) continue;

    final parts = rawLine.split('|').map((p) => p.trim()).toList();

    if (parts.length < 5) {
      errors.add(
        'Line ${i + 1}: expected "Question | Option A | Option B | Option C | Correct Answer", '
        'found ${parts.length} part(s).',
      );
      continue;
    }

    final question = parts[0];
    final options = parts.sublist(1, 4);
    final correctAnswer = parts[4];

    if (question.isEmpty ||
        options.any((o) => o.isEmpty) ||
        correctAnswer.isEmpty) {
      errors.add(
        'Line ${i + 1}: question, options, and correct answer cannot be empty.',
      );
      continue;
    }

    if (!options.contains(correctAnswer)) {
      errors.add(
        'Line ${i + 1}: correct answer must exactly match one of the 3 options.',
      );
      continue;
    }

    cards.add(
      FlashcardModel(
        id: uuid.v4(),
        question: question,
        options: options,
        correctAnswer: correctAnswer,
        nextReview: now,
      ),
    );
  }

  return ParseResult(cards: cards, errors: errors);
}
