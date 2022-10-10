import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meals_repository/meals_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required MealsRepository mealsRepository,
  })  : _mealsRepository = mealsRepository,
        super(const HomeState());

  final MealsRepository _mealsRepository;

  Future<void> fetchAllMeals() async {
    emit(
      HomeState(
        status: HomeStatus.loading,
        meals: state.meals,
      ),
    );

    try {
      final meals = await _mealsRepository.fetchStackedMeals();
      emit(
        HomeState(
          status: HomeStatus.success,
          meals: meals,
        ),
      );
    } on Exception {
      emit(
        HomeState(
          status: HomeStatus.failure,
          meals: state.meals,
        ),
      );
    }
  }

  Future<void> like(Meal meal) async {
    await _mealsRepository.like(meal);
  }

  Future<void> dislike(Meal meal) async {
    await _mealsRepository.dislike(meal);
  }

  Future<void> reset() async {
    if (!isClosed) {
      await _mealsRepository.reset();
      await fetchAllMeals();
    } else {
      debugPrint('home_cubit closed');
    }
  }
}
