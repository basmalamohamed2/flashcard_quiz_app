import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flashcard_quiz_app/main.dart';
import 'package:flashcard_quiz_app/providers/app_provider.dart';

void main() {
  testWidgets('App shows the splash screen with the app name', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider()..load(),
        child: const MyApp(),
      ),
    );

    expect(find.text('QuizDeck'), findsOneWidget);
  });
}
