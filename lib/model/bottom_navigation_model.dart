import 'package:flutter/material.dart';
import '../ui/Transaction.dart';
import '../ui/Orderbook.dart';
import '../ui/Stats.dart';

class BottomNavigationModel with ChangeNotifier{
  final List<Widget> options = [
    StatsMain(),
    OrderBookMain(),
    TransactionsMain(),
  ];

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void change(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Widget getSelectedScreen() {
    return options[selectedIndex];
  }
}