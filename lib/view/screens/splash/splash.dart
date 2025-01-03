import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnUserSession();
  }

  Future<void> _navigateBasedOnUserSession() async {
    // Allow the current build to complete first
    await Future.delayed(Duration.zero);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('User is logged in user ID: ${user.uid} email: ${user.email}');
        context.go('/home'); // Navigate to Home
      } else {
        print('No user logged in.');
        context.go('/login'); // Navigate to Login
      }
    } catch (e) {
      print('Error during session check: $e');
      context.go('/login'); // Default to Login on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width , // Full screen width
          child: 
          Image(
            image: AssetImage('assets/images/splash_image.png'),
            fit: BoxFit.cover, // Cover the container area
            width: MediaQuery.of(context).size.width ,
          ),
        ),
      ),
    );
  }
}
