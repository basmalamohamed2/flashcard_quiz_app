# QuizDeck

A Flutter flashcard and quiz app that lets you build decks of flashcards and study them using a spaced repetition system (Leitner boxes).

## Features

- **Deck management**: create and delete decks, each with a name and a custom color.
- **Flashcard management**: add/edit/delete multiple-choice cards (question + 3 options + correct answer).
- **Bulk import from text**: import a batch of flashcards at once using a simple pipe-delimited format:
  ```
  Question | Option 1 | Option 2 | Option 3 | Correct Answer
  ```
  Blank lines and lines starting with `#` are treated as comments and skipped.
- **Interactive quiz mode**: run a quiz on a deck's cards and get a score at the end.
- **Attempt history & statistics**: the last 50 quiz attempts are saved, plus overall stats (total cards, performance, etc.).
- **Dark mode**: toggle between light and dark themes, with the preference persisted.
- **Local persistence**: all data (decks, cards, history, settings) is stored locally on-device via `shared_preferences`.

## Tech Stack

- **Framework**: Flutter
- **State management**: Provider (`ChangeNotifier`)
- **Storage**: `shared_preferences` (local JSON storage)
- **ID generation**: `uuid`

### Folder Structure

```
lib/
├── main.dart                  # App entry point
├── constants/                 # Colors, text styles, theme, and extensions
├── models/                    # FlashcardModel, DeckModel, QuizAttemptModel
├── providers/                 # AppProvider for state management and persistence
├── screens/                   # App screens (home, deck, quiz, settings...)
├── widgets/                   # Reusable UI components
├── utils/                     # Helpers such as flashcard_parser
└── test/                      # Tests (SRS logic + widget test)
```

### Key Screens

| Screen | Purpose |
|---|---|
| `splash_screen` | App splash/loading screen |
| `home_screen` | List of decks |
| `add_deck_screen` | Create a new deck |
| `deck_detail_screen` | Deck details and its cards |
| `flashcard_form_screen` | Add/edit a flashcard |
| `import_deck_screen` | Import cards from text |
| `flashcard_screen` | Run the quiz |
| `quiz_result_screen` | Quiz results |
| `statistics_screen` | Overall statistics |
| `settings_screen` | Settings (dark mode, etc.) |

## Requirements

- Flutter SDK
- The following packages in `pubspec.yaml`:
  - `provider`
  - `shared_preferences`
  - `uuid`

> Note: the uploaded archive contains only the `lib/` folder. Make sure you have a `pubspec.yaml` that declares the package name `flashcard_quiz_app` (used in the imports) along with the dependencies above before running the project.

## Getting Started

```bash
flutter pub get
flutter run
```

## Running Tests

```bash
flutter test
```

There's a dedicated test for the spaced repetition logic (`flashcard_srs_test.dart`) plus a basic widget test.