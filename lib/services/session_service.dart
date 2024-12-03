import 'dart:async';

import 'package:day_plan_diary/viewmodels/todoListViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/session_constants.dart';

class SessionService {
  bool isPrefsInitialized() => _prefs != null;
  static SessionService? _instance;
  static late SharedPreferences _prefs;
  static final Completer<void> _prefsCompleter = Completer<void>();

  TodoListViewModel todoListViewModel = TodoListViewModel();

  // Private constructor
  SessionService._internal();

  // Factory constructor to return the singleton instance
  factory SessionService() {
    return _instance ??= SessionService._internal();
  }

  // Singleton instance initializer
  // static Future<SessionService?> getInstance() async {
  //   if (_instance == null) {
  //     _instance = SessionService._internal();
  //     await _instance!._initializeSharedPreferences();
  //   }
  //   return _instance;
  // }
static Future<SessionService?> getInstance() async {
  print("*******************Getting SharedPreferences Instance******************");
    if (_instance == null) {
      _instance = SessionService._internal();
      print("Initializing SharedPreferences...");
     await  _instance!._initializeSharedPreferences();
    }

    // Wait for `_prefs` initialization if it is still in progress
    if (!_prefsCompleter.isCompleted) {
      await _prefsCompleter.future;
    }

    print("SharedPreferences Initialized: $_prefs");
    return _instance;
  }

  Future<void> _initializeSharedPreferences() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      print("SharedPreferences Initialized: $_prefs");
      if (!_prefsCompleter.isCompleted) {
        _prefsCompleter.complete();
      }
    } catch (e) {
      print("Error during SharedPreferences initialization: $e");
      if (!_prefsCompleter.isCompleted) {
        _prefsCompleter.completeError(e);
      }
    }
  }
  // Initialize SharedPreferences



  // Save user details in SharedPreferences
  Future <void> saveUserDetails(User user) async {
    await _prefs.setBool(SessionConstants.isLoggedIn, true);
    await _prefs.setString(SessionConstants.userId, user.uid);
    await _prefs.setString(SessionConstants.userEmail, user.email ?? '');
    await _prefs.setString(SessionConstants.userName, user.displayName ?? 'User Name');
    await _prefs.setString(SessionConstants.userPhotoUrl, user.photoURL ?? 'https://cdn-icons-png.flaticon.com/128/3135/3135715.png');
  }

  // Clear all user details
  Future<void> clearUserDetails() async {
    // todoListViewModel.setLogOut(true);
    await _prefs.clear();
    _prefs.remove(SessionConstants.userEmail);
    _prefs.remove(SessionConstants.userId);
  }

  // Get all user details as a map
  Future<Map<String, dynamic>> getUserDetails() async {
    if (!isPrefsInitialized()) {
        print("Error: SharedPreferences not initialized.");
        return {};
    }
    final isLoggedIn = _prefs.getBool(SessionConstants.isLoggedIn) ?? false;
    final userId = _prefs.getString(SessionConstants.userId);
    final userEmail = _prefs.getString(SessionConstants.userEmail);
    final userName = _prefs.getString(SessionConstants.userName);
    final userPhotoUrl = _prefs.getString(SessionConstants.userPhotoUrl);

    return {
      "isLoggedIn": isLoggedIn,
      "userId": userId,
      "userEmail": userEmail,
      "userName": userName,
      "userPhotoUrl": userPhotoUrl,
    };
  }

  // Get the user's name
  String getUserName()  {
    return _prefs.getString(SessionConstants.userName) ?? 'User Name';
  }
String getUserEmail() {
    return _prefs.getString(SessionConstants.userEmail) ?? 'User Email';
}

  String getUserPhotoUrl()  {
    return _prefs.getString(SessionConstants.userPhotoUrl) ?? 'https://cdn-icons-png.flaticon.com/128/3135/3135715.png';
  }
  String getUserId()  {
    return _prefs.getString(SessionConstants.userId) ?? 'User ID';
  }
  bool getIsLoggedIn()  {
    return _prefs.getBool(SessionConstants.isLoggedIn) ?? false;
  }
  
}
