import '../data/repositories/auth_repository.dart';
import '../data/repositories/user_repository.dart';
import 'base_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this line to import User type from firebase

class AuthViewModel extends BaseViewModel {
  final AuthRepository _authRepository = AuthRepository();
    

  // Stream for auth state changes
  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  Future<bool> checkIfAccountExists(String email) async {
    setState(ViewState.Loading);
    try {
      return await _authRepository.doesAccountExist(email);
    } finally {
      setState(ViewState.Idle);
    } 
  }

  Future<void> login(String email, String password) async {
    setLoading();

    try {
      await _authRepository.login(email, password);
    } finally {
      setState(ViewState.Idle);
    }
  }
  Future<void> register(String email, String password) async {
    setState(ViewState.Loading);
    try {
      await _authRepository.register(email, password);
    } finally {
      setState(ViewState.Idle);
    }
  }
  Future<void> logout() async {
    setState(ViewState.Loading);
    try {
      await _authRepository.logout();
    } finally {
      setState(ViewState.Idle);
    }
  }

}
