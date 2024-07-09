import 'package:flutter/material.dart';
import 'package:my_weight_tracker_app/screens/weight_input_screen.dart';
import 'package:my_weight_tracker_app/screens/graph_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    WeightInputScreen(),
    GraphScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem(Icons.input, '体重入力', 0),
          _buildBottomNavigationBarItem(Icons.show_chart, 'グラフ', 1),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false, // この行を変更
        showUnselectedLabels: false,
        selectedFontSize: 14,
        unselectedFontSize: 12,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: '', // この行を空文字列に変更
      activeIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blue,
            ), // 色を明示的に指定
          ),
        ],
      ),
    );
  }
}
