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
  

List<Task> get filteredTasks {
  final bool filterByCompletion = !isTodoSelected;
  return _taskBox.values.where((task) {
    // Ensure task fields are valid
    // final bool matchesVisibility = task.isVisible ?? true;
    final bool matchesCompletion = task.isCompleted == filterByCompletion;
    final bool matchesPriority = selectedPriority == 'All' || task.priority == selectedPriority;
    taskcount = _taskBox.length;
    // Filter tasks based on conditions
    return matchesCompletion && matchesPriority;
  }).toList();
}
void removeTask(int taskKey) {
  // Temporarily hide the task from the UI without deleting it
  final keys = _taskBox.keys.toList();
  if (taskKey < keys.length) {
    notifyListeners(); // Notify listeners to refresh UI
  }
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

  Future<void> updateTask(int index, Task updatedTask) async {
    await _taskBox.putAt(index, updatedTask);

    notifyListeners();
  }

  
}

