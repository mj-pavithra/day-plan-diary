import 'package:day_plan_diary/Models/task.dart';
import 'package:day_plan_diary/Services/hiveService.dart';
import 'package:flutter/material.dart';

class UpdateTaskViewModel extends ChangeNotifier {
  late TextEditingController titleController;
  late TextEditingController dateController;
  late String selectedPriority;
  late bool isCompleted;
  late Task task;
  late int taskId;

  UpdateTaskViewModel({
    required this.task,
    required this.taskId
  });
 
  void initialize(Task task) {
    titleController = TextEditingController(text: task.title);
    dateController = TextEditingController(text: task.date);
    selectedPriority = task.priority;
    isCompleted = task.isCompleted;
  }

  void setPriority(String priority) {
    selectedPriority = priority;
    notifyListeners();
  }

  void setCompletion(bool completed) {
    isCompleted = completed;
    notifyListeners();
  }

  Task getUpdatedTask() {
    return Task(
      title: titleController.text,
      date: dateController.text,
      priority: selectedPriority,
      isCompleted: isCompleted,
    );
  }
 Future<void> updateTask(taskId, getUpdatedTask) async {
    
    //validate and update task
    
    final hiveService = HiveService();
    await hiveService.updateTask(taskId, task);
  }


}
