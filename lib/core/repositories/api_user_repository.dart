import 'package:clean_riverpod/core/repositories/user_repository.dart';
import 'package:clean_riverpod/features/crud/models/user_model.dart';

/// REST API backed implementation of [UserRepository].
///
/// TODO: Replace placeholder bodies with real HTTP calls (dio / http package).
///
/// When your backend is ready:
///  1. Implement each method with actual API calls
///  2. Change `DataSource.mock` → `DataSource.api` in [user_repository_provider.dart]
///  3. Done — ZERO UI changes needed.
class ApiUserRepository implements UserRepository {
  final String baseUrl;

  ApiUserRepository({required this.baseUrl});

  @override
  Future<List<UserModel>> getAllUsers() async {
    // TODO: GET $baseUrl/users
    throw UnimplementedError('API not connected yet');
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    // TODO: GET $baseUrl/users/$id
    throw UnimplementedError('API not connected yet');
  }

  @override
  Future<void> addUser(UserModel user) async {
    // TODO: POST $baseUrl/users
    throw UnimplementedError('API not connected yet');
  }

  @override
  Future<void> updateUser(UserModel user) async {
    // TODO: PUT $baseUrl/users/${user.id}
    throw UnimplementedError('API not connected yet');
  }

  @override
  Future<void> deleteUser(String id) async {
    // TODO: DELETE $baseUrl/users/$id
    throw UnimplementedError('API not connected yet');
  }

  @override
  Future<void> deleteAllUsers() async {
    // TODO: DELETE $baseUrl/users
    throw UnimplementedError('API not connected yet');
  }

  @override
  Stream<List<UserModel>> watchAllUsers() {
    // TODO: Use polling, WebSocket, or SSE for real-time updates.
    // For now, fall back to a one-shot fetch wrapped in a stream.
    throw UnimplementedError('API not connected yet');
  }
}
