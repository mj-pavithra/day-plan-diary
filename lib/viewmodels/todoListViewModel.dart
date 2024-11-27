import 'package:day_plan_diary/services/hiveService.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/task.dart';
import '../utils/snackbar.dart';
import 'base_viewmodel.dart';

class TodoListViewModel extends BaseViewModel {
  final Box<Task> _taskBox = Hive.box<Task>('tasksBox');
  String selectedPriority = 'All';
  bool isTodoSelected = true;
  int  taskcount= 0;

  void toggleTodoSelection(bool isTodo) {
    isTodoSelected = isTodo;
    notifyListeners();
  }
  
  void refreshFilteredTasks() {
    print("Try to refresh");
    notifyListeners();
  }

  
List<Task> get filteredTasks {
  HiveService().getAllTasks();
  final bool filterByCompletion = !isTodoSelected;

  return _taskBox.values.where((task) {
    final bool matchesCompletion = task.isCompleted == filterByCompletion;
    final bool matchesPriority = selectedPriority == 'All' || task.priority == selectedPriority;

    return matchesCompletion && matchesPriority;
  }).toList();
}

void refreshTaskList() {
  notifyListeners(); // Notify listeners to refresh UI
}

  void deleteTask(BuildContext context, dynamic taskKey) {
    _taskBox.delete(taskKey);
    SnackbarUtils.showSnackbar('Task deleted successfully', backgroundColor: Colors.red);
    notifyListeners();
  }

  void setSelectedPriority(String priority) {
    selectedPriority = priority;
    notifyListeners();
  }

  void setTodoSelection(bool isTodo) {
    isTodoSelected = isTodo;
    toggleTodoSelection(isTodoSelected);
    notifyListeners();
  }


  
}

