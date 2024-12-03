import 'package:day_plan_diary/view/screens/login/login.dart';
import 'package:day_plan_diary/view/screens/register/register.dart';
import 'package:day_plan_diary/view/screens/splash/splash.dart';
import 'package:day_plan_diary/viewmodels/todoItemViewModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../view/screens/home/home.dart';
import '../view/screens/newtask/newtask.dart';
import '../view/screens/updatetask/updatetask.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
TodoItemViewModel todoListViewModel = TodoItemViewModel();
final appRouter = GoRouter(
  navigatorKey: _navigatorKey, // This ensures the key is used only once
  routes: [
  GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) =>  HomePage(
                isTodoSelected: todoListViewModel.isTodoSelected,),
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
          task: args['task'],
        );
      },
    ),
  ],
);
