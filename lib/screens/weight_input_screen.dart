import 'package:flutter/material.dart';
import 'package:my_weight_tracker_app/models/weight_entry.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

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
  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, WeightEntry> _weightEntries = {};
  List<FlSpot> _spots = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    });
  }

  void _addData() {
    if (_weightController.text.isNotEmpty) {
      double? weight = double.tryParse(_weightController.text);
      if (weight != null && weight.isFinite && !weight.isNaN) {
        setState(() {
          DateTime dateWithoutTime = DateTime(
              _selectedDate.year, _selectedDate.month, _selectedDate.day);
          _weightEntries[dateWithoutTime] =
              WeightEntry(dateWithoutTime, weight);
          _updateSpots();
        });
        _weightController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('無効な体重値です。')),
        );
      }
    }
  }

  void _updateSpots() {
    _spots = _weightEntries.values
        .map((entry) =>
            FlSpot(entry.date.millisecondsSinceEpoch.toDouble(), entry.weight))
        .toList();
    _spots.sort((a, b) => a.x.compareTo(b.x));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('体重入力')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2021, 1, 1),
              lastDay: DateTime.now(),
              focusedDay: _selectedDate,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              eventLoader: (day) {
                final normalizedDay = DateTime(day.year, day.month, day.day);
                return _weightEntries.containsKey(normalizedDay)
                    ? [_weightEntries[normalizedDay]!]
                    : [];
              },
              calendarStyle: const CalendarStyle(
                markersMaxCount: 1,
                markerSize: 8,
                markerDecoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black),
                        width: 8,
                        height: 8,
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '選択された日付: ${DateFormat('yyyy/MM/dd').format(_selectedDate)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _weightEntries.containsKey(_selectedDate)
                  ? '記録された体重: ${_weightEntries[_selectedDate]!.weight} kg'
                  : '体重未記録',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '体重を入力してください（kg）',
                hintText: _weightEntries.containsKey(_selectedDate)
                    ? '現在の記録: ${_weightEntries[_selectedDate]!.weight} kg'
                    : null,
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
    );
  }
}
