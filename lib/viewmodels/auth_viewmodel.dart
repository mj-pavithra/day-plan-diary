import '../data/repositories/auth_repository.dart';
// import '../data/repositories/user_repository.dart';
import 'base_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:day_plan_diary/viewmodels/session_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../utils/snackbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
class AuthViewModel extends BaseViewModel {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepository = AuthRepository();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
    
  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  Future<bool> checkIfAccountExists(String email) async {
    setState(ViewState.Loading);
    try {
      return await _authRepository.doesAccountExist(email);
    } finally {
      setState(ViewState.Idle);
    } 
  }

  Future<void> login(BuildContext context, String email, String password) async {
    setLoading();
    
    try {
      await _authRepository.login(email, password);
    } finally {
      setState(ViewState.Idle);
    }
  }
    Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // After successful login, save user session and navigate
        final sessionViewModel = Provider.of<SessionViewModel>(context, listen: false);
        sessionViewModel.saveSession(user.email!, user.displayName ?? '');

        GoRouter.of(context).go('/home');
      }
    } catch (e) {
      SnackbarUtils.showSnackbar("Google Sign-In failed: ${e.toString()}", backgroundColor: Colors.red);
      print("Google Sign-In failed: $e");
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
