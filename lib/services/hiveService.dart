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
  final userId = FirebaseAuth.instance.currentUser!.uid;



  Future<void> initializeHive() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter()); // Register adapter only if not already registered
    }
    taskBox = await Hive.openBox<Task>('tasksBox');
    offlineSaveBox = await Hive.openBox<Task>('offlineSaveBox');
    offlineUpdateBox = await Hive.openBox<Task>('offlineUpdateBox');
    offlineDeleteBox = await Hive.openBox<int>('offlineDeleteBox');
    
    // Start listening for connectivity changes
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        syncOfflineTasks();
      }
    });
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
  // void addAllTasks(List<Task> tasks) {
  //   try {
  //     taskBox.clear();
  //     try{
  //       taskBox.addAll(tasks);
  //     print('Tasks added to hive');
  //     }
  //     catch(e){
  //       print('Error in adding all tasks to hive is $e');
  //     }
  //   } catch (e) {
  //     print('Error adding tasks to hive: $e');
  //   }
  // }
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
    try {
      return taskBox.values.toList();
    } catch (e) {
      print('Error retrieving tasks: $e');
      return [];
    }
  }

  int getTaskCount() {
    return taskBox.length;
  }

  int? getTaskKey(Task task) {
    try {
      final taskIndex = taskBox.values.toList().indexOf(task);
      if (taskIndex != -1) {
        return taskBox.keyAt(taskIndex) as int?;
      }
    } catch (e) {
      print('Error retrieving task key: $e');
    }
    return null;
  }
}
