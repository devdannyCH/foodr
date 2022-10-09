import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodr/home/home.dart';
import 'package:foodr/l10n/l10n.dart';
import 'package:meals_repository/meals_repository.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryCubit>(
      create: (context) => HistoryCubit(
        mealsRepository: context.read<MealsRepository>(),
      )..loadMeals(),
      child: const HistoryView(),
    );
  }
}

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: _Content(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((HistoryCubit cubit) => cubit.state.status);
    switch (status) {
      case HistoryStatus.initial:
        return const SizedBox(
          key: Key('historyViewinitial_sizedBox'),
        );
      case HistoryStatus.loading:
        return const Center(
          key: Key('historyViewloading_indicator'),
          child: CircularProgressIndicator.adaptive(),
        );
      case HistoryStatus.failure:
        return Center(
          key: const Key('historyViewfailure_text'),
          child: Text(
            l10n.homeMealsFetchErrorMessage,
            textAlign: TextAlign.center,
          ),
        );
      case HistoryStatus.success:
        return Column(
          children: [
            Center(
              child: _MealsFilter(
                key: const Key('historyViewsuccess_mealsFilter'),
              ),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: _MealList(
                key: Key('historyViewsuccess_mealsStack'),
              ),
            )
          ],
        );
    }
  }
}

class _MealList extends StatelessWidget {
  const _MealList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10 = context.l10n;
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final meals = state.meals ?? [];
        if (meals.isEmpty) {
          return Center(
            child: Text(l10.historyNoMealMessage),
          );
        }
        return ListView(
          key: UniqueKey(),
          children: [
            for (final meal in meals) MealCard(meal: meal),
          ],
        );
      },
    );
  }
}

class _MealsFilter extends StatelessWidget {
  _MealsFilter({super.key});

  final List<Widget> mealsCategories = <Widget>[
    Row(
      children: const [
        Icon(Icons.favorite),
      ],
    ),
    Row(
      children: const [
        Icon(Icons.close),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final isSelected =
            HistoryFilter.values.map((e) => e == state.filter).toList();
        return ToggleButtons(
          onPressed: (int index) {
            context
                .read<HistoryCubit>()
                .updateFilter(HistoryFilter.values[index]);
          },
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          borderColor: colorScheme.outline,
          selectedBorderColor: colorScheme.outline,
          selectedColor: colorScheme.onSecondaryContainer,
          fillColor: colorScheme.secondaryContainer,
          color: colorScheme.onSurface,
          constraints: BoxConstraints(
            minHeight: 40,
            minWidth: (MediaQuery.of(context).size.width - 32) / 2,
          ),
          isSelected: isSelected,
          children: mealsCategories,
        );
      },
    );
  }
}
