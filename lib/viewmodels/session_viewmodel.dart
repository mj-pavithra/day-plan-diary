import 'package:flutter/material.dart';

import '../data/repositories/session_repository.dart';

class SessionViewModel with ChangeNotifier {
  final SessionRepository _sessionRepository = SessionRepository();

  bool _isLoggedIn = false;
  String? _userId;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  String? get userEmail => _userEmail;

  Future<void> checkSession() async {
    final session = await _sessionRepository.getSession();
    _isLoggedIn = session['isLoggedIn'] ?? false;
    _userId = session['userId'];
    _userEmail = session['userEmail'];
    print(_userEmail);
    notifyListeners();
  }

  Future<void> saveSession(String userId, String userEmail) async {
    await _sessionRepository.saveSession(userId, userEmail);
    _isLoggedIn = true;
    _userId = userId;
    _userEmail = userEmail;
    print(  'Save session for $_userEmail');
    notifyListeners();
  }

  Future<void> clearSession() async {
    await _sessionRepository.clearSession();
    _isLoggedIn = false;
    _userId = null;
    _userEmail = null;
    print('Clear seccion for $_userEmail');
    notifyListeners();
  }
}
