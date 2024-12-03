import 'package:day_plan_diary/data/models/task.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FirebaseService {
  final _database = FirebaseDatabase.instance.ref();

  Future<void> saveTask(Task task) async {
    await _database.child('tasks').child(task.id.toString()).set({
      'id': task.id,
      'title': task.title,
      'date': task.date,
      'timeToComplete': task.timeToComplete,
      'priority': task.priority,
      'isCompleted': task.isCompleted,
      'userTokens': await _getUserDeviceTokens(),
    });
  }

  Future<List<String>> _getUserDeviceTokens() async {
    // Fetch the current user's FCM tokens from your database
    return ['exampleToken1', 'exampleToken2']; // Replace with actual implementation
  }
}

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Message received in background: ${message.notification?.title}');
  }

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void handleMessage(RemoteMessage? message) {
  if (message != null) {
    navigatorKey.currentState?.pushNamed('/notification', arguments: message);
  }


 }
class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeFCM() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received in foreground: ${message.notification?.title}');
    });
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initPushNotification();

    final token = await _firebaseMessaging.getToken();
    print('Device token: $token');
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      handleMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification != null) {
        print('Message received in foreground: ${notification.title}');
      }
      // _localNotifications.show(message);
    });
  }
}
