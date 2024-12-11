import 'package:day_plan_diary/data/models/task.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Box<Task>? taskBox;

  static Future<void> initializeHive() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());  // Register adapter only if not already registered
    }
    taskBox = await Hive.openBox<Task>('tasksBox');
  }

  Future<void> addTask(Task task) async {
    try{
      await taskBox?.add(task);
      print('Task added to hive');
      }
    catch(e){
      print('Error adding task to hive: $e');
    }
  }

  void addAllTasks(List<Task> tasks) {
    try {
      taskBox?.clear();
      taskBox?.addAll(tasks);
      print('Tasks added to hive');
    } catch (e) {
      print('Error adding tasks to hive: $e');
    }
  }

  Future<void> deleteTask(int index) async {
    await taskBox?.deleteAt(index);
  }

  List<Task> getAllTasks() {
    print('Get all tasks is called');
    try{List<Task> allTasks = taskBox?.values.toList() ?? [];
    return allTasks;}
    catch(e){
      print('Error is $e');
      return [];
    }
  }

  int getTaskCount() {
    return taskBox?.length ?? 0;
  }


  int getTaskKey(Task task) {
    final taskIndex = taskBox?.values.toList().indexOf(task) ?? -1;
    if (taskIndex != -1) {
      return taskBox?.keyAt(taskIndex) ?? 0;
    }
    return 0;
  }

  Future<void> updateTask( Task updatedTask) async {
    int taskId = getTaskKey(updatedTask);
    try {
      await taskBox?.putAt(taskId, updatedTask);
      // print('Reach hive service');
    } catch (e) {
      // print('Error updating task: $e');
    }
  }
}

