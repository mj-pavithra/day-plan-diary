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
import 'package:connectivity_plus/connectivity_plus.dart';

class TodoItemViewModel extends BaseViewModel {

  // final FirestoreService_firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final session;
  // late final FirebaseService _firebaseService;
  late final HiveService _hiveService;
  late final FirestoreService _firestoreService;
  final User? user = FirebaseAuth.instance.currentUser;
  late bool _networkAvailable;
  final Connectivity _connectivity = Connectivity();
  // final NotificationService _notificationService = NotificationService();
  
  final List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  TodoItemViewModel() {
    // _firebaseService = FirebaseService();
    _hiveService = HiveService();
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

  Future<void> _initializeSession() async {
    session = await SessionService.getInstance(); 
       // Initialize network listener
  }

  Future<bool> _isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
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
  required Task task,
}) async {
  if (task.title.isEmpty || task.date.isEmpty || task.priority == "Select Priority") {
    SnackbarUtils.showSnackbar('Please fill all fields', backgroundColor: Colors.red);
    throw Exception('Please fill all fields');
  }

  DateTime selectedDate = DateTime.parse(task.date);
  if (selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
    SnackbarUtils.showSnackbar('Please select a valid date', backgroundColor: Colors.red);
    throw Exception('Please select a valid date');
  }

  try {
    // Fetch user details from the session
    final userId = user?.uid ?? "testUid";
    print('User ID is fetched: $userId');
    final userEmail = _auth.currentUser!.email;
    print('User Email is fetched: $userEmail');

    // Increment counter for task ID
    final id = session.getCounter() + 1;
    print('Counter before increment: ${session.getCounter()}');
    session.incrementCounter();
    print('Counter is incremented: ${session.getCounter()}');

    // Create a new task with the incremented ID
    final newTask = task.copyWith(id: id);
    bool y = await _isConnected();

    if (y) {
      try {
        await _firestoreService.addTask(user?.uid ?? '', newTask);

        try{await _hiveService.addTask(newTask);}
        catch(e){
          print('Error adding task to hive: $e');
          throw Exception('Error adding task: $e');
        }
        SnackbarUtils.showSnackbar("Task saved and synced online", backgroundColor: Colors.green);
      } catch (e) {
        print('Error saving task to Firestore: $e');
        SnackbarUtils.showSnackbar("Task saved locally, sync failed: $e", backgroundColor: Colors.orange);
      }
    } else {

    await _hiveService.addTask(newTask);
      SnackbarUtils.showSnackbar("Task saved locally, will sync when online", backgroundColor: Colors.orange);
    }

    notifyListeners();

    // Schedule a notification
    try {
      await NotificationService().scheduleNotification(
        title: 'Task Reminder',
        body: 'Don\'t forget: ${task.title}',
        scheduledTime: DateTime.now().add(const Duration(seconds: 5)),
      );
    } catch (e) {
      print('Error in scheduling notification: $e');
    }

    GoRouter.of(context).go('/home');
    SnackbarUtils.showSnackbar(
      "New task added successfully",
      backgroundColor: Colors.green,
    );

    // Backup task to Firebase realtime database
    // await _backupTaskToFirebase(newTask);
  } catch (e) {
    SnackbarUtils.showSnackbar('Error saving task: $e', backgroundColor: Colors.red);
    throw Exception('Error saving task: $e');
  }
}


// Future<void> _backupTaskToFirebase(Task task) async {
//     try {
//       await _firebaseService.backupTask(task);
//     } catch (e) {
//       print('Error backing up task to Firebase: $e');
//     }
//   }


  // Delete task via HiveService
  Future<void> deleteTask(Task task, int index) async {
    final idFirestore = task.idFirestore;
    final userId = user?.uid ?? "";
    _networkAvailable = await NetworkUtils.isNetworkAvailable();

      print('Task ID: $idFirestore, Index: $index, networkAvailable: $_networkAvailable');

      if (_networkAvailable) {
      try{
        await _firestoreService.deleteTask(userId, idFirestore);
        print('Task deleted from firestore');
          try{
          await _hiveService.deleteTask(index);
          print('Task deleted from hive in online mode');
          }
        catch(e){
          print('Error deleting task from hive: $e');
          _firestoreService.retryFirestoreDelete(userId, idFirestore);
          throw Exception('Error deleting task: $e');
        }
      }
      catch(e){
        print('Error deleting task from firestore: $e');
        throw Exception('Error deleting task: $e');
      }}
      else{
        try{
          await _hiveService.deleteTask(index);
          print('Task deleted from hive in offline mode (ViewModel)');
          }
        catch(e){
          print('Error deleting task from hive: $e');
          throw Exception('Error deleting task: $e');
        }
      }
      notifyListeners();
      SnackbarUtils.showSnackbar(
        "Task deleted successfully",
        backgroundColor: Colors.red,
      );
  }
  //   Future<void> deleteTask(Task task, int index) async {
  //   final idFirestore = task.idFirestore;
  //   final userId = user?.uid ?? "";
  //     try{
  //       await _hiveService.deleteTask(index);
  //       print('Task deleted from hive');
  //       }
  //     catch(e){
  //       print('Error deleting task from hive: $e');
  //       throw Exception('Error deleting task: $e');
  //     }
  //     try{
  //       await _firestoreService.deleteTask(userId, idFirestore);
  //       print('Task deleted from firestore');
  //       }
  //     catch(e){
  //       print('Error deleting task from firestore: $e');
  //       throw Exception('Error deleting task: $e');
  //     }
  //     notifyListeners();
  //     SnackbarUtils.showSnackbar(
  //       "Task deleted successfully",
  //       backgroundColor: Colors.red,
  //     );
  // }
    // Confirms task deletion - displays a confirmation dialog
  Future <bool> confirmDelete (BuildContext context,  Task task, int index) async{
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
              deleteTask(task, index);
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
  // Future<void> updateTask(Task updatedTask) async {
  //   int? taskId = HiveService().getTaskKey(updatedTask);
  //   print("Title: ${updatedTask.title} Index: $taskId updated");
  //   String userId = _auth.currentUser!.uid;
  //   String taskKey = updatedTask.idFirestore;
  //   try {
  //     await _firestoreService.updateTask(userId, taskKey, updatedTask.toMap());
  //     await HiveService().updateTask(updatedTask);
  //     }
  //   catch(e) {
  //     print('Error updating task: $e');
  //     throw Exception('Error updating task: $e');
  //     }
  //   notifyListeners();
  // }
  Future<void> updateTask(Task updatedTask) async {
  // Verify task and user details

    bool isOnline = await _isConnected();
  if (updatedTask.idFirestore.isEmpty) {
    print('Error: Task ID is empty.');
    throw Exception('Task ID cannot be empty.');
  }

  String? userId = _auth.currentUser?.uid;
  if (userId == null || userId.isEmpty) {
    print('Error: User ID is empty or null.');
    throw Exception('User is not logged in.');
  }

  String taskKey = updatedTask.idFirestore;
  print('Task ID: $taskKey');

  if( isOnline)
  {
    try {
      // Update Firestore
      await _firestoreService.updateTask(userId, taskKey, updatedTask.toMap());

      // Update Hive
      await HiveService().updateTask(updatedTask);

      print('Task updated successfully: ${updatedTask.title}');
    } catch (e) {
      print('Error updating task: $e');
      throw Exception('Error updating task: $e');
    }
  }
  else {
    // Update Hive
    await HiveService().updateTask(updatedTask);
    print('Task updated in hive');
  }

  notifyListeners();
}


}
