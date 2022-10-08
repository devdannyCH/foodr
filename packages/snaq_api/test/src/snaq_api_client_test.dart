// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:snaq_api/snaq_api.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late Uri mealsUri;

  group('SnaqApiClient', () {
    late Dio dio;
    late SnaqApiClient subject;

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

    const mainIngredient = Ingredient(
      name: 'Beef',
      nutrition: nutrition,
    );

    const mealComponent = MealComponent(
      mainIngredient: mainIngredient,
      supplementaryIngredients: [mainIngredient],
    );

    final meals = List.generate(
      3,
      (i) => Meal(
        id: '$i',
        created: '',
        image: '',
        mealComponents: const [
          mealComponent,
        ],
        nutrition: nutrition,
      ),
    );

    final responseData = {'meals': meals.map((meal) => meal.toJson()).toList()};

    setUp(() {
      dio = MockDio();
      subject = SnaqApiClient(dio: dio);
      mealsUri = Uri.https(SnaqApiClient.authority, '/hometask/meals');
    });

    test('constructor returns normally', () {
      expect(
        () => SnaqApiClient(dio: dio),
        returnsNormally,
      );
    });

    group('.fetchAllMeals', () {
      setUp(() {
        when(() => dio.getUri<JsonMap>(mealsUri)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: mealsUri.path),
          ),
        );
      });

      test('throws HttpException when http client throws exception', () {
        when(() => dio.getUri<JsonMap>(mealsUri)).thenThrow(Exception());

        expect(
          () => subject.fetchAllMeals(),
          throwsA(isA<HttpException>()),
        );
      });

      test(
        'throws HttpRequestFailure when response status code is not 200',
        () {
          when(() => dio.getUri<JsonMap>(mealsUri)).thenAnswer(
            (_) async => Response(
              statusCode: 400,
              requestOptions: RequestOptions(path: mealsUri.path),
            ),
          );

          expect(
            () => subject.fetchAllMeals(),
            throwsA(
              isA<HttpRequestFailure>()
                  .having((error) => error.statusCode, 'statusCode', 400),
            ),
          );
        },
      );

      test(
        'throws JsonDecodeException when decoding response fails',
        () {
          when(() => dio.getUri<JsonMap>(mealsUri)).thenAnswer(
            (_) async => Response(
              statusCode: 200,
              requestOptions: RequestOptions(path: mealsUri.path),
            ),
          );

          expect(
            () => subject.fetchAllMeals(),
            throwsA(isA<JsonDecodeException>()),
          );
        },
      );

      test(
        'throws JsonDeserializationException '
        'when deserializing json body fails',
        () {
          when(() => dio.getUri<JsonMap>(mealsUri)).thenAnswer(
            (_) async => Response(
              data: {
                'meals': [
                  {'not_a_meal': 'not at all'}
                ]
              },
              statusCode: 200,
              requestOptions: RequestOptions(path: mealsUri.path),
            ),
          );

          expect(
            () => subject.fetchAllMeals(),
            throwsA(isA<JsonDeserializationException>()),
          );
        },
      );

      test('makes correct request', () async {
        await subject.fetchAllMeals();

        verify(
          () => dio.getUri<JsonMap>(mealsUri),
        ).called(1);
      });

      test('returns correct list of meals', () {
        expect(
          subject.fetchAllMeals(),
          completion(equals(meals)),
        );
      });
    });
  });
}
