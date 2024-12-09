import 'package:day_plan_diary/utils/snackbar.dart';
import 'package:day_plan_diary/utils/validators.dart';
import 'package:day_plan_diary/view/widgets/custom_text_field.dart';
import 'package:day_plan_diary/viewmodels/auth_viewmodel.dart';
import 'package:day_plan_diary/viewmodels/base_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create an account to start your adventure",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: "Email",
                isPassword: false,
                controller: _emailController,
                validator: Validators.validateEmail,
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
              const SizedBox(height: 16),
              CustomTextField(
                labelText: "Confirm Password",
                isPassword: true,
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                obscureText: !_isConfirmPasswordVisible,
                togglePasswordVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              const Spacer(),

              ViewState == ViewState.Loading
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await authViewModel.register(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Registration successful')),
                              );
                              GoRouter.of(context).go('/login');
                            } catch (e) {
                              SnackbarUtils.showSnackbar(e.toString(), backgroundColor: Colors.red  
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 50),
                          backgroundColor: const Color.fromARGB(206, 87, 39, 176),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Register",style: TextStyle(fontSize: 20, color: Colors.white),),
                        
                      ),
                  ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const Text("Already have an account?", style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).go('/login');
                      },style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 50),
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Login",
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
