import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodr/home/home.dart';
import 'package:foodr/l10n/l10n.dart';
import 'package:meals_repository/meals_repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
        // leading: IconButton(
        //   onPressed: () => debugPrint('profile'),
        //   icon: const Icon(Icons.person),
        // ),
        title: Icon(Icons.restaurant, color: Theme.of(context).primaryColor),
        actions: [
          IconButton(
            onPressed: () {
              showCupertinoModalBottomSheet<void>(
                context: context,
                elevation: 1,
                topRadius: const Radius.circular(28),
                backgroundColor: Theme.of(context).colorScheme.surface,
                builder: (context) => Column(
                  children: const [
                    DragHandle(),
                    Expanded(child: HistoryPage()),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.view_agenda),
          ),
        ],
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
              Center(child: Text(l10n.homeNoMealMessage)),
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
                  switch (direction) {
                    case SwipeDirection.left:
                      context.read<HomeCubit>().dislike(meals[index]);
                      break;
                    case SwipeDirection.right:
                      context.read<HomeCubit>().like(meals[index]);
                      break;
                    case SwipeDirection.up:
                      break;
                    case SwipeDirection.down:
                      break;
                  }
                },
                builder: (context, properties) {
                  return Center(
                    child: MealCard(
                      meal: meals[properties.index],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: 'left',
                onPressed: () =>
                    controller.next(swipeDirection: SwipeDirection.left),
                child: const Icon(Icons.close),
              ),
              FloatingActionButton(
                heroTag: 'reset',
                onPressed: () => context.read<HomeCubit>().reset(),
                child: const Icon(Icons.restart_alt),
              ),
              FloatingActionButton(
                heroTag: 'right',
                onPressed: () =>
                    controller.next(swipeDirection: SwipeDirection.right),
                child: const Icon(Icons.favorite),
              ),
            ],
          ),
        )
      ],
    );
  }
}
