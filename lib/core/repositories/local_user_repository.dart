import 'package:clean_riverpod/core/database/app_database.dart';
import 'package:clean_riverpod/core/repositories/user_repository.dart';
import 'package:clean_riverpod/features/crud/models/user_model.dart';
import 'package:drift/drift.dart';

/// Drift (SQLite) backed implementation of [UserRepository].
///
/// This is your local/offline data source.
/// It was formerly the only `UserRepository`; now it's one of many options.
class LocalUserRepository implements UserRepository {
  final AppDatabase _database;

  LocalUserRepository(this._database);

  // ── UserRepository contract ───────────────────────────────────────

  @override
  Future<List<UserModel>> getAllUsers() async {
    final users = await _database.getAllUsers();
    return users.map(_toDomainModel).toList();
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    final user = await _database.getUserById(id);
    return user != null ? _toDomainModel(user) : null;
  }

  @override
  Future<void> addUser(UserModel userModel) async {
    final companion = UsersCompanion(
      id: Value(userModel.id),
      name: Value(userModel.name),
      email: Value(userModel.email),
      phone: Value(userModel.phone),
      address: Value(userModel.address),
    );
    await _database.insertUser(companion);
  }

  @override
  Future<void> updateUser(UserModel userModel) async {
    final user = User(
      id: userModel.id,
      name: userModel.name,
      email: userModel.email,
      phone: userModel.phone,
      address: userModel.address,
    );
    await _database.updateUser(user);
  }

  @override
  Future<void> deleteUser(String id) async {
    await _database.deleteUser(id);
  }

  @override
  Future<void> deleteAllUsers() async {
    await _database.deleteAllUsers();
  }

  @override
  Stream<List<UserModel>> watchAllUsers() {
    return _database.watchAllUsers().map(
          (users) => users.map(_toDomainModel).toList(),
        );
  }

  // ── Mapper ────────────────────────────────────────────────────────

  UserModel _toDomainModel(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      address: user.address,
    );
  }
}
