import 'package:firebase_auth/firebase_auth.dart'; // Add this line to import the User class
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/session_constants.dart';

class SessionService {
  Future<void> saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SessionConstants.isLoggedIn, true);
    await prefs.setString(SessionConstants.userId, user.uid);
    await prefs.setString(SessionConstants.userEmail, user.email ?? '');
    await prefs.setString(SessionConstants.userName, user.displayName ?? 'Use Name');
    await prefs.setString(SessionConstants.userPhotoUrl, user.photoURL ?? 'https://cdn-icons-png.flaticon.com/128/3135/3135715.png');

  }

  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<Map<String, dynamic>> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(SessionConstants.isLoggedIn) ?? false;
    final userId = prefs.getString(SessionConstants.userId);
    final userEmail = prefs.getString(SessionConstants.userEmail);
    final userName = prefs.getString(SessionConstants.userName);
    final userPhotoUrl = prefs.getString(SessionConstants.userPhotoUrl);
    print("isLoggedIn: $isLoggedIn, userId: $userId, userEmail: $userEmail");

    return {
      "isLoggedIn": isLoggedIn,
      "userId": userId,
      "userEmail": userEmail,
      "userName": userName,
      "userPhotoUrl": userPhotoUrl,
    };
  }
  Future <String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString(SessionConstants.userName);
    return userName ?? 'User Name';
  }
}
