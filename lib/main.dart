import 'package:flutter/material.dart';
import 'package:my_weight_tracker_app/screen/weight_input.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '体重管理アプリ',
      home: WeightInputScreen(),
    );
  }
}
