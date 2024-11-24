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
    this.isVisible = true,
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

  
  @HiveField(5)
  bool isVisible;

  Task changedTask({
    int? id,
    String? title,
    String? date,
    String? priority,
    bool? isCompleted,
    bool? isVisible
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      isVisible: isVisible?? this.isVisible
    );
  }
  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'priority': priority,
      'isCompleted': isCompleted,
      'isVisible': isVisible,
    };
  }
}
