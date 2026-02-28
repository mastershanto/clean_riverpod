import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/database_provider.dart';
import '../domain/repositories/iuser_repository.dart';
import '../data/repositories/mock_user_repository.dart';
import '../data/repositories/local_user_repository.dart';
import '../domain/entities/user_entity.dart';

/// Environment config: set to false to use local Drift database
const bool _useMock = true;

/// Provider for the User Repository.
/// Switch between Mock (for rapid prototyping) and Local database (Drift).
/// Later, add `RemoteUserRepository` for API integration.
final userRepositoryProvider = Provider<IUserRepository>((ref) {
  if (_useMock) {
    return MockUserRepository();
  } else {
    final database = ref.watch(databaseProvider);
    return LocalUserRepository(database);
  }
});

/// A future provider to fetch a single user by ID.
final userProvider = FutureProvider.family<UserEntity?, String>((ref, id) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserById(id);
});

/// A future provider to fetch all users.
final usersListProvider = FutureProvider<List<UserEntity>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getAllUsers();
});
