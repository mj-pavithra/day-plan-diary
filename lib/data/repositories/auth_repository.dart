import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream for auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  Future<bool> doesAccountExist(String email) async {
    try {
      final methods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }

 Future<UserCredential> login(String email, String password) async {
  try {
    // Sign in with email and password
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } catch (e) {
    throw Exception("Login failed: ${e.toString()}");
  }
}


   Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<void> register(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }


}



