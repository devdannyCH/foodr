import 'package:bloc/bloc.dart';
import 'package:meals_repository/meals_repository.dart';
import 'package:profile_repository/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required ProfileRepository profileRepository,
    required MealsRepository mealsRepository,
  })  : _mealsRepository = mealsRepository,
        _profileRepository = profileRepository,
        super(const ProfileState());

  final ProfileRepository _profileRepository;
  final MealsRepository _mealsRepository;

  Future<void> loadPreferences() async {
    emit(
      ProfileState(
        status: ProfileStatus.loading,
        ingredients: state.ingredients,
        profile: state.profile,
      ),
    );

    try {
      final ingredients = await _mealsRepository.fetchAllIngredients();
      final profile = await _profileRepository.getProfile();
      emit(
        ProfileState(
          status: ProfileStatus.success,
          ingredients: ingredients,
          profile: profile,
        ),
      );
    } on Exception {
      emit(
        ProfileState(
          status: ProfileStatus.failure,
          ingredients: state.ingredients,
          profile: state.profile,
        ),
      );
    }
  }

  Future<void> updateEnergyThreshold(double threshold) async {
    try {
      final newProfile = Profile(
        energyThreshold: threshold,
        bannedIngredients: state.profile!.bannedIngredients,
      );
      await _profileRepository.updateProfile(newProfile);
      emit(
        ProfileState(
          status: state.status,
          ingredients: state.ingredients,
          profile: newProfile,
        ),
      );
    } on Exception {
      emit(
        ProfileState(
          status: ProfileStatus.failure,
          ingredients: state.ingredients,
          profile: state.profile,
        ),
      );
    }
  }

  Future<void> toggleBannedIngredients(Ingredient ingredient) async {
    try {
      final bannedIngredients =
          Set<Ingredient>.from(state.profile!.bannedIngredients);
      if (bannedIngredients.contains(ingredient)) {
        bannedIngredients.remove(ingredient);
      } else {
        bannedIngredients.add(ingredient);
      }
      final newProfile = Profile(
        energyThreshold: state.profile?.energyThreshold ?? double.maxFinite,
        bannedIngredients: bannedIngredients,
      );
      await _profileRepository.updateProfile(newProfile);
      emit(
        ProfileState(
          status: state.status,
          ingredients: state.ingredients,
          profile: newProfile,
        ),
      );
    } on Exception {
      emit(
        ProfileState(
          status: ProfileStatus.failure,
          ingredients: state.ingredients,
          profile: state.profile,
        ),
      );
    }
  }

  Future<void> reset() async {
    await _mealsRepository.reset();
  }
}
