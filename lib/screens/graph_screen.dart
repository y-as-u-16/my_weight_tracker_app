import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_weight_tracker_app/models/weight_entry.dart';

class GraphScreen extends StatelessWidget {
  final List<WeightEntry> weightEntries;

  const GraphScreen({
    super.key,
    required this.weightEntries,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('体重グラフ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    return Text(
                      '${date.month}/${date.day}',
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                  interval: 86400000, // 1日分のミリ秒
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                  interval: 5, // 5kg間隔
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            minX: weightEntries.first.date.millisecondsSinceEpoch.toDouble(),
            maxX: weightEntries.last.date.millisecondsSinceEpoch.toDouble(),
            minY: weightEntries.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 5,
            maxY: weightEntries.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 5,
            lineBarsData: [
              LineChartBarData(
                spots: weightEntries
                    .map((entry) => FlSpot(
                          entry.date.millisecondsSinceEpoch.toDouble(),
                          entry.weight,
                        ))
                    .toList(),
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}