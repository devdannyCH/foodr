// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:meals_database/meals_database.dart';
import 'package:snaq_api/snaq_api.dart';

/// Thrown when an error occurs while looking up rockets.
class MealsException implements Exception {}

/// {@template meals_repository}
/// A repository that handles meals related requests.
/// {@endtemplate}
class MealsRepository {
  /// {@macro meals_repository}
  MealsRepository({
    SnaqApiClient? snaqApiClient,
    MealsDao? mealsDao,
  })  : _snaqApiClient = snaqApiClient ?? SnaqApiClient(),
        _mealsDao = mealsDao ?? MealsDao();

  final SnaqApiClient _snaqApiClient;
  final MealsDao _mealsDao;

  /// Returns a list of all SNAQ meals.
  ///
  /// Throws a [MealsException] if an error occurs.
  Future<List<Meal>> fetchAllMeals() async {
    try {
      final remoteMeals = await _snaqApiClient.fetchAllMeals();
      final localMeals = await _mealsDao.getAll();
      for (var i = 0; i < remoteMeals.length; i++) {
        var isNew = true;
        for (var j = 0; j < localMeals.length; j++) {
          if (remoteMeals[i].id == localMeals[j].id) {
            isNew = false;
            final updatedMeal = remoteMeals[i];
            // ignore: cascade_invocations
            updatedMeal.status = localMeals[j].status;
            await _mealsDao.update(updatedMeal);
          }
        }
        if (isNew) {
          await _mealsDao.insert(remoteMeals[i]);
        }
      }
      final newMeals = await _mealsDao.getAll();
      return newMeals;
    } on Exception {
      throw MealsException();
    }
  }

  /// Like a meal
  Future<void> like(Meal meal) async {
    meal.status = MealStatus.liked;
    await _mealsDao.update(meal);
  }

  /// Dislike a meal
  Future<void> dislike(Meal meal) async {
    meal.status = MealStatus.disliked;
    await _mealsDao.update(meal);
  }

  /// Delete a meal from history
  Future<void> delete(Meal meal) async {
    await _mealsDao.delete(meal);
  }
}
