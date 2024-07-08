import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightInputScreen extends StatefulWidget {
  const WeightInputScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WeightInputScreenState createState() => _WeightInputScreenState();
}

class _WeightInputScreenState extends State<WeightInputScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<FlSpot> spots = [];

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        selectedDate = pickedDate;
        _dateController.text = DateFormat('yyyy/MM/dd').format(pickedDate);
      });
    });
  }

  void _addData() {
    if (_weightController.text.isNotEmpty) {
      double? weight = double.tryParse(_weightController.text);
      if (weight != null && weight.isFinite && !weight.isNaN) {
        setState(() {
          spots.add(
              FlSpot(selectedDate.millisecondsSinceEpoch.toDouble(), weight));
        });
        _weightController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('無効な体重値です。')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('体重入力'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: '日付を選択',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _presentDatePicker,
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '体重を入力してください（kg）',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _addData();
                },
                child: const Text('保存'),
              ),
              const SizedBox(height: 20),
              spots.isNotEmpty
                  ? SizedBox(
                      height: 300, // 適切な高さを設定
                      width: double.infinity,
                      child: LineChart(
                        LineChartData(
                          minX: spots.isNotEmpty ? spots.first.x : 0,
                          maxX: spots.isNotEmpty ? spots.last.x : 1,
                          minY: spots.isNotEmpty
                              ? spots.map((e) => e.y).reduce(min) - 1
                              : 0,
                          maxY: spots.isNotEmpty
                              ? spots.map((e) => e.y).reduce(max) + 1
                              : 100,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text('${value.toStringAsFixed(1)}kg');
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  final date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          value.toInt());
                                  return Text(DateFormat('MM/dd').format(date));
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: Colors.blue,
                              dotData: FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Text('データを入力してください'),
            ],
          ),
        ),
      ),
    );
  }
}
