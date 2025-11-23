import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final bool isObscureText;
  const CustomTextfield({
    super.key,
    required this.name,
    required this.controller,
    this.isObscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscureText,
      controller: controller,
      decoration: InputDecoration(hintText: name),
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$name is empty";
        }
        return null;
      },
    );
  }
}
