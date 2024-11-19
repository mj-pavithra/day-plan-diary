import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Models/task.dart';
import '../Utils/snackbar_utils.dart';

class TodoListViewModel extends ChangeNotifier {
  final Box<Task> _taskBox = Hive.box<Task>('tasksBox');
  String selectedPriority = 'All';
  bool isTodoSelected = true;

  List<Task> get filteredTasks {
    return _taskBox.values.where((task) {
      if (selectedPriority == 'All') {
        return task.isCompleted == !isTodoSelected;
      }
      return task.isCompleted == !isTodoSelected && task.priority == selectedPriority;
    }).toList();
  }

  void deleteTask(BuildContext context, dynamic taskKey) {
    _taskBox.delete(taskKey);
    SnackbarUtils.showSnackbar('Task deleted successfully', backgroundColor: Colors.red);
    notifyListeners();
  }

  void setSelectedPriority(String priority) {
    selectedPriority = priority;
    notifyListeners();
  }

  void setTodoSelection(bool isTodo) {
    isTodoSelected = isTodo;
    notifyListeners();
  }
}
