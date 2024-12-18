// import 'package:hive/hive.dart';

// part 'task.g.dart';

// @HiveType(typeId: 1)
// class Task {
//   Task({
//     this.id = -1,
//     required this.title,
//     required this.date,
//     required this.priority,
//     required this.timeToComplete,
//     this.taskOwnerId = '',
//     this.taskOwnerEmail,
//     this.completedTime = '',
//     this.isCompleted = false,
//     this.isVisible = true,
//     this.idFirestore = '',
//   });
//   @HiveField(0)
//   int id;

//   @HiveField(1)
//   String title;

//   @HiveField(2)
//   String date;

//   @HiveField(3)
//   String priority;

//   @HiveField(4) 
//   String timeToComplete;

//   @HiveField(5)
//   String taskOwnerId;

//   @HiveField(6)
//   String? taskOwnerEmail;

//   @HiveField(7)
//   String completedTime;

//   @HiveField(8)
//   bool isCompleted;

  
//   @HiveField(9)
//   bool isVisible;

//   @HiveField(10)
//   String idFirestore;

  

//   Task changedTask({
//     required Task CurrentTask,
//     int? id,
//     String? title,
//     String? date,
//     String? priority,
//     String? timeToComplete,
//     String? completedTime,
//     bool? isCompleted,
//   }) {
//     print("change task is called: $id, $title, $date, $priority, $timeToComplete, $isCompleted, $isVisible");
//     return Task(
//       id: id ?? CurrentTask.id,
//       title: title ?? CurrentTask.title,
//       date: date ?? CurrentTask.date,
//       priority: priority ?? CurrentTask.priority,
//       timeToComplete: timeToComplete ?? CurrentTask.timeToComplete,
//       completedTime: completedTime ?? CurrentTask.completedTime,
//       isCompleted: isCompleted ?? CurrentTask.isCompleted,
//       idFirestore: CurrentTask.idFirestore,
//     );
//   }
  

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'date': date,
//       'priority': priority,
//       'timeToComplete': timeToComplete,
//       'taskOwnerId': taskOwnerId,
//       'taskOwnerEmail': taskOwnerEmail,
//       'completedTime': completedTime,
//       'isCompleted': isCompleted,
//       'isVisible': isVisible,
//       'idFirestore': idFirestore,
//     };
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'date': date,
//       'priority': priority,
//       'timeToComplete': timeToComplete,
//       'taskOwnerId': taskOwnerId,
//       'taskOwnerEmail': taskOwnerEmail,
//       'completedTime': completedTime,
//       'isCompleted': isCompleted,
//       'isVisible': isVisible,
//       'idFirestore': idFirestore,
//     };
//   }

//   factory Task.fromMap(Map<String, dynamic> map) {
//     return Task(
//       id: map['id'] ?? -1, // Default to -1 if not present
//       title: map['title'] ?? '',
//       date: map['date'] ?? '',
//       priority: map['priority'] ?? '',
//       timeToComplete: map['timeToComplete'] ?? '',
//       taskOwnerId: map['taskOwnerId'] ?? '',
//       taskOwnerEmail: map['taskOwnerEmail'],
//       completedTime: map['completedTime'] ?? '',
//       isCompleted: map['isCompleted'] ?? false,
//       isVisible: map['isVisible'] ?? true,
//       idFirestore: map['idFirestore'] ?? '',
//     );
//   }

// }
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

  /// Creates a copy of the current task with some properties updated
  Task copyWith({
    int? id,
    String? title,
    String? date,
    String? priority,
    String? timeToComplete,
    String? taskOwnerId,
    String? taskOwnerEmail,
    String? completedTime,
    bool? isCompleted,
    bool? isVisible,
    String? idFirestore,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      timeToComplete: timeToComplete ?? this.timeToComplete,
      taskOwnerId: taskOwnerId ?? this.taskOwnerId,
      taskOwnerEmail: taskOwnerEmail ?? this.taskOwnerEmail,
      completedTime: completedTime ?? this.completedTime,
      isCompleted: isCompleted ?? this.isCompleted,
      isVisible: isVisible ?? this.isVisible,
      idFirestore: idFirestore ?? this.idFirestore,
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
      'idFirestore': idFirestore,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? -1,
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      priority: map['priority'] ?? '',
      timeToComplete: map['timeToComplete'] ?? '',
      taskOwnerId: map['taskOwnerId'] ?? '',
      taskOwnerEmail: map['taskOwnerEmail'],
      completedTime: map['completedTime'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      isVisible: map['isVisible'] ?? true,
      idFirestore: map['idFirestore'] ?? '',
    );
  }
}
