import '../../services/session_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class SessionRepository {
  final SessionService _sessionService = SessionService();

  Future<void> saveSession(User user) async {
      _sessionService.saveUserSession(user);
      return Future.value();
      }

  Future<void> clearSession() async{
      print("session is cleared");
      return _sessionService.clearUserSession();
    }

  Future<Map<String, dynamic>> getSession() async{ 
    final session = await _sessionService.getUserSession();
      print("new session is created");
      return session;
    }
  
}
