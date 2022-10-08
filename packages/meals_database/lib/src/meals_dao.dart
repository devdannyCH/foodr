import 'package:meals_database/meals_database.dart';
import 'package:sembast/sembast.dart';
import 'package:snaq_api/snaq_api.dart';

/// Meal persistence operations
class MealsDao {
  /// {@macro meals_dao}
  MealsDao({required String folderName})
      : _store = intMapStoreFactory.store(folderName);

  // Store where data is stored
  final StoreRef<int, Map<String, Object?>> _store;

  Future<Database> get _db async => MealsDatabase.instance.database;

  /// Insert a meal
  Future<void> insert(Meal meal) async {
    await _store.add(await _db, meal.toJson());
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

  /// Get all meals
  Future<List<Meal>> getAll() async {
    final recordSnapshot = await _store.find(await _db);
    return recordSnapshot.map((snapshot) {
      final meal = Meal.fromJson(snapshot.value);
      return meal;
    }).toList();
  }
}
