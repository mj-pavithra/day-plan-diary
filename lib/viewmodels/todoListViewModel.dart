import 'package:day_plan_diary/services/hiveService.dart';
import 'package:day_plan_diary/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/task.dart';
import '../utils/snackbar.dart';
import 'base_viewmodel.dart';

class TodoListViewModel extends BaseViewModel {
  final Box<Task> _taskBox = Hive.box<Task>('tasksBox');
  bool _isSessionInitialized = false;

    Future<Map<String, dynamic>> _fetchUserDetails() async {
    final session = await SessionService.getInstance();
    return await session?.getUserDetails() ?? {};
    notifyListeners();
  }

  late String userEmail;

  TodoListViewModel() {
    _initializeSession();
    _fetchUserDetails().then((details) {
      userEmail = details['userEmail'];
    });
  }

  SessionService? _session; // Session instance
  late String? _userEmail; // Store resolved email
  String? _userId;   // Store resolved userId

  // TodoListViewModel() {
  //   _initializeSession();
  // }

Future<void> _initializeSession() async {
  // if (_isSessionInitialized) return;
  print("Initializing Session...");
  try {
    final session = await SessionService.getInstance();
    if (session != null) {
      _userEmail = session.getUserEmail();
      _userId = session.getUserId();
    }
  // _isSessionInitialized = true;
    // print("User Email in ViewModel: $_userEmail");
    // print("User ID in ViewModel: $_userId");
  } catch (e) {
    // print("Error initializing session: $e");
  } finally {
    // print("Session Initialization Complete");
    notifyListeners();
  }
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

  void setLogOut(bool isLogOut) {
    _isSessionInitialized = false;
  }

void setUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }





  List<Task> get filteredTasks {
    if (_userEmail != userEmail) {
      print("Mismatch detected. Updating local userEmail to match global _userEmail.");
      userEmail = _userEmail ?? ""; // Update local variable
    }
    HiveService().getAllTasks();
    print('user email: $_userEmail');
    final bool filterByCompletion = !isTodoSelected;

    return _taskBox.values.where((task) {
      print('Current user email: $userEmail ------- Task Owner email: ${task.taskOwnerEmail}');
      final bool matchesCompletion = task.isCompleted == filterByCompletion;
      final bool matchesPriority = selectedPriority == 'All' || task.priority == selectedPriority;
      final bool matchOwner = task.taskOwnerEmail == userEmail;
      return matchesCompletion && matchesPriority && matchOwner;
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
