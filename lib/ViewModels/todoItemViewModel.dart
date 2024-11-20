import 'package:day_plan_diary/Models/task.dart';
import 'package:day_plan_diary/Services/hiveService.dart';
import 'package:day_plan_diary/Utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TodoItemViewModel extends ChangeNotifier {
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

  // Determines the color based on priority
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

  // Handles task tapping - navigates to update task screen
 Future<void> updateTask(BuildContext context, taskId, title, date, priority, isCompleted) async {
    Task task  = Task(
      title: title,
      date: date,
      priority: priority,
      isCompleted: isCompleted,
    );
    //validate and update task

    final hiveService = HiveService();
    try
    {
      await hiveService.updateTask(taskId, task);
      notifyListeners();
      GoRouter.of(context).go('/');
      SnackbarUtils.showSnackbar(
        "Task updated successfully",
        backgroundColor: Colors.green,
      );
    }
    catch(e)
    {
      throw Exception('Error updating task: $e');
    }
  }


  // Helper function to validate and save a task
  Future<void> saveTask({
    required BuildContext context,
    required String title,
    required String date,
    required String priority,
  }) async {
    if (title.isEmpty || date.isEmpty || priority == "Select Priority") {
      SnackbarUtils.showSnackbar('Please fill all fields', backgroundColor: Colors.red);
      throw Exception('Please fill all fields');
    }

    DateTime selectedDate = DateTime.parse(date);
    if (selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      SnackbarUtils.showSnackbar('Please select a valid date', backgroundColor: Colors.red);
      throw Exception('Please select a valid date');
    }

    final task = Task(
      title: title,
      date: date,
      priority: priority,
      isCompleted: false,
    );

    try {
      final hiveService = HiveService();
      await hiveService.addTask(task);
      notifyListeners();
      GoRouter.of(context).go('/');
      SnackbarUtils.showSnackbar(
        "New task added successfully",
        backgroundColor: Colors.green,
      );
      
    } catch (e) {
      throw Exception('Error saving task: $e');
    }
  }

  // Delete task via HiveService
  Future<void> deleteTask(int taskKey) async {
    print('deleteTask in View model is called');

    try {
      final hiveService = HiveService();
      await hiveService.deleteTask(taskKey);
      notifyListeners();
      SnackbarUtils.showSnackbar(
        "Task deleted successfully",
        backgroundColor: Colors.red,
      );
    } catch (e) {
      throw Exception('Error deleting task: $e');
      SnackbarUtils.showSnackbar(
        "Error deleting task",
        backgroundColor: Colors.red,
      );
    }
  }
    // Confirms task deletion - displays a confirmation dialog
  void confirmDelete(
      BuildContext context, Function(BuildContext, dynamic) deleteTaskCallback, dynamic taskKey) {
                          print(taskKey);
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
                deleteTask(taskKey);
                deleteTaskCallback(context, taskKey);
                Navigator.of(context).pop();
                          print('delete debuging 3');
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

}
