import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
      final meals = await _mealsRepository.fetchAllMeals();
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
}
