// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:snaq_api/snaq_api.dart';

/// Thrown when an error occurs while looking up rockets.
class MealsException implements Exception {}

/// {@template meals_repository}
/// A repository that handles meals related requests.
/// {@endtemplate}
class MealsRepository {
  /// {@macro meals_repository}
  MealsRepository({SnaqApiClient? snaqApiClient})
      : _snaqApiClient = snaqApiClient ?? SnaqApiClient();

  final SnaqApiClient _snaqApiClient;

  /// Returns a list of all SNAQ meals.
  ///
  /// Throws a [MealsException] if an error occurs.
  Future<List<Meal>> fetchAllMeals() {
    try {
      return _snaqApiClient.fetchAllMeals();
    } on Exception {
      throw MealsException();
    }
  }
}
