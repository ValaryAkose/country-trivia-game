import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guess_correctly/app.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(TriviaApp(prefs: prefs));
    await tester.pumpAndSettle();

    expect(find.text('Country Trivia'), findsOneWidget);
  });
}
