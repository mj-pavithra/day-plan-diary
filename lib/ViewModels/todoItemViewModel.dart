import 'package:flutter/material.dart';

class TodoItemViewModel {
  final String title;
  final String date;
  final String priority;
  final bool isCompleted;

  TodoItemViewModel({
    required this.title,
    required this.date,
    required this.priority,
    required this.isCompleted,
  });

  Color get priorityColor {
    switch (priority) {
      case 'High':
        return const Color.fromARGB(255, 241, 2, 2);
      case 'Medium':
        return const Color.fromARGB(255, 250, 233, 0);
      default:
        return const Color.fromARGB(122, 42, 25, 194);
    }
  }

  void onTaskTap(BuildContext context) {
    print('Task "$title" tapped');
  }
}
