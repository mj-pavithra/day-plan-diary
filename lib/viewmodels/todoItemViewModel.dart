import 'package:day_plan_diary/data/models/task.dart';
import 'package:day_plan_diary/services/hiveService.dart';
import 'package:day_plan_diary/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'base_viewmodel.dart';

class TodoItemViewModel extends BaseViewModel {

Task? task;
  late TextEditingController titleController;
  late TextEditingController dateController;
  late String selectedPriority ;
  late bool isCompleted;
  final Box<Task> _taskBox = Hive.box<Task>('tasksBox');

  
    void initialize(Task task) {
    titleController = TextEditingController(text: task.title);
    dateController = TextEditingController(text: task.date);
    selectedPriority = task.priority ;
    isCompleted = task.isCompleted ;
  }

    void setPriority(String priority) {
    selectedPriority = priority;
    notifyListeners();
  }

  void setCompletion(bool completed) {
    isCompleted = completed;
    notifyListeners();
  }

  Task getUpdatedTask() {
    return Task(
      id: task?.id?? 1,
      title: titleController.text,
      date: dateController.text,
      priority: selectedPriority,
      isCompleted: isCompleted,
    );
  }

  // Determines the color based on priority
  Color get priorityColor {
    switch (task?.priority) {
      case 'High':
        return const Color.fromARGB(255, 241, 2, 2);
      case 'Medium':
        return const Color.fromARGB(255, 250, 233, 0);
      default:
        return const Color.fromARGB(122, 42, 25, 194);
    }
  }

  // Handles task tapping - navigates to update task screen



  // Helper function to validate and save a task
  Future<void> saveTask({
    required BuildContext context,
    required int id,
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
      id: id,
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
  void confirmComplete(BuildContext context,Task task,  int key) {
    print('confirmComplete in View model is called:- $key');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Mark as Completed"),
          content: const Text("Are you sure you want to mark this task as completed?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                print('confirmComplete in View model is called');
                 updateTask(  key , task.changedTask(isCompleted: true) );
                 print('$key :- task is completed');
                Navigator.of(context).pop();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
  Future<void> updateTask(int index, Task updatedTask) async {
      print('$index :- task is completed in updateTask');
    await _taskBox.putAt(index, updatedTask);
    notifyListeners();
  }
  void markAsCompleted(BuildContext context, Function updateTask, dynamic task) {
    String taskTitle = task.title;
    bool isCompleted = task.isCompleted;
    print("task:- $taskTitle ;");
    print("is completed:- $isCompleted ;");

      final updatedTask = task.changedTask(isCompleted: true); // Assuming copyWith is implemented
      updateTask(task.id, updatedTask);
      SnackbarUtils.showSnackbar('Task marked as completed', backgroundColor: Colors.green);
      notifyListeners();
    }
    // Future<void> updateTask(BuildContext context, taskId, tasktoUpdate) async {

    //   print('updateTask in View model is called');
    //     final task = tasktoUpdate;
    //     final hiveService = HiveService();
    //     try
    //     {
    //       await hiveService.updateTask(taskId, task);
    //       notifyListeners();
    //     }
    //     catch(e)
    //     {
    //       throw Exception('Error updating task: $e');
    //     }
    //   }


}
