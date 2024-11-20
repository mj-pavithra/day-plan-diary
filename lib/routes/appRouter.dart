import 'package:go_router/go_router.dart';
import '../View/home.dart';
import '../View/newtask.dart';
import '../View/updatetask.dart';

final appRouter = GoRouter(
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
        final args = state.extra as Map<String, dynamic>;
        return UpdateTaskPage(
          taskIndex: args['taskIndex'],
          task: args['task'],
        );
      },
    ),
  ],
);
