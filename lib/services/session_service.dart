import 'package:shared_preferences/shared_preferences.dart';

import '../utils/session_constants.dart';

class SessionService {
  Future<void> saveUserSession(String userId, String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SessionConstants.isLoggedIn, true);
    await prefs.setString(SessionConstants.userId, userId);
    await prefs.setString(SessionConstants.userEmail, userEmail);
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
    print("isLoggedIn: $isLoggedIn, userId: $userId, userEmail: $userEmail");

    return {
      "isLoggedIn": isLoggedIn,
      "userId": userId,
      "userEmail": userEmail,
    };
  }
}
