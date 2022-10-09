import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodr/home/home.dart';
import 'package:foodr/main_development.dart';
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
    final meal = context.read<MealCubit>().state.meal;
    final energyUnit =
        meal.nutrition.energy.abbreviation.unit.toString().split('.').last;
    final energy = meal.nutrition.energy.value;
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
              label: Text('$energy $energyUnit'),
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
      children: [
        const SizedBox(height: 16),
        _MealDetailsFilter(),
        const Expanded(
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
    return BlocBuilder<MealCubit, MealState>(
      builder: (context, state) {
        switch (state.selectedDetails) {
          case MealDetails.macros:
            return const MacrosChart();
          case MealDetails.components:
            return const _MealComponentsList();
        }
      },
    );
  }
}

class _MealDetailsFilter extends StatelessWidget {
  _MealDetailsFilter();

  final List<Widget> mealDetails = <Widget>[
    const Text('Macros'),
    const Text('Components'),
  ];

  @override
  Widget build(BuildContext context) {
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
          children: mealDetails,
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
        return ListTile(
          title: Text(mainIngredient.name),
          subtitle: Row(
            children: [
              Text(mainIngredient.nutrition.carbohydrates.toString()),
              const SizedBox(width: 8),
              Text(mainIngredient.nutrition.protein.toString()),
              const SizedBox(width: 8),
              Text(mainIngredient.nutrition.fatTotal.toString()),
            ],
          ),
          trailing: Text(mainIngredient.nutrition.energy.toString()),
        );
      },
    );
  }
}
