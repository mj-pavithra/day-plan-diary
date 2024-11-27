import 'package:day_plan_diary/services/hiveService.dart';
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
    // bool isNavigating = false;
    final viewModel = Provider.of<TodoListViewModel>(context);
    final tasks = viewModel.filteredTasks; // Use filtered tasks based on priority

    if (tasks.isEmpty) {
      viewModel.taskcount = 0;
      return const Center(child: Text('No tasks available'));
    }
    else {
      viewModel.taskcount = tasks.length;
    }

    return SingleChildScrollView(
      child: Column(
        children: List.generate(tasks.length, (index) {
          final task = tasks[index];
          final taskKey = HiveService().getTaskKey(task); // Get task key

          // Create TodoItemViewModel for each task
          final taskViewModel = TodoItemViewModel();
          taskViewModel.task = task;

          return Padding(
                  padding: const EdgeInsets.all(3),
                  child: Dismissible(
                          key: Key(taskKey.toString()),
                          direction: isTodoSelected
                              ? DismissDirection.horizontal // Allow both directions
                              : DismissDirection.endToStart, // Only allow left swipe (delete)
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              // Right swipe: Confirm to mark as completed
                              taskViewModel.confirmComplete(context, task);
                              viewModel.refreshTaskList();
                              return false; // Prevent dismissal
                            } else if (direction == DismissDirection.endToStart) {
                              final confirmDelete = await taskViewModel.confirmDelete(context, taskKey);
                              if (confirmDelete) {
                                viewModel.deleteTask(context, taskKey);
                              }
                              return false; // Allow dismissal
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
  }
}
