part of 'history_cubit.dart';

enum HistoryStatus { initial, loading, success, failure }

enum HistoryFilter { liked, disliked }

class HistoryState extends Equatable {
  const HistoryState({
    this.status = HistoryStatus.initial,
    this.filter = HistoryFilter.liked,
    this.meals,
  });

  final HistoryStatus status;
  final HistoryFilter filter;
  final List<Meal>? meals;

  @override
  List<Object?> get props => [status, meals, filter];
}
