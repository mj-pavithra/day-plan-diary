import 'package:day_plan_diary/data/models/task.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static late Box<Task> taskBox;

  static Future<void> initializeHive() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());  // Register adapter only if not already registered
    }
    taskBox = await Hive.openBox<Task>('tasksBox');
  }

  Future<void> addTask(Task task) async {
    await taskBox.add(task);
  }

  Future<void> deleteTask(int index) async {
    await taskBox.deleteAt(index);
  }

  List<Task> getAllTasks() {
    return taskBox.values.toList();
  }
  Future<void> updateTask(int index, Task updatedTask) async {
    await taskBox.putAt(index, updatedTask);
  }
}

