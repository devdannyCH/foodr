import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodr/home/home.dart';
import 'package:foodr/l10n/l10n.dart';
import 'package:foodr/meal/meal.dart' show IngredientTile;
import 'package:foodr/profile/profile.dart';
import 'package:meals_repository/meals_repository.dart';
import 'package:profile_repository/profile_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(
        mealsRepository: context.read<MealsRepository>(),
        profileRepository: context.read<ProfileRepository>(),
      )..loadPreferences(),
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
        return Center(
          key: const Key('profileView_failure_text'),
          child: Text(
            l10n.profileNoIngredientMessage,
            textAlign: TextAlign.center,
          ),
        );
      case ProfileStatus.success:
        return Column(
          children: [
            ColoredBox(
              color: Theme.of(context).colorScheme.background,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.profileSelectEnergyThreshold,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const _EnergySlider(
                    key: Key('profileView_success_energySlider'),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.profileTapTobanIngredients,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: _IngredientsList(
                key: Key('profileView_success_ingredientsList'),
              ),
            ),
          ],
        );
    }
  }
}

class _EnergySlider extends StatelessWidget {
  const _EnergySlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Container(
          height: 32,
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(Profile.minEnergyThreshold.toInt().toString()),
              Expanded(
                child: Slider(
                  // ignore: avoid_redundant_argument_values
                  min: Profile.minEnergyThreshold,
                  max: Profile.maxEnergyThreshold,
                  value: state.profile!.energyThreshold,
                  onChanged: (newThreshold) => context
                      .read<ProfileCubit>()
                      .updateEnergyThreshold(newThreshold)
                      .then(
                        (_) => context.read<HomeCubit>().fetchAllMeals(),
                      ),
                ),
              ),
              Text('>${Profile.maxEnergyThreshold.toInt()}'),
            ],
          ),
        );
      },
    );
  }
}

class _IngredientsList extends StatelessWidget {
  const _IngredientsList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final ingredients = state.ingredients!;
        final bannedIngredients = state.profile!.bannedIngredients;
        if (ingredients.isEmpty) {
          return Text(
            l10n.profileNoIngredientMessage,
            textAlign: TextAlign.center,
          );
        }
        return ListView(
          key: UniqueKey(),
          children: [
            for (final ingredient in ingredients)
              IngredientTile(
                onTap: () => context
                    .read<ProfileCubit>()
                    .toggleBannedIngredients(ingredient)
                    .then(
                      (_) => context.read<HomeCubit>().fetchAllMeals(),
                    ),
                selected: bannedIngredients.contains(ingredient),
                selectedColor: Theme.of(context).colorScheme.onErrorContainer,
                selectedTileColor: Theme.of(context).colorScheme.errorContainer,
                ingredient: ingredient,
              ),
          ],
        );
      },
    );
  }
}
