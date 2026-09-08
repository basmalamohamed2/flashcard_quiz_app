import 'dart:convert';

import 'package:flashcard_quiz_app/models/deck_model.dart';
import 'package:flashcard_quiz_app/models/flashcard_model.dart';
import 'package:flashcard_quiz_app/models/quiz_attempt_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppProvider extends ChangeNotifier {
  static const _decksKey = 'quizdeck_decks_v1';
  static const _darkModeKey = 'quizdeck_dark_mode_v1';
  static const _historyKey = 'quizdeck_history_v1';

  final _uuid = const Uuid();

  List<DeckModel> _decks = [];
  bool _isDarkMode = false;
  List<QuizAttemptModel> _history = [];
  bool _isLoaded = false;

  List<DeckModel> get decks => List.unmodifiable(_decks);
  bool get isDarkMode => _isDarkMode;
  List<QuizAttemptModel> get history => List.unmodifiable(_history);
  bool get isLoaded => _isLoaded;

  int get totalCards => _decks.fold(0, (sum, deck) => sum + deck.cards.length);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;

    final decksString = prefs.getString(_decksKey);
    if (decksString != null) {
      final decoded = jsonDecode(decksString) as List;
      _decks =
          decoded
              .map((d) => DeckModel.fromJson(d as Map<String, dynamic>))
              .toList();
    } else {
      _decks = [];
    }

    final historyString = prefs.getString(_historyKey);
    if (historyString != null) {
      final decoded = jsonDecode(historyString) as List;
      _history =
          decoded
              .map((h) => QuizAttemptModel.fromJson(h as Map<String, dynamic>))
              .toList();
    }

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _saveDecks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_decks.map((d) => d.toJson()).toList());
    await prefs.setString(_decksKey, encoded);
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_history.map((h) => h.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  DeckModel? deckById(String deckId) {
    for (final deck in _decks) {
      if (deck.id == deckId) return deck;
    }
    return null;
  }

  Future<void> addDeck(String name, int colorValue) async {
    _decks.add(
      DeckModel(id: _uuid.v4(), name: name, colorValue: colorValue, cards: []),
    );
    notifyListeners();
    await _saveDecks();
  }

  Future<void> addDeckWithCards(
    String name,
    int colorValue,
    List<FlashcardModel> cards,
  ) async {
    _decks.add(
      DeckModel(
        id: _uuid.v4(),
        name: name,
        colorValue: colorValue,
        cards: cards,
      ),
    );
    notifyListeners();
    await _saveDecks();
  }

  Future<void> deleteDeck(String deckId) async {
    _decks.removeWhere((d) => d.id == deckId);
    notifyListeners();
    await _saveDecks();
  }

  Future<void> addFlashcard(String deckId, FlashcardModel flashcard) async {
    final index = _decks.indexWhere((d) => d.id == deckId);
    if (index == -1) return;
    final deck = _decks[index];
    _decks[index] = deck.copyWith(cards: [...deck.cards, flashcard]);
    notifyListeners();
    await _saveDecks();
  }

  Future<void> updateFlashcard(String deckId, FlashcardModel flashcard) async {
    final deckIndex = _decks.indexWhere((d) => d.id == deckId);
    if (deckIndex == -1) return;
    final deck = _decks[deckIndex];
    final cardIndex = deck.cards.indexWhere((c) => c.id == flashcard.id);
    if (cardIndex == -1) return;
    final newCards = [...deck.cards];
    newCards[cardIndex] = flashcard;
    _decks[deckIndex] = deck.copyWith(cards: newCards);
    notifyListeners();
    await _saveDecks();
  }

  Future<void> removeFlashcard(String deckId, String cardId) async {
    final deckIndex = _decks.indexWhere((d) => d.id == deckId);
    if (deckIndex == -1) return;
    final deck = _decks[deckIndex];
    final newCards = deck.cards.where((c) => c.id != cardId).toList();
    _decks[deckIndex] = deck.copyWith(cards: newCards);
    notifyListeners();
    await _saveDecks();
  }

  Future<void> recordAnswer(
    String deckId,
    String cardId,
    bool wasCorrect,
  ) async {
    final deckIndex = _decks.indexWhere((d) => d.id == deckId);
    if (deckIndex == -1) return;
    final deck = _decks[deckIndex];
    final cardIndex = deck.cards.indexWhere((c) => c.id == cardId);
    if (cardIndex == -1) return;
    final newCards = [...deck.cards];
    newCards[cardIndex] = newCards[cardIndex].withAnswer(wasCorrect);
    _decks[deckIndex] = deck.copyWith(cards: newCards);
    notifyListeners();
    await _saveDecks();
  }

  Future<void> recordQuizAttempt(QuizAttemptModel attempt) async {
    _history = [attempt, ..._history];
    if (_history.length > 50) {
      _history = _history.sublist(0, 50);
    }
    notifyListeners();
    await _saveHistory();
  }
}
