import 'package:day_plan_diary/services/notification_service.dart';
import 'package:day_plan_diary/viewmodels/base_viewmodel.dart';
import 'package:day_plan_diary/viewmodels/todoItemViewModel.dart';
import 'package:day_plan_diary/viewmodels/todoListViewModel.dart';
import 'package:day_plan_diary/utils/network_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'routes/appRouter.dart';
import 'services/hiveService.dart';
import 'utils/snackbar.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'package:day_plan_diary/services/fcm_service.dart';
import 'package:day_plan_diary/utils/providerInstaller.dart';
import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';
// import 'viewmodels/session_viewmodel.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  // Hive Initialization
  await Hive.initFlutter();
  await HiveService.initializeHive();

  // Firebase Initialization
  await Firebase.initializeApp();

  // Notification Service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Network Utils Initialization
  NetworkUtils.initialize();

  // FCM Service
  final fcmService = FCMService();
  await fcmService.initializeFCM();

  // final firestoreService = FirestoreService();
  // firestoreService.ensureGooglePlayServices();
  SecurityProviderUtil.updateSecurityProvider();


  // Run the App
  runApp(const MyApp());
}


//GoogleApiAvailability debugging code ends here

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoListViewModel()),
        ChangeNotifierProvider(
          create: (context) => TodoItemViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => BaseViewModel()),
      ],
      child: MaterialApp.router(
        scaffoldMessengerKey: SnackbarUtils.messengerKey,
        routerConfig: appRouter,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
      ),
    );
  }
}
