import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/session_constants.dart';

class SessionService {
  static SessionService? _instance;
  static late SharedPreferences _prefs;

  // Private constructor
  SessionService._internal();

  // Factory constructor to return the singleton instance
  factory SessionService() {
    return _instance ??= SessionService._internal();
  }

  // Singleton instance initializer
  static Future<SessionService?> getInstance() async {
    if (_instance == null) {
      _instance = SessionService._internal();
      await _instance!._initializeSharedPreferences();
    }
    return _instance;
  }

  // Initialize SharedPreferences
  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }


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
    await _prefs.clear();
  }

  // Get all user details as a map
  Future<Map<String, dynamic>> getUserDetails() async {
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
  Future<String> getUserName() async {
    return _prefs.getString(SessionConstants.userName) ?? 'User Name';
  }
  Future<String> getUserEmail() async {
    return _prefs.getString(SessionConstants.userEmail) ?? 'User Email';
  }
  Future<String> getUserPhotoUrl() async {
    return _prefs.getString(SessionConstants.userPhotoUrl) ?? 'https://cdn-icons-png.flaticon.com/128/3135/3135715.png';
  }
  Future<String> getUserId() async {
    return _prefs.getString(SessionConstants.userId) ?? 'User ID';
  }
  Future<bool> getIsLoggedIn() async {
    return _prefs.getBool(SessionConstants.isLoggedIn) ?? false;
  }
  
}
