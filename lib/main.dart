
import 'package:day_plan_diary/viewmodels/todoBodyViewModel.dart';
import 'package:day_plan_diary/viewmodels/todoItemViewModel.dart';
import 'package:day_plan_diary/viewmodels/todoListViewModel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'services/hiveService.dart';
import 'utils/snackbar.dart';
import 'viewmodels/HomePageViewModel.dart';
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
