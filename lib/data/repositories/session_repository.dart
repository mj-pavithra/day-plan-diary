import '../../services/session_service.dart';

class SessionRepository {
  final SessionService _sessionService = SessionService();

  Future<void> saveSession(String userId, String userEmail){
      _sessionService.saveUserSession(userId, userEmail);
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
