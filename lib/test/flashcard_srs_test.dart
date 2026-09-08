import 'package:flashcard_quiz_app/models/flashcard_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Flashcard spaced repetition', () {
    test('correct answer promotes the box and pushes review date forward', () {
      final card = FlashcardModel(
        id: '1',
        question: 'Q',
        options: const ['A', 'B'],
        correctAnswer: 'A',
        box: 1,
        nextReview: DateTime.now(),
      );

      final updated = card.withAnswer(true);

      expect(updated.box, 2);
      expect(updated.correctCount, 1);
      expect(updated.wrongCount, 0);
      expect(updated.nextReview.isAfter(DateTime.now()), isTrue);
    });

    test('wrong answer resets the box back to 1', () {
      final card = FlashcardModel(
        id: '1',
        question: 'Q',
        options: const ['A', 'B'],
        correctAnswer: 'A',
        box: 4,
        nextReview: DateTime.now(),
      );

      final updated = card.withAnswer(false);

      expect(updated.box, 1);
      expect(updated.wrongCount, 1);
      expect(updated.correctCount, 0);
    });

    test('box never exceeds the maximum of 5', () {
      final card = FlashcardModel(
        id: '1',
        question: 'Q',
        options: const ['A', 'B'],
        correctAnswer: 'A',
        box: 5,
        nextReview: DateTime.now(),
      );

      final updated = card.withAnswer(true);

      expect(updated.box, 5);
    });
  });
}
