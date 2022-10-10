import 'package:flutter/material.dart';
import 'package:meals_repository/meals_repository.dart';

class IngredientTile extends StatelessWidget {
  const IngredientTile({
    super.key,
    required this.ingredient,
    this.onTap,
    this.selected = false,
    this.selectedTileColor,
    this.selectedColor,
  });

  final Ingredient ingredient;
  final void Function()? onTap;
  final bool selected;
  final Color? selectedTileColor;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: selected,
      selectedColor: selectedColor,
      selectedTileColor: selectedTileColor,
      title: Text(ingredient.name),
      subtitle: Row(
        children: [
          Text(ingredient.nutrition.carbohydrates.toString()),
          const SizedBox(width: 8),
          Text(ingredient.nutrition.protein.toString()),
          const SizedBox(width: 8),
          Text(ingredient.nutrition.fatTotal.toString()),
        ],
      ),
      trailing: Text(ingredient.nutrition.energy.toString()),
    );
  }
}
