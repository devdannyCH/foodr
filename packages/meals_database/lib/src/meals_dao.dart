import 'package:meals_database/meals_database.dart';
import 'package:sembast/sembast.dart';
import 'package:snaq_api/snaq_api.dart';

/// Meal persistence operations
class MealsDao {
  final _store = intMapStoreFactory.store('Meals');

  Future<Database> get _db async => MealsDatabase.instance.database;

  /// Insert a meal
  Future<void> insert(Meal meal) async {
    await _store.add(await _db, meal.toJson());
  }

  /// Insert a list of meals
  Future<void> insertAll(List<Meal> meals) async {
    await _store.addAll(await _db, meals.map((meal) => meal.toJson()).toList());
  }

  /// Update a meal
  Future<void> update(Meal meal) async {
    final finder = Finder(filter: Filter.byKey(meal.id));
    await _store.update(await _db, meal.toJson(), finder: finder);
  }

  /// Delete a meal
  Future<void> delete(Meal meal) async {
    final finder = Finder(filter: Filter.byKey(meal.id));
    await _store.delete(await _db, finder: finder);
  }

  /// Delete all meals
  Future<void> clear() async {
    await _store.delete(await _db);
  }

  /// Get all meals
  Future<List<Meal>> getAll() async {
    final recordSnapshot = await _store.find(await _db);
    return recordSnapshot.map((snapshot) {
      final meal = Meal.fromJson(snapshot.value);
      return meal;
    }).toList();
  }
}
