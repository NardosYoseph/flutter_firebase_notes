import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_providers.g.dart';

@riverpod
Connectivity connectivity(Ref ref) {
  return Connectivity();
}

@riverpod
Stream<List<ConnectivityResult>> connectivityChanges(Ref ref) {
  return ref.watch(connectivityProvider).onConnectivityChanged;
}

@riverpod
Stream<bool> isOnline(Ref ref) {
  return ref
      .watch(connectivityChangesProvider.stream)
      .map((results) => results.any((r) => r != ConnectivityResult.none));
}
