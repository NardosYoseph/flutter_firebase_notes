import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_with_email_password.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up_with_email_password.dart';
import '../../domain/usecases/watch_auth_state.dart';

part 'auth_usecases_providers.g.dart';

@riverpod
SignUpWithEmailPassword signUpWithEmailPasswordUseCase(Ref ref) {
  return SignUpWithEmailPassword(ref.watch(authRepositoryProvider));
}

@riverpod
SignInWithEmailPassword signInWithEmailPasswordUseCase(Ref ref) {
  return SignInWithEmailPassword(ref.watch(authRepositoryProvider));
}

@riverpod
SignOut signOutUseCase(Ref ref) {
  return SignOut(ref.watch(authRepositoryProvider));
}

@riverpod
WatchAuthState watchAuthStateUseCase(Ref ref) {
  return WatchAuthState(ref.watch(authRepositoryProvider));
}

@riverpod
GetCurrentUser getCurrentUserUseCase(Ref ref) {
  return GetCurrentUser(ref.watch(authRepositoryProvider));
}
