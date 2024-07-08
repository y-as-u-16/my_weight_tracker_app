import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '体重管理アプリ',
      home: WeightInputScreen(),
    );
  }
}

class WeightInputScreen extends StatefulWidget {
  @override
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
    double weight = double.parse(_weightController.text);
    // ここで日付と体重をグラフに追加する
    spots.add(FlSpot(selectedDate.millisecondsSinceEpoch.toDouble(), weight));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('体重入力'),
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
                    icon: Icon(Icons.calendar_today),
                    onPressed: _presentDatePicker,
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '体重を入力してください（kg）',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _addData();
                  print('体重と日付が保存されました: ${_dateController.text}, ${_weightController.text} kg');
                },
                child: Text('保存'),
              ),
              SizedBox(height: 20),
              spots.isNotEmpty ? LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(spots: spots)
                  ],
                ),
              ) : Text('データを入力してください'),
            ],
          ),
        ),
      ),
    );
  }
}
