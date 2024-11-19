import 'package:hive_flutter/hive_flutter.dart';
import 'package:day_plan_diary/Models/task.dart';

class HiveService {
  static late Box<Task> taskBox;
  static late Box<dynamic> testBox;

  static Future<void> initializeHive() async {
    taskBox = await Hive.openBox<Task>('tasksBox');
    testBox = await Hive.openBox('testBox');
  }
}
