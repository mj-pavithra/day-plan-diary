import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../view/screens/home/home.dart';
import '../view/screens/newtask/newtask.dart';
import '../view/screens/updatetask/updatetask.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _navigatorKey, // This ensures the key is used only once
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/newtask',
      builder: (context, state) => CreateTaskPage(),
    ),
    GoRoute(
      path: '/updatetask',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>? ?? {};
        return UpdateTaskPage(
          taskIndex: args['taskIndex'],
          task: args['task'],
        );
      },
    ),
  ],
);
