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
    List<Task> allTasks =taskBox.values.toList();

    List.generate (allTasks.length, (index) {
      final task = allTasks[index];
      final taskKey = getTaskKey(task);
      print('Task key: $taskKey  Title: ${task.title} isCompleted: ${task.isCompleted}');
      });
    return allTasks;
  }

  int getTaskKey(Task task) {
    final taskIndex = taskBox.values.toList().indexOf(task);
    if (taskIndex != -1) {
      return taskBox.keyAt(taskIndex);
    }
    return 0;
  }

  Future<void> updateTask( Task updatedTask) async {
    int taskId = getTaskKey(updatedTask);
    try {
      await taskBox.putAt(taskId, updatedTask);
      print('Reach hive service');
    } catch (e) {
      print('Error updating task: $e');
    }
  }
}

