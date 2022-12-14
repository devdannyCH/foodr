import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodr/history/history.dart';
import 'package:foodr/home/home.dart';
import 'package:foodr/l10n/l10n.dart';
import 'package:foodr/meal/meal.dart';
import 'package:foodr/profile/profile.dart';
import 'package:meals_repository/meals_repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:swipable_stack/swipable_stack.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
        mealsRepository: context.read<MealsRepository>(),
        profileRepository: context.read<ProfileRepository>(),
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
        leading: IconButton(
          onPressed: () {
            _displayBottomSheet(
              context,
              BlocProvider.value(
                value: context.read<HomeCubit>(),
                child: const ProfilePage(),
              ),
            );
          },
          icon: const Icon(Icons.person),
        ),
        title: Icon(Icons.restaurant, color: Theme.of(context).primaryColor),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _displayBottomSheet(context, const HistoryPage()),
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

Future<void> _displayBottomSheet(BuildContext context, Widget widget) async {
  return showCupertinoModalBottomSheet<void>(
    context: context,
    elevation: 1,
    topRadius: const Radius.circular(28),
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context) => Column(
      children: [
        const DragHandle(),
        Expanded(child: widget),
      ],
    ),
  );
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
