import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RoutineChart extends StatelessWidget {
  final List<DateTime>? days;
  final List<double>? times;

  const RoutineChart({Key? key, this.days, this.times}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = EffortHelperFunctions.isDarkMode(context);

    if (days == null || times == null || days!.isEmpty || times!.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Verificar que haya más de un punto para mostrar en el gráfico
    if (days!.length != times!.length || days!.length < 2) {
      return Center(
        child: Text(
          'Datos insuficientes para mostrar el gráfico',
          style: TextStyle(
            color: dark ? EffortColors.white : EffortColors.black,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => TextStyle(
                color: dark ? EffortColors.white : EffortColors.black,
                fontSize: 10,
              ),
              getTitles: (value) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return '${date.day}/${date.month}';
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => TextStyle(
                color: dark ? EffortColors.white : EffortColors.black,
                fontSize: 10,
              ),
              getTitles: (value) {
                return value.toStringAsFixed(0);
              },
            ),
            topTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                days!.length,
                    (index) => FlSpot(
                  days![index].millisecondsSinceEpoch.toDouble(),
                  times![index],
                ),
              ),
              isCurved: true,
              colors: [EffortColors.primary],
              barWidth: 4,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
