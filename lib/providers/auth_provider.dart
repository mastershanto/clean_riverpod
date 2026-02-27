import 'package:clean_riverpod/features/auth/models/auth_models.dart';
import 'package:clean_riverpod/providers/auth_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Auth state — holds the currently signed-in user (null = guest / signed out)
// ─────────────────────────────────────────────────────────────────────────────
final currentUserProvider =
    NotifierProvider<CurrentUserNotifier, AuthResponse?>(
        () => CurrentUserNotifier());

class CurrentUserNotifier extends Notifier<AuthResponse?> {
  @override
  AuthResponse? build() => null;

  void setUser(AuthResponse user) => state = user;

  void clearUser() => state = null;

  Future<void> logout() async {
    // Call repository logout if needed
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (e) {
      // Even if logout fails on backend, clear local state
    }
    clearUser();
  }
}

/// Convenience: true when a user is signed in
final isAuthenticatedProvider =
    Provider<bool>((ref) => ref.watch(currentUserProvider) != null);
