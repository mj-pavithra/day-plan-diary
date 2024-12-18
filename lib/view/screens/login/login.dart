import 'package:day_plan_diary/utils/snackbar.dart';
import 'package:day_plan_diary/utils/validators.dart';
import 'package:day_plan_diary/view/widgets/custom_text_field.dart';
import 'package:day_plan_diary/viewmodels/auth_viewmodel.dart';
import 'package:day_plan_diary/viewmodels/base_viewmodel.dart';
// import 'package:day_plan_diary/viewmodels/session_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart'; 

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String? _emailError;

  // Initialize FirebaseAuth and GoogleSignIn
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Future<void> _signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final UserCredential userCredential = await _auth.signInWithCredential(credential);
  //     final User? user = userCredential.user;

  //     if (user != null) {
  //       // After successful login, save user session and navigate
  //       final sessionViewModel = Provider.of<SessionViewModel>(context, listen: false);
  //       sessionViewModel.saveSession(user.email!, user.displayName ?? '');

  //       GoRouter.of(context).go('/home');
  //     }
  //   } catch (e) {
  //     SnackbarUtils.showSnackbar("Google Sign-In failed: ${e.toString()}", backgroundColor: Colors.red);
  //     print("Google Sign-In failed: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);


  // final sessionViewModel = Provider.of<SessionViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Please log in to your account and start the adventure",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: "Email",
                isPassword: false,
                controller: _emailController,
                validator: Validators.validateEmail,
                onFieldSubmitted: (value) async {
                  final exists = await authViewModel.checkIfAccountExists(value);
                  setState(() {
                    _emailError = exists ? null : "Account does not exist";
                  });
                },
              ),
              if (_emailError != null)
                Text(
                  _emailError!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: "Password",
                isPassword: true,
                controller: _passwordController,
                validator: Validators.validatePassword,
                obscureText: !_isPasswordVisible,
                togglePasswordVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              const Spacer(),
              authViewModel.state == ViewState.Loading
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                              try {
                                print('test layer 2 : goog way');
                                await authViewModel.login(
                                  context,
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );

                              GoRouter.of(context).go('/home');
                                }
                                catch (e) {
                                  print("test layer 2");
                                  SnackbarUtils.showSnackbar(e.toString(), backgroundColor: Colors.red);
                                  authViewModel.state == ViewState.Idle;
                                }
                                finally{
                                authViewModel.state == ViewState.Idle;
                                }
                              // User? user = _auth.currentUser;
                              print("test layer 1");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 50),
                          backgroundColor: const Color.fromARGB(206, 87, 39, 176),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Login", style: TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await authViewModel.signInWithGoogle(context);
                  },
                  style: ElevatedButton.styleFrom(
                    maximumSize: const Size(300, 50),
                    minimumSize: const Size(300, 50),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  child:const Center(
                    child:  Text(
                      "Sign in with Google",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const Text("Don't you have an account?", style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).go('/register');
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 50),
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 20, color: Color.fromARGB(206, 87, 39, 176)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
