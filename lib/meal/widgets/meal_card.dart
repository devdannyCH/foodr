import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodr/l10n/l10n.dart';
import 'package:foodr/meal/meal.dart';
import 'package:meals_repository/meals_repository.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.meal,
  });
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MealCubit>(
      create: (context) => MealCubit(meal),
      child: _MealCardView(),
    );
  }
}

class _MealCardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      child: const FlipCard(
        front: _Card(child: _Content()),
        back: _Card(child: _Details()),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.background,
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: child,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final meal = context.select((MealCubit cubit) => cubit.state.meal);
    return Stack(
      children: <Widget>[
        SizedBox.expand(
          child: Image.network(
            meal.image,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Chip(
              label: Text(meal.nutrition.energy.toString()),
            ),
          ),
        ),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 16),
        _MealDetailsFilter(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: _DetailsContent(),
          ),
        ),
      ],
    );
  }
}

class _DetailsContent extends StatelessWidget {
  const _DetailsContent();

  @override
  Widget build(BuildContext context) {
    final meal = context.select((MealCubit cubit) => cubit.state.meal);
    return BlocBuilder<MealCubit, MealState>(
      builder: (context, state) {
        switch (state.selectedDetails) {
          case MealDetails.macros:
            return const MacrosChart();
          case MealDetails.components:
            return Column(
              children: [
                const Expanded(child: _MealComponentsList()),
                Chip(
                  label: Text(meal.nutrition.energy.toString()),
                ),
              ],
            );
        }
      },
    );
  }
}

class _MealDetailsFilter extends StatelessWidget {
  const _MealDetailsFilter();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<MealCubit, MealState>(
      builder: (context, state) {
        final isSelected =
            MealDetails.values.map((e) => e == state.selectedDetails).toList();
        return ToggleButtons(
          onPressed: (int index) {
            context.read<MealCubit>().selectDetails(MealDetails.values[index]);
          },
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          borderColor: colorScheme.outline,
          selectedBorderColor: colorScheme.outline,
          selectedColor: colorScheme.onSecondaryContainer,
          fillColor: colorScheme.secondaryContainer,
          color: colorScheme.onSurface,
          constraints: BoxConstraints(
            minHeight: 40,
            minWidth: (MediaQuery.of(context).size.width - 72) / 2,
          ),
          isSelected: isSelected,
          children: [
            Text(l10n.mealMacros),
            Text(l10n.mealIngredients),
          ],
        );
      },
    );
  }
}

class _MealComponentsList extends StatelessWidget {
  const _MealComponentsList();

  @override
  Widget build(BuildContext context) {
    final mealComponents = context
        .read<MealCubit>()
        .state
        .meal
        .mealComponents
        .where((mc) => mc.mainIngredient != null)
        .toList();
    return ListView.builder(
      itemCount: mealComponents.length,
      itemBuilder: (context, index) {
        final mainIngredient = mealComponents[index].mainIngredient!;
        return IngredientTile(
          ingredient: mainIngredient,
        );
      },
    );
  }
}
