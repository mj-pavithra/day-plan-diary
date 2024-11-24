import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final bool obscureText;
  final VoidCallback? togglePasswordVisibility;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.isPassword,
    required this.controller,
    required this.validator,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && obscureText,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(), // Add border for styling consistency
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: togglePasswordVisibility,
              )
            : null,
      ),
    );

  }
}
