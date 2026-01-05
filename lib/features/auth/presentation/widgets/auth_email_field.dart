import 'package:flutter/material.dart';

import '../../../../core/theme/constants.dart';
import '../utils/validators.dart';

class AuthEmailField extends StatelessWidget {
  const AuthEmailField({
    super.key,
    required this.controller,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: 'Email',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'name@example.com',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: Constants.borderRadiusMedium,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Constants.borderRadiusMedium,
        ),
      ),
      validator: validateEmail,
    );
  }
}
