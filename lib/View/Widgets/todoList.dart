import 'package:day_plan_diary/ViewModels/todoItemViewModel.dart';
import 'package:day_plan_diary/ViewModels/todoListViewModel.dart';
import 'package:day_plan_diary/ViewModels/updateTaskViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/todoItem.dart';

class TodoList extends StatelessWidget {
  final String selectedPriority;
  final bool isTodoSelected;

  const TodoList({
    super.key,
    required this.selectedPriority,
    required this.isTodoSelected,
  });



  void _confirmDelete(BuildContext context, TodoListViewModel viewModel, dynamic taskKey) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                viewModel.deleteTask(context, taskKey);
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TodoListViewModel>(context);

    final tasks = viewModel.filteredTasks;

  

    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks available'));
    }

    return SingleChildScrollView(
      child: Column(
        children: List.generate(tasks.length, (index) {
          final task = tasks[index];
          final taskKey = index;


          // Create TodoItemViewModel for each task
          final taskViewModel = TodoItemViewModel(
            title: task.title,
            date: task.date,
            priority: task.priority,
            isCompleted: task.isCompleted,
          );

          return Padding(
                    padding: const EdgeInsets.all(3),
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! > 0) {
                          // Right swipe: Edit task
                          final updateTaskViewModel = UpdateTaskViewModel(task: task, taskId: taskKey);
                          updateTaskViewModel.updateTask(context, taskKey);
                          print('update debuging 1');
                        } else {
                          // Left swipe: Delete task
                          print(taskKey);
                          taskViewModel.confirmDelete(context, viewModel.deleteTask, taskKey);
                        }
                      },
                      onDoubleTap: () {
                        // taskViewModel.updateTask(context, taskKey, task.toMap());
                      },
                      child: ToDoItem(viewModel: taskViewModel), // Pass ViewModel here
                    ),
                  );
          // Padding(
          //   padding: const EdgeInsets.all(3),
          //   child: GestureDetector(
          //     onHorizontalDragEnd: (details) {
          //       if (details.primaryVelocity! > 0) {
          //         // right to edit task
          //         Navigator.pushNamed(context, '/updatetask', arguments: {
          //           'taskIndex': taskKey,
          //           'taskData': task.toMap(),
          //         });
          //       } else {
          //         // Left to delete task
          //         _confirmDelete(context, viewModel, taskKey);
          //       }
          //     },
          //     onDoubleTap: () {
          //       Navigator.pushNamed(
          //         context,
          //         '/updatetask',
          //         arguments: {
          //           'taskIndex': taskKey,
          //           'taskData': task.toMap(),
          //         },
          //       );
          //     },
          //     child: ToDoItem(viewModel: taskViewModel), // Pass ViewModel here
          //   ),
          // );
        }),
      ),
    );
  }
}
