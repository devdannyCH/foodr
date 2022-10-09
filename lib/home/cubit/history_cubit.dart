import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meals_repository/meals_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({
    required MealsRepository mealsRepository,
  })  : _mealsRepository = mealsRepository,
        super(const HistoryState());

  final MealsRepository _mealsRepository;

  Future<void> updateFilter(HistoryFilter filter) async {
    emit(
      HistoryState(
        filter: filter,
        status: state.status,
        meals: state.meals,
      ),
    );
    await loadMeals();
  }

  Future<void> loadMeals() async {
    emit(
      HistoryState(
        status: HistoryStatus.loading,
        meals: state.meals,
        filter: state.filter,
      ),
    );
    try {
      List<Meal> meals;
      switch (state.filter) {
        case HistoryFilter.liked:
          meals = await _mealsRepository.fetchLikedMeals();
          break;
        case HistoryFilter.disliked:
          meals = await _mealsRepository.fetchDislikedMeals();
          break;
      }
      emit(
        HistoryState(
          status: HistoryStatus.success,
          meals: meals,
          filter: state.filter,
        ),
      );
    } on Exception {
      emit(
        HistoryState(
          status: HistoryStatus.failure,
          meals: state.meals,
          filter: state.filter,
        ),
      );
    }
  }
}
