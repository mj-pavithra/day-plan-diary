import 'package:day_plan_diary/viewmodels/todoItemViewModel.dart';
import 'package:day_plan_diary/viewmodels/todoListViewModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'routes/appRouter.dart';
import 'services/hiveService.dart';
import 'utils/snackbar.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/homePageViewModel.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Hive.initFlutter();
  await Firebase.initializeApp();
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
          create: (context) => TodoListViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoItemViewModel()
          ),

        ChangeNotifierProvider(
          create: (_) => AuthViewModel()
          ),
      ],
      child: MaterialApp.router(
        scaffoldMessengerKey: SnackbarUtils.messengerKey,
        routerConfig: appRouter,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)
        ),
      ),
    );
  }
}
