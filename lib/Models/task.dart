import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  Task({
    required this.title,
    required this.date,
    required this.priority,
    this.isCompleted = false,
  });

  @HiveField(0)
  String title;

  @HiveField(1)
  String date;

  @HiveField(2)
  String priority;

  @HiveField(3)
  bool isCompleted;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }
}
