import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/bottom_navigation_model.dart';
import '../ui/header.dart';

class MainBottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bottomNavigationModel = Provider.of<BottomNavigationModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Logo(),
      ),
      body: Center(
        child: bottomNavigationModel.getSelectedScreen(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('All'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outline_blank),
            title: Text('Incompleted'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            title: Text('Completed'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomNavigationModel.selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          bottomNavigationModel.change(index);
        },
      ),
      //floatingActionButton: AddTodoButton(),
    );
  }
}