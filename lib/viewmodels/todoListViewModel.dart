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
  late final Box<Task> _taskBox ;
  bool _networkAvailable = true; // Not final, so it can be updated dynamically
  bool get networkAvailable => _networkAvailable;

  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final HiveService _hiveService = HiveService();


  TodoListViewModel() {
    // Initialize the Hive box
    
  _initializeTaskBox();
    // Initialize network listener
    NetworkUtils.initialize();
    NetworkUtils.onNetworkChange.listen((networkStatus) {
      _networkAvailable = networkStatus;
      notifyListeners(); // Notify listeners to update the UI
    });

  }

  Future<void> _initializeTaskBox() async {
  _taskBox = await Hive.openBox<Task>('tasksBox');
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
      if (!Hive.isBoxOpen('tasksBox')) {
    _taskBox = await Hive.openBox<Task>('tasksBox');
  }
    final String userId = _auth.currentUser!.uid;
    print('User ID: $userId');
    late List<Task> allTasks ;
    print ('Network available: $_networkAvailable');
      int taskCountHive = _taskBox.length;
    
    if (_networkAvailable) {
      int taskCountFirestore = await _firestoreService.getTaskCount(userId);
      print('Task count from firestore: $taskCountFirestore');
      print('Task count from hive: $taskCountHive');

      if (taskCountFirestore!= taskCountHive){
      print('Data get from firestore');
      allTasks = await _firestoreService.getTasks(userId);
      _hiveService.addAllTasks(allTasks);
      }
      else{
        print('Data get from hive even network is available');
        allTasks = _hiveService.getAllTasks();
      }
      
      
    } else {
      print('Task count from hive: $taskCountHive');
        print('Data get from hive in "filteredTasks"  $networkAvailable');
      allTasks = _hiveService.getAllTasks();
      
    }
    print('user email: ${_auth.currentUser!.email.toString()}');
      final bool filterByCompletion = isTodoSelected;
      SessionService().setCounter(_taskBox.length);

      return allTasks.where((task) {
        print('Current user email: ${_auth.currentUser!.email.toString()} ------- Task Owner email: ${task.taskOwnerEmail}');
        final bool matchesCompletion = !task.isCompleted == filterByCompletion;
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
