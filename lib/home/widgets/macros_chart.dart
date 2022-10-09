import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodr/home/home.dart';

class MacrosChart extends StatelessWidget {
  const MacrosChart({super.key});

  @override
  Widget build(BuildContext context) {
    final meal = context.read<MealCubit>().state.meal;
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
                  title:
                      '${meal.nutrition.carbohydrates.value}${meal.nutrition.carbohydrates.abbreviation.unit.name}',
                  value: meal.nutrition.carbohydrates.valueWithPrecision,
                  color: const Color(0xFFcdb4db),
                  radius: radius,
                ),
                PieChartSectionData(
                  showTitle: true,
                  title:
                      '${meal.nutrition.protein.value}${meal.nutrition.protein.abbreviation.unit.name}',
                  value: meal.nutrition.protein.valueWithPrecision,
                  color: const Color(0xFFffafcc),
                  radius: radius,
                ),
                PieChartSectionData(
                  showTitle: true,
                  title:
                      '${meal.nutrition.fatTotal.value}${meal.nutrition.fatTotal.abbreviation.unit.name}',
                  value: meal.nutrition.fatTotal.valueWithPrecision,
                  color: const Color(0xFFa2d2ff),
                  radius: radius,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _Indicator(
                label: meal.nutrition.carbohydrates.abbreviation.nutrient.name
                    .capitalize(),
                color: const Color(0xFFcdb4db),
              ),
              const Spacer(),
              _Indicator(
                label: meal.nutrition.protein.abbreviation.nutrient.name
                    .capitalize(),
                color: const Color(0xFFffafcc),
              ),
              const Spacer(),
              _Indicator(
                label: meal.nutrition.fatTotal.abbreviation.nutrient.name
                    .capitalize(),
                color: const Color(0xFFa2d2ff),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Dot(color: color),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.color,
    double size = 16,
  }) : _size = size;

  final Color color;
  final double _size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _size,
      width: _size,
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }
}
