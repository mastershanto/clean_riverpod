import 'package:clean_riverpod/features/auth/repositories/iauth_repository.dart';
import 'package:clean_riverpod/features/auth/repositories/mock_auth_repository.dart';
import 'package:clean_riverpod/features/auth/repositories/real_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Environment Configuration
// ─────────────────────────────────────────────────────────────────────────────
/// Switch between mock and real implementations
/// Change this to true when real API is ready
const bool _useMockApi = true;

// ─────────────────────────────────────────────────────────────────────────────
// Auth Repository Provider - Single source for dependency injection
// ─────────────────────────────────────────────────────────────────────────────
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  if (_useMockApi) {
    return MockAuthRepository();
  } else {
    // TODO: When ready, configure your real API client
    // Example:
    // final httpClient = ref.watch(httpClientProvider);
    // return RealAuthRepository(
    //   httpClient: httpClient,
    //   baseUrl: 'https://api.example.com',
    // );
    return RealAuthRepository();
  }
});
