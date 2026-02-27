import 'dart:async';

import 'package:clean_riverpod/features/auth/repositories/iauth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, bool?>(() {
  return AuthController();
});

class AuthController extends AsyncNotifier<bool?> {
  @override
  FutureOr<bool?> build() => null; // শুরুতে স্টেট খালি থাকবে
  

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading(); // লোডিং শুরু
    
    // রিপোজিটরি থেকে ডেটা আনা
    final repo = ref.read(authRepositoryProvider);
    
    state = await AsyncValue.guard(() => repo.login(email, password));
  }
}