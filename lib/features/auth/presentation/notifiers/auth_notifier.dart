import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/auth_usecases_providers.dart';
import '../state/auth_state.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  StreamSubscription? _authSub;

  @override
  AuthState build() {
    final getCurrentUser = ref.watch(getCurrentUserUseCaseProvider);
    final watchAuthState = ref.watch(watchAuthStateUseCaseProvider);

    _authSub?.cancel();
    _authSub = watchAuthState().listen((user) {
      state = user == null
          ? const AuthUnauthenticated()
          : AuthAuthenticated(user: user);
    });

    ref.onDispose(() {
      _authSub?.cancel();
    });

    final user = getCurrentUser();
    if (user == null) {
      return const AuthUnauthenticated();
    }

    return AuthAuthenticated(user: user);
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AuthLoading();
    try {
      final useCase = ref.read(signUpWithEmailPasswordUseCaseProvider);
      await useCase(email: email, password: password);
    } catch (e) {
      state = AuthError(message: e.toString());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AuthLoading();
    try {
      final useCase = ref.read(signInWithEmailPasswordUseCaseProvider);
      await useCase(email: email, password: password);
    } catch (e) {
      state = AuthError(message: e.toString());
    }
  }

  Future<void> signOut() async {
    state = const AuthLoading();
    try {
      final useCase = ref.read(signOutUseCaseProvider);
      await useCase();
    } catch (e) {
      state = AuthError(message: e.toString());
    }
  }
}
