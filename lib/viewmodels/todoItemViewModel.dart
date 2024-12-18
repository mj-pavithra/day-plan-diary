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

  // final FirestoreService_firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final session;
  // late final FirebaseService _firebaseService;
  late final HiveService _hiveService;
  late final FirestoreService _firestoreService;
  final User? user = FirebaseAuth.instance.currentUser;
  bool _networkAvailable = false;
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
    NetworkUtils.initialize();
    NetworkUtils.onNetworkChange.listen((networkStatus) {
      _networkAvailable = networkStatus;
      notifyListeners();
    });
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
  if(_networkAvailable){
    await _hiveService.addTask(newTask);
    await _firestoreService.addTask(userId, newTask);
  }
  else{
    try{
      await _hiveService.addTask(newTask);
      }
    catch(e){
      print('Error saving task to hive: $e');
      throw Exception('Error saving task: $e');
    }
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
      try{
        await _hiveService.deleteTask(index);
        print('Task deleted from hive');
        }
      catch(e){
        print('Error deleting task from hive: $e');
        throw Exception('Error deleting task: $e');
      }
      try{
        await _firestoreService.deleteTask(userId, idFirestore);
        print('Task deleted from firestore');
        }
      catch(e){
        print('Error deleting task from firestore: $e');
        throw Exception('Error deleting task: $e');
      }
      notifyListeners();
      SnackbarUtils.showSnackbar(
        "Task deleted successfully",
        backgroundColor: Colors.red,
      );
  }
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
  Future<void> updateTask(Task updatedTask) async {
    int? taskId = HiveService().getTaskKey(updatedTask);
    print("Title: ${updatedTask.title} Index: $taskId updated");
    String userId = _auth.currentUser!.uid;
    String taskKey = updatedTask.idFirestore;
    try {
      await _firestoreService.updateTask(userId, taskKey, updatedTask.toMap());
      await HiveService().updateTask(updatedTask);
      }
    catch(e) {
      throw Exception('Error updating task: $e');
      }
    notifyListeners();
  }

}
