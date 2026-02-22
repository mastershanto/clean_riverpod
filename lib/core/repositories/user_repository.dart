import 'package:clean_riverpod/features/crud/models/user_model.dart';

/// Abstract contract for user data operations.
///
/// UI only knows about this interface — never the implementation.
/// Swap between [MockUserRepository], [LocalUserRepository],
/// or [ApiUserRepository] without touching a single UI file.


abstract class UserRepository {
  /// Get all users (one-shot).
  Future<List<UserModel>> getAllUsers();

  /// Get a single user by [id]. Returns `null` if not found.
  Future<UserModel?> getUserById(String id);

  /// Add a new user.
  Future<void> addUser(UserModel user);

  /// Update an existing user.
  Future<void> updateUser(UserModel user);

  /// Delete a user by [id].
  Future<void> deleteUser(String id);

  /// Delete all users.
  Future<void> deleteAllUsers();

  /// Reactive stream of all users — rebuilds UI automatically on changes.
  Stream<List<UserModel>> watchAllUsers();
}
