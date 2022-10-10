import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodr/home/home.dart';
import 'package:foodr/l10n/l10n.dart';
import 'package:foodr/meal/meal.dart' show IngredientTile;
import 'package:foodr/profile/profile.dart';
import 'package:meals_repository/meals_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) =>
          ProfileCubit(mealsRepository: context.read<MealsRepository>())
            ..fetchAllIngredients(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(child: _Content()),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () => context.read<HomeCubit>().reset(),
                child: const Text('Reset demo data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((ProfileCubit cubit) => cubit.state.status);

    switch (status) {
      case ProfileStatus.initial:
        return const SizedBox(
          key: Key('profileView_initial_sizedBox'),
        );
      case ProfileStatus.loading:
        return const Center(
          key: Key('profileView_loading_indicator'),
          child: CircularProgressIndicator.adaptive(),
        );
      case ProfileStatus.failure:
        return const Center(
          key: Key('profileView_failure_text'),
          child: Text(
            'No ingredients',
            textAlign: TextAlign.center,
          ),
        );
      case ProfileStatus.success:
        return const _IngredientsList(
          key: Key('profileView_success_ingredientsList'),
        );
    }
  }
}

class _IngredientsList extends StatelessWidget {
  const _IngredientsList({super.key});

  @override
  Widget build(BuildContext context) {
    final ingredients =
        context.select((ProfileCubit cubit) => cubit.state.ingredients!);
    return ListView(
      children: [
        for (final ingredient in ingredients)
          IngredientTile(ingredient: ingredient),
      ],
    );
  }
}
