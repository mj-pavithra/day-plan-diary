import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.priority,
    required this.timeToComplete,
    required this.taskOwnerId,
    this.taskOwnerEmail,
    this.completedTime = '',
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
  String timeToComplete;

  @HiveField(5)
  String taskOwnerId;

  @HiveField(6)
  String? taskOwnerEmail;

  @HiveField(7)
  String completedTime;

  @HiveField(8)
  bool isCompleted;

  
  @HiveField(9)
  bool isVisible;

  

  Task changedTask({
    required Task CurrentTask,
    int? id,
    String? title,
    String? date,
    String? priority,
    String? timeToComplete,
    String? taskOwnerId,
    String? taskOwnerEmail,
    String? completedTime,
    bool? isCompleted,
    bool? isVisible
  }) {
    print("change task is called: $id, $title, $date, $priority, $taskOwnerId, $taskOwnerEmail, $timeToComplete, $isCompleted, $isVisible");
    return Task(
      id: id ?? CurrentTask.id,
      title: title ?? CurrentTask.title,
      date: date ?? CurrentTask.date,
      priority: priority ?? CurrentTask.priority,
      timeToComplete: timeToComplete ?? CurrentTask.timeToComplete,
      taskOwnerId: taskOwnerId ?? CurrentTask.taskOwnerId,
      taskOwnerEmail: taskOwnerEmail ?? CurrentTask.taskOwnerEmail,
      completedTime: completedTime ?? CurrentTask.completedTime,
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
      'timeToComplete': timeToComplete,
      'taskOwnerId': taskOwnerId,
      'taskOwnerEmail': taskOwnerEmail,
      'completedTime': completedTime,
      'isCompleted': isCompleted,
      'isVisible': isVisible,
    };
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'priority': priority,
      'timeToComplete': timeToComplete,
      'taskOwnerId': taskOwnerId,
      'taskOwnerEmail': taskOwnerEmail,
      'completedTime': completedTime,
      'isCompleted': isCompleted,
    };
  }
}
