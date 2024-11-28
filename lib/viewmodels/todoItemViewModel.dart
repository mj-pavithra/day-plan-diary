import 'package:day_plan_diary/data/models/task.dart';
import 'package:day_plan_diary/services/hiveService.dart';
import 'package:day_plan_diary/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import './todoListViewModel.dart';
import 'base_viewmodel.dart';

class TodoItemViewModel extends BaseViewModel {

  var ListViewModel = TodoListViewModel();

Task? task;
  late TextEditingController titleController;
  late TextEditingController dateController;
  String selectedPriority = 'All';
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
  void updatePriority(String newPriority) {
    selectedPriority = newPriority;
  }


  Task getUpdatedTask() {
    return Task(
      id: task?.id ?? 0,
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
      GoRouter.of(context).go('/home');
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
  Future <bool> confirmDelete (
      BuildContext context,  dynamic taskKey) async{
    
    return await showDialog <bool>(

      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: ()  {
                Navigator.pop(context, true);
              deleteTask(taskKey);
              },

              child: const Text("Delete"),
            ),
          ],
        );

      },
    )?? false;
  }
  void confirmComplete(BuildContext context,Task task) {
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
            Provider(
              create: (_) => TodoItemViewModel(),
              child: TextButton(
                onPressed: () {
                  task.isCompleted = true; 
                   updateTask(task);
                  Provider.of<TodoListViewModel>(context, listen:false).refreshFilteredTasks();
                  print('Completed task:- ${HiveService().getTaskKey(task)}');
                  Navigator.of(context).pop();
                },
                child: const Text("Confirm"),
              ),
            ),
          ],
        );
      },
    );
  }
  Future<void> updateTask(Task updatedTask) async {
    int taskId = HiveService().getTaskKey(updatedTask);
    print("Title: ${updatedTask.title} Index: $taskId updated");
    try {await HiveService().updateTask(updatedTask);}
    catch(e) {throw Exception('Error updating task: $e');}
    notifyListeners();
  }

  // void markAsCompleted(BuildContext context, Function updateTask, dynamic task) {
  //   String taskTitle = task.title;
  //   bool isCompleted = task.isCompleted;

  //     final updatedTask = task.changedTask(isCompleted: true); // Assuming copyWith is implemented
  //     updateTask(task.id, updatedTask);
  //     SnackbarUtils.showSnackbar('Task marked as completed', backgroundColor: Colors.green);
  //     notifyListeners();
  //   }
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
