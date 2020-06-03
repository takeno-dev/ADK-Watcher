import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/main_bottom_navigation.dart';
import 'model/bottom_navigation_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomNavigationModel>(
          create: (context) => BottomNavigationModel(),
        ),
        /*
        ChangeNotifierProvider<TodoModel>(
          create: (context) => TodoModel(),
        ),
        */
      ],
      child: MaterialApp(
        title: 'Todo App Sample',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MainBottomNavigation(),
      ),
    );
  }
}
