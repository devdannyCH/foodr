part of 'meal_cubit.dart';

enum MealDetails { macros, components }

class MealState extends Equatable {
  const MealState({
    required this.meal,
    this.selectedDetails = MealDetails.macros,
  });

  final Meal meal;
  final MealDetails selectedDetails;

  @override
  List<Object?> get props => [meal, selectedDetails];
}
