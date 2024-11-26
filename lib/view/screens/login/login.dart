import 'package:day_plan_diary/utils/snackbar.dart';
import 'package:day_plan_diary/utils/validators.dart';
import 'package:day_plan_diary/view/widgets/custom_text_field.dart';
import 'package:day_plan_diary/viewmodels/auth_viewmodel.dart';
import 'package:day_plan_diary/viewmodels/base_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

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
              const Center(child: SizedBox(height: 24)),
              authViewModel.state  == ViewState.Loading
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          print("Current State is $authViewModel.state" );
                          if (_formKey.currentState!.validate()) {
                            try {await authViewModel.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            GoRouter.of(context).go('/home');}
                            catch (e) {
                            SnackbarUtils.showSnackbar( e.toString(),backgroundColor: Colors.red);
                            }
                          }
                        },style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 50),
                          backgroundColor: const Color.fromARGB(206, 87, 39, 176),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Login",
                                    style: TextStyle(fontSize: 20, color: Colors.white),),
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
                      },style: ElevatedButton.styleFrom(
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
