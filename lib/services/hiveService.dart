import 'dart:async';
import 'package:day_plan_diary/data/models/task.dart';
import 'package:day_plan_diary/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HiveService {
  late Box<Task> taskBox;
  late Box<Task> offlineSaveBox;
  late Box<Task> offlineUpdateBox;
  late Box<int> offlineDeleteBox;
  final Connectivity _connectivity = Connectivity();
  late final FirestoreService _firestoreService;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  late final Future<void> _initHiveFuture;
    HiveService() {
    _initHiveFuture = initializeHive();
  }
  Future<void> ensureInitialized() async {
    await _initHiveFuture;
  }


  Future<void> initializeHive() async {
    print('Initializing Hive...');
    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(TaskAdapter().typeId)) {
      Hive.registerAdapter(TaskAdapter());
      print('TaskAdapter registered');
    }

    try {
      taskBox = await Hive.openBox<Task>('tasksBox');
      print('taskBox initialized');
      offlineSaveBox = await Hive.openBox<Task>('offlineSaveBox');
      offlineUpdateBox = await Hive.openBox<Task>('offlineUpdateBox');
      offlineDeleteBox = await Hive.openBox<int>('offlineDeleteBox');
      print('All boxes initialized successfully');
    } catch (e) {
      print('Error initializing Hive boxes: $e');
      rethrow; // Ensure the error propagates if needed for debugging
    }
  }




  Future<void> addTask(Task task) async {
    if (await _isConnected()) {
      try {
        await taskBox.add(task);
        print('Task added to hive');
      } catch (e) {
        print('Error adding task to hive: $e');
      }
    } else {
      await offlineSaveBox.add(task);
      await taskBox.add(task);
      print('Task added to offline save queue');
    }
  }
  void addAllTasks(List<Task> tasks) {
    print('Add all tasks is called');
    try {
      taskBox.clear();
      try{
        taskBox.addAll(tasks);
      print('Tasks added to hive');
      }
      catch(e){
        print('Error in adding all tasks to hive is $e');
      }
    } catch (e) {
      print('Error adding tasks to hive: $e');
    }
  }
  Future<void> updateTask(Task updatedTask) async {
    final taskId = getTaskKey(updatedTask);
    if (taskId == null) {
      print('Task not found for updating');
      return;
    }

    if (await _isConnected()) {
      try {
        await taskBox.put(taskId, updatedTask);
        print('Task updated in hive');
      } catch (e) {
        print('Error updating task: $e');
      }
    } else {
      await offlineUpdateBox.put(taskId, updatedTask);
      await taskBox.put(taskId, updatedTask);
      print('Task added to offline update queue');
    }
  }

  Future<void> deleteTask(int taskId) async {
    if (await _isConnected()) {
      try {
        await taskBox.delete(taskId);
        print('Task deleted from hive');
      } catch (e) {
        print('Error deleting task: $e');
      }
    } else {
      await offlineDeleteBox.add(taskId);
      await taskBox.delete(taskId);
      print('Task added to offline delete queue');
    }
  }

  Future<void> syncOfflineTasks() async {
    print('Syncing offline tasks');

    // Sync saved tasks
    for (var key in offlineSaveBox.keys) {
      Task? task = offlineSaveBox.get(key);
      if (task != null) {
        try {
          await _firestoreService.addTask(userId, task);
          await offlineSaveBox.delete(key);
          print('Offline save task synced: $task');
        } catch (e) {
          print('Error syncing save task: $e');
        }
      }
    }

    // Sync updated tasks
    for (var key in offlineUpdateBox.keys) {
      Task? task = offlineUpdateBox.get(key);
      if (task != null) {
        try {
          await _firestoreService.updateTask(userId, task.idFirestore, task.toMap());
          await offlineUpdateBox.delete(key);
          print('Offline update task synced: $task');
        } catch (e) {
          print('Error syncing update task: $e');
        }
      }
    }

    // Sync deleted tasks
    for (var key in offlineDeleteBox.keys) {
      int? taskId = offlineDeleteBox.get(key);
      if (taskId != null) {
        try {
          await _firestoreService.deleteTask(userId, taskId.toString());
          await offlineDeleteBox.delete(key);
          print('Offline delete task synced: $taskId');
        } catch (e) {
          print('Error syncing delete task: $e');
        }
      }
    }
  }

  Future<bool> _isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  List<Task> getAllTasks() {
    print('Get all tasks is called');
    
    if (!Hive.isBoxOpen('tasksBox') || taskBox.isEmpty) {
      print('Error: taskBox is not open or initialized.');
      return [];
    }
    
    try {
      print('try to get all tasks');
      return taskBox.values.toList();
    } catch (e) {
      print('Error retrieving tasks: $e');
      return [];
    }
  }



  int getTaskCount() {
    if (!Hive.isBoxOpen('tasksBox')) {
      print('Error: taskBox is not open or initialized.');
      return 0;
    }
    try {
      return taskBox.length;
    } catch (e) {
      print('Error retrieving task count: $e');
      return 0;
    }
  }

int? getTaskKey(Task task) {
  try {
    // Ensure Hive is initialized
    ensureInitialized().then((_) {
      if (!Hive.isBoxOpen('tasksBox')) {
        print('Error: taskBox is not open.');
        return null;
      }

      final taskIndex = taskBox.values.toList().indexOf(task);
      if (taskIndex != -1) {
        return taskBox.keyAt(taskIndex) as int?;
      }
    }).catchError((e) {
      print('Error during Hive initialization: $e');
    });
  } catch (e) {
    print('Error retrieving task key is: $e');
  }
  return null;
}

}
