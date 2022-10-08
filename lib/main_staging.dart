import 'package:flutter/material.dart';
import 'package:foodr/app/app.dart';
import 'package:foodr/bootstrap.dart';
import 'package:meals_repository/meals_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final mealsRepository = MealsRepository();
  await bootstrap(() => App(mealsRepository: mealsRepository));
}
