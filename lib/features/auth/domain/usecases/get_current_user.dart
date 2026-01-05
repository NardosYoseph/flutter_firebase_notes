import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

final class GetCurrentUser {
  const GetCurrentUser(this._repository);

  final AuthRepository _repository;

  AuthUser? call() => _repository.currentUser;
}
