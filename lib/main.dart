  import 'package:day_plan_diary/ForHive/task.dart';
import 'package:day_plan_diary/Screens/home.dart';
import 'package:day_plan_diary/Screens/newtask.dart';
import 'package:day_plan_diary/Screens/updatetask.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:day_plan_diary/ForHive/task.dart';
import 'ForHive/boxes.dart';
import 'snackbar_utils.dart';

  void main() async {

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  boxTask =await Hive.openBox<Task>('tasksBox');
  boxTest = await Hive.openBox('testBox');
    runApp(
      const MyApp(),
    );
  }
  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        scaffoldMessengerKey: SnackbarUtils.messengerKey,
        title: 'Flutter Demo',
        theme: ThemeData(
        ),
        home: const HomePage(),
        routes: {
          '/newtask': (context) => const CreateTaskPage(),
          '/updatetask': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map;
            return UpdateTaskPage(taskIndex: args['taskIndex'] ,taskData: args['taskData']);
          }
        },
      );
    }
  }
