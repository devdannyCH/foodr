import 'package:meals_repository/meals_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:snaq_api/snaq_api.dart';
import 'package:test/test.dart';

class MockSnaqApiClient extends Mock implements SnaqApiClient {}

void main() {
  group('MealsRepisotiry', () {
    late SnaqApiClient snaqApiClient;
    late MealsRepository subject;

    const abbreviation = Abbreviation(
      nutrient: Nutrient.protein,
      unit: AbbreviationUnit.kcal,
    );

    const nutritionComponent = NutritionComponent(
      abbreviation: abbreviation,
      name: Name.protein,
      unit: Unit.kilocalories,
      value: 4,
      valueWithPrecision: 4.04,
    );

    const nutrition = Nutrition(
      carbohydrates: nutritionComponent,
      fatTotal: nutritionComponent,
      protein: nutritionComponent,
      energy: nutritionComponent,
    );

    final meals = List.generate(
      3,
      (i) => Meal(
        id: '$i',
        created: '',
        image: '',
        mealComponents: const [],
        nutrition: nutrition,
      ),
    );

    setUp(() {
      snaqApiClient = MockSnaqApiClient();
      when(() => snaqApiClient.fetchAllMeals()).thenAnswer((_) async => meals);

      subject = MealsRepository(snaqApiClient: snaqApiClient);
    });

    test('constructor returns normally', () {
      expect(
        MealsRepository.new,
        returnsNormally,
      );
    });

    group('.fetchAllMeals', () {
      test('throws RocketsException when api throws an exception', () async {
        when(() => snaqApiClient.fetchAllMeals()).thenThrow(Exception());

        expect(
          () => subject.fetchStackedMeals(),
          throwsA(isA<MealsException>()),
        );

        verify(() => snaqApiClient.fetchAllMeals()).called(1);
      });

      test('makes correct request', () async {
        await subject.fetchStackedMeals();

        verify(() => snaqApiClient.fetchAllMeals()).called(1);
      });
    });
  });
}
