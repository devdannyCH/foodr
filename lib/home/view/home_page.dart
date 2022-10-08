import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodr/home/home.dart';
import 'package:foodr/l10n/l10n.dart';
import 'package:meals_repository/meals_repository.dart';
import 'package:swipable_stack/swipable_stack.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
        mealsRepository: context.read<MealsRepository>(),
      )..fetchAllMeals(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.restaurant, color: Theme.of(context).primaryColor),
      ),
      body: const SafeArea(
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
    final status = context.select((HomeCubit cubit) => cubit.state.status);

    switch (status) {
      case HomeStatus.initial:
        return const SizedBox(
          key: Key('homeView_initial_sizedBox'),
        );
      case HomeStatus.loading:
        return const Center(
          key: Key('homeView_loading_indicator'),
          child: CircularProgressIndicator.adaptive(),
        );
      case HomeStatus.failure:
        return Center(
          key: const Key('homeView_failure_text'),
          child: Text(
            l10n.homeMealsFetchErrorMessage,
            textAlign: TextAlign.center,
          ),
        );
      case HomeStatus.success:
        return const _MealStack(
          key: Key('homeView_success_mealsStack'),
        );
    }
  }
}

class _MealStack extends StatelessWidget {
  const _MealStack({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final meals = context.select((HomeCubit cubit) => cubit.state.meals!);
    final controller = SwipableStackController();
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Center(child: Text(l10n.noMealMessage)),
              SwipableStack(
                itemCount: meals.length,
                detectableSwipeDirections: const {
                  SwipeDirection.right,
                  SwipeDirection.left,
                },
                controller: controller,
                allowVerticalSwipe: false,
                onSwipeCompleted: (index, direction) {
                  if (kDebugMode) {
                    print('$index, $direction');
                  }
                },
                builder: (context, properties) {
                  return MealCard(
                    meal: meals[properties.index],
                  );
                },
              ),
            ],
          ),
        ),
        Visibility(
          visible: controller.currentIndex < meals.length,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () =>
                      controller.next(swipeDirection: SwipeDirection.left),
                  child: const Icon(Icons.close),
                ),
                FloatingActionButton(
                  onPressed: () =>
                      controller.next(swipeDirection: SwipeDirection.right),
                  child: const Icon(Icons.favorite),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
