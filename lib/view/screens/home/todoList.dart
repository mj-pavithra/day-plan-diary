import 'package:day_plan_diary/viewmodels/todoItemViewModel.dart';
import 'package:day_plan_diary/viewmodels/todoListViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'todoItem.dart';
class TodoList extends StatelessWidget {
  final String selectedPriority;
  final bool isTodoSelected;

  const TodoList({
    super.key,
    required this.selectedPriority,
    required this.isTodoSelected,
  });

  @override
  Widget build(BuildContext context) {
    bool isNavigating = false;
    final viewModel = Provider.of<TodoListViewModel>(context);
    final tasks = viewModel.filteredTasks; // Use filtered tasks based on priority

    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks available'));
    }

    return SingleChildScrollView(
      child: Column(
        children: List.generate(tasks.length, (index) {
          final task = tasks[index];
          final taskKey = index;

          // Create TodoItemViewModel for each task
          final taskViewModel = TodoItemViewModel();
          taskViewModel.task = task;

          return Padding(
            padding: const EdgeInsets.all(3),
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (isNavigating) return; // Prevent duplicate navigation
                isNavigating = true;
                if (details.primaryVelocity! > 0) {
                  // Right swipe: Mark task as done
                } else {
                  // Left swipe: Delete task
                  taskViewModel.confirmDelete(context, viewModel.deleteTask, taskKey);
                }
              },
              child: ToDoItem(viewModel: taskViewModel , taskKey: taskKey),
            ),
          );
        }),
      ),
    );
  }
}
