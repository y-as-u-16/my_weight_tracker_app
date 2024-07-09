import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class WeightInputScreen extends StatefulWidget {
  const WeightInputScreen({super.key});

  @override
  _WeightInputScreenState createState() => _WeightInputScreenState();
}

class _WeightInputScreenState extends State<WeightInputScreen> {
  final TextEditingController _weightController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<FlSpot> spots = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  setState(() {
    selectedDate = selectedDay;
  });
}

  void _addData() {
    if (_weightController.text.isNotEmpty) {
      double? weight = double.tryParse(_weightController.text);
      if (weight != null && weight.isFinite && !weight.isNaN) {
        setState(() {
          spots.add(FlSpot(selectedDate.millisecondsSinceEpoch.toDouble(), weight));
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
              TableCalendar(
                firstDay: DateTime.utc(2021, 1, 1),
                lastDay: DateTime.now(),
                focusedDay: selectedDate,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDate, day);
                },
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
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
                onPressed: _addData,
                child: const Text('保存'),
              ),
              const SizedBox(height: 20),
              // ここにグラフを表示するウィジェットを配置
            ],
          ),
        ),
      ),
    );
  }
}