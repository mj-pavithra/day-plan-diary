import 'package:day_plan_diary/services/hiveService.dart';
import 'package:day_plan_diary/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/task.dart';
import '../utils/snackbar.dart';
import 'base_viewmodel.dart';

class TodoListViewModel extends BaseViewModel {
  final Box<Task> _taskBox = Hive.box<Task>('tasksBox');

  SessionService? _session; // Make session nullable until initialized

  TodoListViewModel() {
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    _session = await SessionService.getInstance();
    notifyListeners(); // Notify listeners after session is initialized
  }

  void toggleTodoSelection(bool isTodo) {
    isTodoSelected = isTodo;
    notifyListeners();
  }

  void refreshFilteredTasks() {
    selectedPriority = "All";
    notifyListeners();
  }

  bool getTodoSelected() {
    return isTodoSelected;
  }

  List<Task> get filteredTasks {
    HiveService().getAllTasks();

    // If session is not initialized yet, return an empty list
    if (_session == null) {
      return [];
    }

    final bool filterByCompletion = !isTodoSelected;


    final userEmail =  _session!.getUserEmail();
    final userID = _session!.getUserId();
    print('************${userEmail}');
    print('************${userID}');

    return _taskBox.values.where((task) {
      final bool matchesCompletion = task.isCompleted == filterByCompletion;
      final bool matchesPriority = selectedPriority == 'All' || task.priority == selectedPriority;
      // final bool matchOwner = task.taskOwnerEmail == _session!.getUserEmail(); // Safe to use session now
      
      return matchesCompletion && matchesPriority ;
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
