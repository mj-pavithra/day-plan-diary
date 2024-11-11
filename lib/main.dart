  import 'package:day_plan_diary/Screens/home.dart';
import 'package:day_plan_diary/Screens/newtask.dart';
import 'package:day_plan_diary/Screens/updatetask.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

  void main() async {

  await Hive.initFlutter();
  await Hive.openBox('tasksBox');
    runApp(
      const MyApp(),
    );
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        routes: {
          '/newtask': (context) => const CreateTaskPage(),
          '/updatetask': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return UpdateTaskPage(taskData: args['taskData'], taskIndex: args['taskIndex']);
          }
        },
      );
    }
  }
