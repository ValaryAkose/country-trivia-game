import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guess_correctly/app.dart';

import 'helpers/fakes.dart';

void main() {
  testWidgets('App launches and shows the home screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      TriviaApp(
        prefs: prefs,
        countryRepositoryOverride: FakeCountryRepository(),
        gameRepositoryOverride: FakeGameRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Country Trivia'), findsOneWidget);
    expect(find.text('Play'), findsOneWidget);
  });

  testWidgets('Home screen shows retry state when the API fails', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      TriviaApp(
        prefs: prefs,
        countryRepositoryOverride:
            FakeCountryRepository(error: Exception('boom')),
        gameRepositoryOverride: FakeGameRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Oops! Something went wrong'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
