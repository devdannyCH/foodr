part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.ingredients,
  });

  final ProfileStatus status;
  final List<Ingredient>? ingredients;

  @override
  List<Object?> get props => [status, ingredients];
}
