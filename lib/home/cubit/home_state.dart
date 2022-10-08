part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.meals,
  });

  final HomeStatus status;
  final List<Meal>? meals;

  @override
  List<Object?> get props => [status, meals];
}
