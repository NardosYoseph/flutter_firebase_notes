import '../../domain/entities/auth_user.dart';


final class AuthState {
  const AuthState();
}

final class AuthInit extends AuthState {
  const AuthInit();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});
  final AuthUser user;
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthError extends AuthState {
  const AuthError({required this.message});
  final String message;
}

