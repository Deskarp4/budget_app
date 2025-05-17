import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class ExpensePie extends StatelessWidget {
  const ExpensePie({
    super.key,
    required this.data,
    this.labelThreshold = 5,
    this.radiusFactor = 0.25,
    this.heightFactor = 0.8,
    this.labelFontSize = 18,
    this.legendFontSize = 19,
  })  : assert(radiusFactor > 0 && heightFactor > 0),
        assert(labelThreshold >= 0),
        assert(labelFontSize > 0),
        assert(legendFontSize > 0);


  final Map<String, double> data;

  /// Проценты меньше этого числа не подписываются внутри круга
  final double labelThreshold;

  /// Радиус сектора как доля ширины экрана (0‒1)
  final double radiusFactor;

  /// Высота виджета как доля ширины экрана (0‒…)
  final double heightFactor;

  /// Размер шрифта для подписей внутри секторов
  final double labelFontSize;

  /// Размер шрифта для элементов легенды
  final double legendFontSize;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No expenses yet'));
    }

    final size = MediaQuery.of(context).size;
    final chartRadius = size.width * radiusFactor;
    final total = data.values.fold<double>(0, (s, v) => s + v);

    final palette = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.brown,
      Colors.indigo,
      Colors.cyan,
      Colors.pink,
    ];

    int idx = 0;
    final sections = data.entries.map((entry) {
      final color = palette[idx % palette.length];
      final percent = entry.value / total * 100;
      idx++;
      return PieChartSectionData(
        value: entry.value,
        color: color,
        radius: chartRadius,
        title: percent >= labelThreshold ? '${percent.toStringAsFixed(0)}%' : '',
        titleStyle: TextStyle(
          fontSize: labelFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.55,
      );
    }).toList();

    // легенда с процентами в скобках
    idx = 0;
    final legendItems = data.entries.map((entry) {
      final color = palette[idx % palette.length];
      final percent = entry.value / total * 100;
      idx++;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 6),
            Text(
              '${entry.key} (${percent.toStringAsFixed(0)}%)',
              style: TextStyle(fontSize: legendFontSize),
            ),
          ],
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size.width * heightFactor,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              borderData: FlBorderData(show: false),
            ),
            key: ValueKey(total),
          ),
        ),
        const SizedBox(height: 0),
        Wrap(alignment: WrapAlignment.center, children: legendItems),
      ],
    );
  }
}
