import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:day_plan_diary/view/screens/splash/splash.dart';
import 'package:day_plan_diary/view/screens/login/login.dart';
import 'package:day_plan_diary/view/screens/register/register.dart';
import 'package:day_plan_diary/view/screens/home/home.dart';
import 'package:day_plan_diary/view/screens/newtask/newtask.dart';
import 'package:day_plan_diary/view/screens/updatetask/updatetask.dart';
import 'package:day_plan_diary/viewmodels/todoItemViewModel.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
final TodoItemViewModel todoListViewModel = TodoItemViewModel();

final appRouter = GoRouter(
  navigatorKey: _navigatorKey,
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
      builder: (context, state) => HomePage(),
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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
    );
  }
}
