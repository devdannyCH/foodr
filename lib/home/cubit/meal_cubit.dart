import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meals_repository/meals_repository.dart';

part 'meal_state.dart';

class MealCubit extends Cubit<MealState> {
  MealCubit(Meal meal) : super(MealState(meal: meal));

  void selectDetails(MealDetails details) => emit(
        MealState(
          meal: state.meal,
          selectedDetails: details,
        ),
      );
}
