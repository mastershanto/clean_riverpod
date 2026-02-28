import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/repositories/iuser_repository.dart';
import '../data/repositories/mock_user_repository.dart';
import '../domain/entities/user_entity.dart';

/// Provider for the User Repository.
/// We use [MockUserRepository] to adhere to Agile workflow, getting the UI layer
/// ready to consume data while the real backend API is being worked on.
/// Later, we just switch this to `RemoteUserRepository` which uses HTTP/Dio.
final userRepositoryProvider = Provider<IUserRepository>((ref) {
  return MockUserRepository();
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
