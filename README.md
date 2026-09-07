# QuizDeck

A polished, cross-platform flashcard quiz app built with **Flutter**. Create your own
flashcards, quiz yourself with instant feedback, and track your score — all with a
clean, modern UI.

## Features

- **Animated splash screen** with a custom brand identity
- **Interactive quiz mode**: progress bar, per-question feedback (correct/incorrect
  highlighting), and a results screen with a score summary
- **Full flashcard management**: add, edit, and delete flashcards with confirmation
  dialogs and inline validation
- **Custom design system**: shared color palette, typography (Google Fonts —
  Poppins & Inter), and reusable UI components (buttons, text fields, cards, chips)
- Runs on **Android, iOS, Web, Windows, macOS, and Linux** from a single codebase

## Tech Stack

- [Flutter](https://flutter.dev) / Dart
- [google_fonts](https://pub.dev/packages/google_fonts) for typography
- Material 3 design components

## Project Structure

```
lib/
├── constants/        # Color palette & text styles (design system)
├── models/           # Flashcard data model
├── data/             # In-memory flashcard repository
├── widgets/          # Reusable UI components (buttons, tiles, cards, etc.)
├── screens/          # App screens (splash, home, quiz, results, manage, form)
└── main.dart         # App entry point & theming
```

## Getting Started

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## What This Project Demonstrates

- Clean, componentized Flutter architecture (models, data layer, reusable widgets)
- Custom theming and a consistent design system
- State management with `StatefulWidget` and `setState`
- Form validation and user feedback (snackbars, confirmation dialogs)
- Attention to UX details: empty states, disabled states, and animated transitions
