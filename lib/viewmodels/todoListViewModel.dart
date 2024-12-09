import 'package:day_plan_diary/services/firestore_service.dart';
import 'package:day_plan_diary/services/hiveService.dart';
import 'package:day_plan_diary/services/session_service.dart';
import 'package:day_plan_diary/utils/network_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/task.dart';
import '../utils/snackbar.dart';
import 'base_viewmodel.dart';

class TodoListViewModel extends BaseViewModel {
  final Box<Task> _taskBox = Hive.box<Task>('tasksBox');
  bool _networkAvailable = true; // Not final, so it can be updated dynamically
  bool get networkAvailable => _networkAvailable;

  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TodoListViewModel() {
    // Initialize network listener
    NetworkUtils.initialize();
    NetworkUtils.onNetworkChange.listen((networkStatus) {
      _networkAvailable = networkStatus;
      notifyListeners(); // Notify listeners to update the UI
    });
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

  Future<List<Task>> get filteredTasks async {
    final String _userId = _auth.currentUser!.uid;
    print('User ID: $_userId');
    
    if (!_networkAvailable) {
      print('Data get from hive');
      HiveService().getAllTasks();
      print('user email: ${_auth.currentUser!.email.toString()}');
      final bool filterByCompletion = isTodoSelected;
      SessionService().setCounter(_taskBox.length);

      return _taskBox.values.where((task) {
        print('Current user email: ${_auth.currentUser!.email.toString()} ------- Task Owner email: ${task.taskOwnerEmail}');
        final bool matchesCompletion = task.isCompleted == filterByCompletion;
        final bool matchesPriority = selectedPriority == 'All' || task.priority == selectedPriority;
        return matchesCompletion && matchesPriority;
      }).toList();
    } else {
      print('Data get from firestore');
      try {
        final List<Task> allTasks = await _firestoreService.getTasks(_userId);
        final bool filterByCompletion = isTodoSelected;
        return allTasks.where((task) {
          print('${task.title} ${task.priority}  ${task.isCompleted} ${task.taskOwnerEmail}');
          final bool matchesCompletion = task.isCompleted == filterByCompletion;
          final bool matchesPriority = selectedPriority == 'All' || task.priority == selectedPriority;
          return matchesCompletion && matchesPriority;
        }).toList();
      } catch (e) {
        print('Error getting tasks: $e');
        return [];
      }
    }
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
