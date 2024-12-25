import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.keyboard,
    this.validator,
    this.controller,
    this.obscureText,
    this.suffixIcon,
    this.onSaved,
  });

  final String label;
  final String hintText;
  final TextInputType keyboard;
  final IconButton? suffixIcon;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final bool? obscureText;
  final FormFieldSetter? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboard,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      onSaved: onSaved,
    );
  }
}
