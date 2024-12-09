import 'package:day_plan_diary/data/models/task.dart';
import 'package:day_plan_diary/services/firebase_service.dart';
import 'package:day_plan_diary/services/firestore_service.dart';
import 'package:day_plan_diary/services/hiveService.dart';
import 'package:day_plan_diary/services/notification_service.dart';
import 'package:day_plan_diary/services/session_service.dart';
import 'package:day_plan_diary/utils/network_utils.dart';
import 'package:day_plan_diary/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:day_plan_diary/viewmodels/session_viewmodel.dart';
import 'package:provider/provider.dart';

import './todoListViewModel.dart';
import 'base_viewmodel.dart';

class TodoItemViewModel extends BaseViewModel {

  final FirestoreService_firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final session;
  late final FirebaseService _firebaseService;
  late final HiveService _hiveService;
  late final FirestoreService _firestoreService;
  final User? user = FirebaseAuth.instance.currentUser;
  // final NotificationService _notificationService = NotificationService();
  
  final List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  TodoItemViewModel() {
    _firebaseService = FirebaseService();
    _firestoreService = FirestoreService();
    _initializeNetworkListener();
    _initializeNetworkListener();
    _initializeSession();
  }
  void _initializeNetworkListener() {
    NetworkUtils.onNetworkChange.listen((isConnected) async {
      if (isConnected) {
        // await _backupAllTasks();
        print('Connected to the internet');
      }
      else {
          SnackbarUtils.showSnackbar("Locally saved but online backup is not updated", backgroundColor: const Color.fromARGB(125, 244, 67, 54));
      }
    });
  }

//   Future<void> _backupAllTasks() async {
//   try {
//     print("Fetching tasks from local storage...");
//     final allTasks = _hiveService.getAllTasks();
//     if (allTasks.isEmpty) {
//       print("No tasks to backup.");
//       SnackbarUtils.showSnackbar(
//         "No tasks to backup",
//         backgroundColor: Colors.orange,
//       );
//       return;
//     }

//     try {
//       print("Backing up tasks to Firebase...");
//       await _firebaseService.backupAllTasks(allTasks);
//       print("Cloud backup completed successfully.");
//       SnackbarUtils.showSnackbar(
//         "Backup completed successfully",
//         backgroundColor: Colors.green,
//       );
//     } catch (e) {
//       print("Error during Firebase backup: $e");
//       SnackbarUtils.showSnackbar(
//         "Error during cloud backup: $e",
//         backgroundColor: Colors.red,
//       );
//     }
//   } catch (e) {
//     print("Error fetching tasks from local storage: $e");
//     SnackbarUtils.showSnackbar(
//       "Error accessing local tasks: $e",
//       backgroundColor: Colors.red,
//     );
//   }
// }


  Future<void> _initializeSession() async {
    session = await SessionService.getInstance();
  }

  var ListViewModel = TodoListViewModel();

Task? task;
  late TextEditingController titleController;
  late TextEditingController dateController;
  late String timeToComplete;
  late String completedTime;
  @override
  String selectedPriority = 'All';
  late bool isCompleted;
  
    void initialize(Task task) {
    titleController = TextEditingController(text: task.title);
    dateController = TextEditingController(text: task.date);
    timeToComplete = task.timeToComplete;
    completedTime = task.completedTime;
    selectedPriority = task.priority ;
    isCompleted = task.isCompleted ;
  }

    void setPriority(String priority) {
    selectedPriority = priority;
    notifyListeners();
  }

  void setCompletion(bool completed) {
    isCompleted = completed;
    notifyListeners();
  }
  void updatePriority(String newPriority) {
    selectedPriority = newPriority;
  }

  void updateCompletion(bool newCompletion) {
    isCompleted = newCompletion;
  }

  void updateTitle(String newTitle) {
    titleController.text = newTitle;
  }

  void updateDate(String newDate) {
    dateController.text = newDate;
  }



  void updateTimeToComplete(String newTimeToComplete) {
    timeToComplete = newTimeToComplete;
  }

  void updateCompletedTime(String newCompletedTime) {
    completedTime = newCompletedTime;
  }


  Task getUpdatedTask() {
    return Task(
      title: titleController.text,
      date: dateController.text,
      priority: selectedPriority,
      timeToComplete: timeToComplete,
      completedTime: completedTime,
      isCompleted: isCompleted,
    );
  }

  // Determines the color based on priority
  Color get priorityColor {
    switch (task?.priority) {
      case 'High':
        return const Color.fromARGB(255, 241, 2, 2);
      case 'Medium':
        return const Color.fromARGB(255, 250, 233, 0);
      default:
        return const Color.fromARGB(122, 42, 25, 194);
    }
  }




  // Helper function to validate and save a task
Future<void> saveTask({
  required BuildContext context,
  required int id,
  required String title,
  required String date,
  required String priority,
  required String timeToComplete,
}) async {
  if (title.isEmpty || date.isEmpty || priority == "Select Priority") {
    SnackbarUtils.showSnackbar('Please fill all fields', backgroundColor: Colors.red);
    throw Exception('Please fill all fields');
  }

  DateTime selectedDate = DateTime.parse(date);
  if (selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
    SnackbarUtils.showSnackbar('Please select a valid date', backgroundColor: Colors.red);
    throw Exception('Please select a valid date');
  }

  try {
    // Fetch user details from the session
    final userId = user?.uid?? "testUid";
    print('User ID is fetched : $userId');
    final userEmail = _auth.currentUser!.email;
    print('User Email is fetched : $userEmail');

    // Create a new task object
   id = session.getCounter();
   print ('Counter befor increment ${session.getCounter()}');
   session.incrementCounter();
   print ('Counter is incremented ${session.getCounter()}');
    final task = Task(
      id: id,
      title: title,
      date: date,
      timeToComplete: timeToComplete,
      completedTime: '',
      priority: priority,
      isCompleted: false,
    );
    
    
    await _hiveService.addTask(task);
    notifyListeners();

    // Schedule a notification

    // final notificationTime = selectedDate.add(const Duration(hours: 9));

    await NotificationService().scheduleNotification(
      title: 'Task Reminder',
      body: 'Don\'t forget: $title',
      scheduledTime: DateTime.now().add(const Duration(seconds: 5)), 
    );

    await _firestoreService.addTask(FirebaseAuth.instance.currentUser?.uid ?? "testUid", task);
    
    GoRouter.of(context).go('/home');
    SnackbarUtils.showSnackbar(
      "New task added successfully",
      backgroundColor: Colors.green,
    );

    // todo task list have to be refereshed
    await _backupTaskToFirebase(task);
  } catch (e) {
    SnackbarUtils.showSnackbar('Error saving task: $e', backgroundColor: Colors.red);
    throw Exception('Error saving task: $e');
  }
  
}

Future<void> _backupTaskToFirebase(Task task) async {
    try {
      await _firebaseService.backupTask(task);
    } catch (e) {
      print('Error backing up task to Firebase: $e');
    }
  }


  // Delete task via HiveService
  Future<void> deleteTask(int TaskIndex) async {

    try {
      await _hiveService.deleteTask(TaskIndex);
      notifyListeners();
      SnackbarUtils.showSnackbar(
        "Task deleted successfully",
        backgroundColor: Colors.red,
      );
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }
    // Confirms task deletion - displays a confirmation dialog
  Future <bool> confirmDelete (
      BuildContext context,  dynamic taskKey) async{
    
    return await showDialog <bool>(

      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: ()  {
                Navigator.pop(context, true);
              deleteTask(taskKey);
              },

              child: const Text("Delete"),
            ),
          ],
        );

      },
    )?? false;
  }
  void confirmComplete(BuildContext context,Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Mark as Completed"),
          content: const Text("Are you sure you want to mark this task as completed?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            Provider(
              create: (_) => TodoItemViewModel(),
              child: TextButton(
                onPressed: () {
                  task.isCompleted = true; 
                  updateTask(task);
                  Provider.of<TodoListViewModel>(context, listen:false).refreshFilteredTasks();
                  print('Completed task:- ${HiveService().getTaskKey(task)}');
                  Navigator.of(context).pop();
                },
                child: const Text("Confirm"),
              ),
            ),
          ],
        );
      },
    );
  }
  Future<void> updateTask(Task updatedTask) async {
    int taskId = HiveService().getTaskKey(updatedTask);
    print("Title: ${updatedTask.title} Index: $taskId updated");
    try {await HiveService().updateTask(updatedTask);}
    catch(e) {throw Exception('Error updating task: $e');}
    notifyListeners();
  }

}
