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
    required Task CurrentTask,
    int? id,
    String? title,
    String? date,
    String? priority,
    bool? isCompleted,
    bool? isVisible
  }) {
    print("change task is called: $id, $title, $date, $priority, $isCompleted, $isVisible");
    return Task(
      id: id ?? CurrentTask.id,
      title: title ?? CurrentTask.title,
      date: date ?? CurrentTask.date,
      priority: priority ?? CurrentTask.priority,
      isCompleted: isCompleted ?? CurrentTask.isCompleted,
      isVisible: isVisible?? CurrentTask.isVisible
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
