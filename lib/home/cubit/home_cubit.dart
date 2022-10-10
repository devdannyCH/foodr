import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meals_repository/meals_repository.dart';
import 'package:profile_repository/profile_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required MealsRepository mealsRepository,
    required ProfileRepository profileRepository,
  })  : _mealsRepository = mealsRepository,
        _profileRepository = profileRepository,
        super(const HomeState());

  final MealsRepository _mealsRepository;
  final ProfileRepository _profileRepository;

  Future<void> fetchAllMeals() async {
    emit(
      HomeState(
        status: HomeStatus.loading,
        meals: state.meals,
      ),
    );

    try {
      final meals = await _mealsRepository.fetchStackedMeals();
      final profile = await _profileRepository.getProfile();
      final filteredMeals = meals.where(
        (meal) {
          var respectEnergyThreshold = true;
          if (profile.energyThreshold >= Profile.maxEnergyThreshold) {
            respectEnergyThreshold = true;
          } else {
            final totalEnergy = meal.nutrition.energy.valueWithPrecision;
            respectEnergyThreshold = totalEnergy < profile.energyThreshold;
          }
          var respectBannedIngredients = true;
          for (final bannedIngredient in profile.bannedIngredients) {
            if (meal.mealComponents
                .map((mc) => mc.mainIngredient)
                .contains(bannedIngredient)) {
              respectBannedIngredients = false;
              break;
            }
          }
          return respectEnergyThreshold && respectBannedIngredients;
        },
      ).toList();
      emit(
        HomeState(
          status: HomeStatus.success,
          meals: filteredMeals,
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
