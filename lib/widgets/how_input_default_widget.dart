import 'package:flutter/material.dart';

class HowInputDefault extends StatelessWidget {
  final String labelText;
  final bool? obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final String? errorText;
  const HowInputDefault({
    super.key,
    required this.labelText,
    this.controller,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    this.focusNode,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        errorText: errorText,
        suffixIcon: suffixIcon,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        helperText: '',
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );
  }
}
