import 'package:go_router/go_router.dart';
import '../View/home.dart';
import '../View/newtask.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/newTask',
      builder: (context, state) => CreateTaskPage(),
    ),
  ],
);

