import 'package:day_plan_diary/services/hiveService.dart';
import 'package:day_plan_diary/viewmodels/todoItemViewModel.dart';
import 'package:day_plan_diary/viewmodels/todoListViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:day_plan_diary/data/models/task.dart';

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
  return Consumer<TodoListViewModel>(
    builder: (context, viewModel, child) {
      return FutureBuilder<List<Task>>(
        future: viewModel.filteredTasks, // Call filteredTasks asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            viewModel.taskcount = 0;
            return const Center(child: Text('No tasks available'));
          }

          final tasks = snapshot.data!;
          viewModel.taskcount = tasks.length;

          return SingleChildScrollView(
            child: Column(
              children: List.generate(tasks.length, (index) {
                final task = tasks[index];
                final taskKey = HiveService().getTaskKey(task); // Use unique identifier
                final taskViewModel = TodoItemViewModel();
                taskViewModel.task = task;

                return Padding(
                  padding: const EdgeInsets.all(3),
                  child: Dismissible(
                    key: Key(taskKey.toString()),
                    direction: isTodoSelected
                        ? DismissDirection.horizontal
                        : DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        taskViewModel.confirmComplete(context, task);
                        viewModel.refreshTaskList(); // Refresh task list after update
                        return false; // Prevent dismissal
                      } else if (direction == DismissDirection.endToStart) {
                        final confirmDelete =
                            await taskViewModel.confirmDelete(context, taskKey);
                        if (confirmDelete) {
                          viewModel.deleteTask(context, taskKey);
                        }
                        return false; // Prevent dismissal
                      }
                      return false;
                    },
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ToDoItem(viewModel: taskViewModel, taskKey: taskKey),
                  ),
                );
              }),
            ),
          );
        },
      );
    },
  );
}

}
