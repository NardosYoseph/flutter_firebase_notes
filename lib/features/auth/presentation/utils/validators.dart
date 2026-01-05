String? validateEmail(String? value) {
  final v = value?.trim() ?? '';
  if (v.isEmpty) return 'Email is required';
  if (!v.contains('@')) return 'Enter a valid email';
  return null;
}

String? validatePassword(
  String? value, {
  int minLength = 6,
}) {
  final v = value ?? '';
  if (v.isEmpty) return 'Password is required';
  if (minLength > 0 && v.length < minLength) {
    return 'Password must be at least $minLength characters';
  }

  final hasUppercase = RegExp(r'[A-Z]').hasMatch(v);
  if (!hasUppercase) {
    return 'Password must contain at least 1 capital letter';
  }

  final hasNumber = RegExp(r'\d').hasMatch(v);
  if (!hasNumber) {
    return 'Password must contain at least 1 number';
  }

  return null;
}
