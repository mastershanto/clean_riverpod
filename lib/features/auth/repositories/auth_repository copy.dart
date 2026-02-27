import 'dart:async';

import 'package:clean_riverpod/features/auth/repositories/iauth_repository.dart';
import 'package:clean_riverpod/features/crud/models/user_model.dart';
import 'package:clean_riverpod/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserModel?>(
  () {
    return AuthController();
  },
);

class AuthController extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() => null; // শুরুতে স্টেট খালি থাকবে

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading(); // লোডিং শুরু

    // রিপোজিটরি থেকে ডেটা আনা
    final repo = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final user = await repo.login(email, password);
      if (user != null) {
        // ইউজার লগইন সফল হলে currentUserProvider আপডেট করুন
        ref.read(currentUserProvider.notifier).state = user;
      }
      return user;
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.logout();

      // লগআউট সফল হলে state ক্লিয়ার করুন
      ref.read(currentUserProvider.notifier).state = null;
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
