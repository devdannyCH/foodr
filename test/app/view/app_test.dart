import 'package:flutter_test/flutter_test.dart';
import 'package:foodr/app/app.dart';
import 'package:foodr/home/home.dart';
import 'package:meals_repository/meals_repository.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(App(mealsRepository: MealsRepository()));
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
