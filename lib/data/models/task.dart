import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  Task({
    this.id = -1,
    required this.title,
    required this.date,
    required this.priority,
    required this.timeToComplete,
    this.taskOwnerId = '',
    this.taskOwnerEmail,
    this.completedTime = '',
    this.isCompleted = false,
    this.isVisible = true,
    this.idFirestore = '',
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

  @HiveField(10)
  String idFirestore;

  

  // Task changedTask({
  //   required Task CurrentTask,
  //   String? id,
  //   String? title,
  //   String? date,
  //   String? priority,
  //   String? timeToComplete,
  //   String? completedTime,
  //   bool? isCompleted,
  // }) {
  //   print("change task is called: $id, $title, $date, $priority, $timeToComplete, $isCompleted, $isVisible");
  //   return Task(
  //     id: id ?? CurrentTask.id,
  //     title: title ?? CurrentTask.title,
  //     date: date ?? CurrentTask.date,
  //     priority: priority ?? CurrentTask.priority,
  //     timeToComplete: timeToComplete ?? CurrentTask.timeToComplete,
  //     completedTime: completedTime ?? CurrentTask.completedTime,
  //     isCompleted: isCompleted ?? CurrentTask.isCompleted,
  //     idFirestore: CurrentTask.idFirestore,
  //   );
  // }
  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'priority': priority,
      'timeToComplete': timeToComplete,
      'completedTime': completedTime,
      'isCompleted': isCompleted,
      'idFirestore': idFirestore,
    };
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'priority': priority,
      'timeToComplete': timeToComplete,
      'completedTime': completedTime,
      'isCompleted': isCompleted,
      'idFirestore': idFirestore,
    };
  }
  factory Task.fromMap(Map<String, dynamic> map){
    return Task(
      date:map['date'],
      id: map['taskId'],
      title: map['title'],
      priority: map['priority'],
      timeToComplete: map['timeToComplete'],
      taskOwnerId: map['taskOwnerId'],
      taskOwnerEmail: map['taskOwnerEmail'],
      completedTime: map['completedTime'],
      isCompleted: map['isCompleted'],
      idFirestore: map['idFirestore'],
    );

    }

  }

