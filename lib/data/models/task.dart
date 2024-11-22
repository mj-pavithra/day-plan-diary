import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.priority,
    this.isCompleted = false,
  });
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String date;

  @HiveField(3)
  String priority;

  @HiveField(4)
  bool isCompleted;

  Task changedTask({
    int? id,
    String? title,
    String? date,
    String? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }
}
