import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodr/meal/meal.dart';

class MacrosChart extends StatelessWidget {
  const MacrosChart({super.key});

  @override
  Widget build(BuildContext context) {
    final nutrition =
        context.select((MealCubit cubit) => cubit.state.meal.nutrition);
    final radius = MediaQuery.of(context).size.width / 3;
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 0,
              sections: [
                // ignore: lines_longer_than_80_chars
                PieChartSectionData(
                  showTitle: true,
                  title: nutrition.carbohydrates.toString(),
                  value: nutrition.carbohydrates.valueWithPrecision,
                  color: const Color(0xFFcdb4db),
                  radius: radius,
                ),
                PieChartSectionData(
                  showTitle: true,
                  title: nutrition.protein.toString(),
                  value: nutrition.protein.valueWithPrecision,
                  color: const Color(0xFFffafcc),
                  radius: radius,
                ),
                PieChartSectionData(
                  showTitle: true,
                  title: nutrition.fatTotal.toString(),
                  value: nutrition.fatTotal.valueWithPrecision,
                  color: const Color(0xFFa2d2ff),
                  radius: radius,
                ),
              ],
            ),
          ),
        ),
        Chip(
          label: Text(nutrition.energy.toString()),
        ),
      ],
    );
  }
}
