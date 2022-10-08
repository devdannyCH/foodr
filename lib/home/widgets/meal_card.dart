import 'package:flutter/material.dart';
import 'package:meals_repository/meals_repository.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.meal,
  });
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final unit =
        meal.nutrition.energy.abbreviation.unit.toString().split('.').last;
    final kcal = meal.nutrition.energy.value;
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Image.network(
              meal.image,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Chip(
                label: Text('$kcal $unit'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
