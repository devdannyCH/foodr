import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meals_repository/meals_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required MealsRepository mealsRepository,
  })  : _mealsRepository = mealsRepository,
        super(const ProfileState());

  final MealsRepository _mealsRepository;

  Future<void> fetchAllIngredients() async {
    emit(
      ProfileState(
        status: ProfileStatus.loading,
        ingredients: state.ingredients,
      ),
    );

    try {
      final ingredients = await _mealsRepository.fetchAllIngredients();
      emit(
        ProfileState(
          status: ProfileStatus.success,
          ingredients: ingredients,
        ),
      );
    } on Exception {
      emit(
        ProfileState(
          status: ProfileStatus.failure,
          ingredients: state.ingredients,
        ),
      );
    }
  }

  Future<void> reset() async {
    await _mealsRepository.reset();
  }
}
