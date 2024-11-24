import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> checkIfAccountExists(String email) async {
    setLoading(true);
    try {
      return await _authRepository.doesAccountExist(email);
    } finally {
      setLoading(false);
    }
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    try {
      await _authRepository.login(email, password);
    } finally {
      setLoading(false);
    }
  }
  Future<void> register(String email, String password) async {
    setLoading(true);
    try {
      await _authRepository.register(email, password);
    } finally {
      setLoading(false);
    }
  }

}
