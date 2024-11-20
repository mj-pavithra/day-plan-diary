import 'package:day_plan_diary/Models/task.dart';
import 'package:day_plan_diary/ViewModels/todoBodyViewModel.dart';
import 'package:day_plan_diary/ViewModels/todoItemViewModel.dart';
import 'package:day_plan_diary/ViewModels/todoListViewModel.dart';
import 'package:day_plan_diary/ViewModels/updateTaskViewModel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'Services/hiveService.dart';
import 'Utils/snackbar.dart';
import 'ViewModels/HomePageViewModel.dart';
import 'routes/appRouter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Hive.initFlutter();
  // Hive.registerAdapter(TaskAdapter());
  await HiveService.initializeHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomePageViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoBodyViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoListViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoItemViewModel(
            title: 'Sample Title',
            date: DateTime.now().toIso8601String(),
            priority: 'High',
            isCompleted: false,
          )
          ),
          ChangeNotifierProvider(
          create: (context) => UpdateTaskViewModel(
            task: Task(title: "title", date: "date", priority: "priority"), // Replace 'someTask' with the actual task object
            taskId: 1, // Replace 'someTaskId' with the actual task ID
            
          )
          ),
      ],
      child: MaterialApp.router(
        scaffoldMessengerKey: SnackbarUtils.messengerKey,
        routerConfig: appRouter,
      ),
    );
  }
}
