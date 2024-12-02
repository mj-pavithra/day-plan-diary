import 'package:firebase_database/firebase_database.dart';
import 'package:day_plan_diary/data/models/task.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("tasks");

  Future<void> backupTask(Task task) async {
    try {
      await _dbRef.child(task.id.toString()).set(task.toJson());
    } catch (e) {
      throw Exception('Error backing up task: $e');
    }
  }

  Future<void> backupAllTasks(List<Task> tasks) async {
    print('Backup all tasks');
    try {
      for (var task in tasks) {
        await backupTask(task);
      }
    } catch (e) {
      throw Exception('Error backing up tasks: $e');
    }
  }
  

}
