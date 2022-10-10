import 'package:flutter_test/flutter_test.dart';
import 'package:foodr/app/app.dart';
import 'package:foodr/home/home.dart';
import 'package:meals_repository/meals_repository.dart';
import 'package:profile_repository/profile_repository.dart';

void main() {
  group('App', () {
    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        App(
          mealsRepository: MealsRepository(),
          profileRepository: ProfileRepository(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
