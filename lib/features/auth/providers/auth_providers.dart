import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/auth_entities.dart';
import '../domain/repositories/iauth_repository.dart';
import '../data/repositories/mock_auth_repository.dart';
import '../data/repositories/real_auth_repository.dart';

/// Environment config
const bool _useMock = true;

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  if (_useMock) {
    return MockAuthRepository();
  } else {
    return RealAuthRepository();
  }
});

final currentUserProvider = NotifierProvider<CurrentUserNotifier, AuthUser?>(
    () => CurrentUserNotifier());

class CurrentUserNotifier extends Notifier<AuthUser?> {
  @override
  AuthUser? build() => null;

  void setUser(AuthUser user) => state = user;
  void clearUser() => state = null;

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (_) {}
    clearUser();
  }
}
