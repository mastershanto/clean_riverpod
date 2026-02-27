import 'dart:async';

import 'package:clean_riverpod/features/auth/models/auth_models.dart';
import 'package:clean_riverpod/features/auth/repositories/iauth_repository.dart';
import 'package:clean_riverpod/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthResponse?>(
  () {
    return AuthController();
  },
);

class AuthController extends AsyncNotifier<AuthResponse?> {
  @override
  FutureOr<AuthResponse?> build() => null; // শুরুতে স্টেট খালি থাকবে

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();

    final repo = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final response = await repo.signIn(email, password);
      if (response != null) {
        ref.read(currentUserProvider.notifier).setUser(response);
      }
      return response;
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.logout();

      ref.read(currentUserProvider.notifier).state = null;
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
