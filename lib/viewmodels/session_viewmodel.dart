import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import '../data/repositories/session_repository.dart';

class SessionViewModel with ChangeNotifier {
  final SessionRepository _sessionRepository = SessionRepository();

  bool _isLoggedIn = false;
  String? _userId;
  String? _userEmail;
  String? _displayPhoto ;

  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  String? get userEmail => _userEmail;

  Future<void> checkSession() async {
    final session = await _sessionRepository.getSession();
    _isLoggedIn = session['isLoggedIn'] ?? false;
    _userId = session['userId'];
    _userEmail = session['userEmail'];
    _displayPhoto = session['userPhotoUrl'];
    
    print(_userEmail);
    notifyListeners();
  }

  Future<void> saveSession(User user ) async {
    await _sessionRepository.saveSession(user);
    _isLoggedIn = true;
    _userId = user.uid;
    _userEmail = user.email;
    _displayPhoto = user.photoURL;
    print(  'Save session for $_userEmail');
    notifyListeners();
  }

  Future<void> clearSession() async {
    await _sessionRepository.clearSession();
    print('Clear seccion for (before) $_userEmail');
    _isLoggedIn = false;
    _userId = null;
    _userEmail = null;
    print('Clear seccion for (after) $_userEmail');
    notifyListeners();
  }
}
