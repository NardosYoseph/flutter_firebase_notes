import 'package:flutter/material.dart';

import '../../../../core/theme/constants.dart';
import '../utils/validators.dart';

class AuthPasswordField extends StatelessWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    this.textInputAction,
    this.onFieldSubmitted,
    this.minLength = 6,
  });

  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final int minLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: 'Password',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: minLength <= 0
            ? 'Your password'
            : 'Minimum $minLength characters',
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(
          borderRadius: Constants.borderRadiusMedium,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Constants.borderRadiusMedium,
        ),
      ),
      validator: (value) => validatePassword(value, minLength: minLength),
    );
  }
}
