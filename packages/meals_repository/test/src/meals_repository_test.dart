import 'dart:ffi';

import 'package:flutter_test/flutter_test.dart';
import 'package:meals_database/meals_database.dart';
import 'package:meals_repository/meals_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:snaq_api/snaq_api.dart';

class MockSnaqApiClient extends Mock implements SnaqApiClient {}

class MockMealsDao extends Mock implements MealsDao {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('MealsRepisotiry', () {
    late SnaqApiClient snaqApiClient;
    late MealsDao mealsDao;
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
      mealsDao = MockMealsDao();
      when(() => snaqApiClient.fetchAllMeals()).thenAnswer((_) async => meals);
      when(() => mealsDao.getAll()).thenAnswer((_) async => meals);
      subject =
          MealsRepository(snaqApiClient: snaqApiClient, mealsDao: mealsDao);
    });

    test('constructor returns normally', () {
      expect(
        MealsRepository.new,
        returnsNormally,
      );
    });

    group('.fetchAllMeals', () {
      test('throws mealsException when api throws an exception', () async {
        when(() => snaqApiClient.fetchAllMeals()).thenThrow(Exception());

        expect(
          () => subject.fetchStackedMeals(),
          throwsA(isA<MealsException>()),
        );

        verify(() => snaqApiClient.fetchAllMeals()).called(1);
      });
    });
  });
}
