part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.ingredients,
  });

  final ProfileStatus status;
  final List<Ingredient>? ingredients;
  final Profile? profile;
}
