import 'package:day_plan_diary/Screens/home.dart';
import 'package:day_plan_diary/Screens/newtask.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/newtask': (context) => const CreateTaskPage(),
      },
    );
  }
}
