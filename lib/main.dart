import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import './ViewModels/HomePageViewModel.dart';
import 'Models/task.dart';
import 'Services/hiveService.dart';
import 'View/home.dart';
import 'View/newtask.dart';
import 'View/updatetask.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await HiveService.initializeHive(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/newtask',
          builder: (context, state) => const CreateTaskPage(),
        ),
        GoRoute(
          path: '/updatetask',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>;
            return UpdateTaskPage(
              taskIndex: args['taskIndex'],
              taskData: args['taskData'],
            );
          },
        ),
      ],
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomePageViewModel(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}
