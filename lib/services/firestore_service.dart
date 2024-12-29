import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_plan_diary/data/models/task.dart';
import 'package:google_api_availability/google_api_availability.dart';



class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> addTask(String userId, Task task) async {
  final taskCollection = _firestore.collection('tasks').doc(userId).collection('userTasks');
  
  // Create a document reference to get the auto-generated document ID
  final docRef = taskCollection.doc();

  // Add the task data with the document ID included
  await docRef.set({
    ...task.toMap(), 
    'idFirestore': docRef.id, // Include the document ID as a field
  });
}


  Future<List<Task>> getTasks(String userId) async {
    try{final taskCollection =_firestore.collection('tasks').doc(userId).collection('userTasks');
    final querySnapshot = await taskCollection.get();
    querySnapshot.docs.forEach((doc) {
      print('Document data: ${doc.data()}');
    });

    return querySnapshot.docs
        .map((doc) => Task.fromMap(doc.data() ))
        .toList();}
    catch(e){
      print('error is $e');
      return [];
    }
  }

  Future<int> getTaskCount(String userId) async {
    final taskCollection = _firestore.collection('tasks').doc(userId).collection('userTasks');
    final querySnapshot = await taskCollection.get();
    return querySnapshot.docs.length;
  }

  Future<void> updateTask(String userId, String taskId, Map<String, dynamic> updates) async {
    final taskDoc = _firestore.collection('tasks').doc(userId).collection('userTasks').doc(taskId);
    await taskDoc.update(updates);
  }

  Future<void> deleteTask(String userId, String taskId) async {
    final taskDoc = _firestore.collection('tasks').doc(userId).collection('userTasks').doc(taskId);
    await taskDoc.delete();
  }
  Future<void> retryFirestoreDelete(String userId, String idFirestore) async {
  int retries = 3;
  while (retries > 0) {
    try {
      await deleteTask(userId, idFirestore);
      print('Task deleted from Firestore on retry');
      return;
    } catch (e) {
      retries--;
      print('Retrying Firestore delete... Retries left: $retries');
      await Future.delayed(Duration(seconds: 2));
    }
  }
  print('Failed to delete task from Firestore after retries');
}

  void ensureGooglePlayServices() async {
    final GooglePlayServicesAvailability status = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();

    if (status != GooglePlayServicesAvailability.success) {
      print('Google Play Services not available: $status');
    }
  }
}
