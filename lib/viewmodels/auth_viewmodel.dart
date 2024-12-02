import 'package:day_plan_diary/services/session_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/auth_repository.dart';
import '../utils/snackbar.dart';
// import '../data/repositories/user_repository.dart';
import 'base_viewmodel.dart';
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
  setLoading(); // Set loading state to show progress indicator
  
  // try {
    // Perform login and get Firebase User
    final UserCredential userCredential = await _authRepository.login(email, password);
    final User user = userCredential.user ?? _auth.currentUser!;
  setIdle();
    print("test layer 3");
    // Save session with retrieved user details
  print('Save session for ${user.email}');
  
    final sessionService = await SessionService.getInstance();
    await sessionService?.saveUserDetails(user); // 'user' is a Firebase User object

    print("test layer 4");
    // Navigate to Home
    GoRouter.of(context).go('/home');

  // setLoading(); // Reset loading state
  //   } catch (e) {
  //   SnackbarUtils.showSnackbar("Login failed: ${e.toString()}", backgroundColor: Colors.red);
  //   print("Login failed: $e");
  // } finally {
  //   setIdle(); // Reset loading state
  // }
}


Future<void> signInWithGoogle(BuildContext context) async {
  try {
    // Force the user to choose an account each time
    await _googleSignIn.signOut(); // Ensure no account is pre-selected
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception("Google Sign-In was canceled by the user.");
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      print('User logged in: ID = ${user.uid}, Email = ${user.email}');

      // Save session
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final sessionService = await SessionService.getInstance();
      await sessionService?.saveUserDetails(user); // 'user' is a Firebase User object

      GoRouter.of(context).go('/home');
    }
  } catch (e) {
    SnackbarUtils.showSnackbar("Google Sign-In failed: ${e.toString()}", backgroundColor: Colors.red);
    print("Google Sign-In failed: $e");
    setIdle();
  }
}


  Future<void> register(String email, String password) async {
    setState(ViewState.Loading);
    try {
      await _authRepository.register(email, password);
    } finally {
      setIdle();
    }
  }
  Future<void> logout(BuildContext context) async {
  setState(ViewState.Loading);
  try {
    // Sign out from Firebase
    await _auth.signOut();

    // Sign out from Google
    await _googleSignIn.signOut();

    // Clear SharedPreferences data
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Remove all stored data

    // Optionally notify SessionViewModel to reset session state
    final sessionService = await SessionService.getInstance();
    await sessionService?.clearUserDetails(); // 'user' is a Firebase User object

    print("User has logged out successfully.");
  } catch (e) {
    print("Logout failed: $e");
  } finally {
    setState(ViewState.Idle);
  }
}


}
