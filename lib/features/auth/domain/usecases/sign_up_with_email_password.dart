import '../repositories/auth_repository.dart';

final class SignUpWithEmailPassword {
  const SignUpWithEmailPassword(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String email,
    required String password,
  }) {
    return _repository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
