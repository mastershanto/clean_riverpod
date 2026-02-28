import '../../../../core/database/app_database.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/iuser_repository.dart';
import '../models/user_model.dart';

/// Local database implementation using Drift
class LocalUserRepository implements IUserRepository {
  final AppDatabase _database;

  LocalUserRepository(this._database);

  @override
  Future<List<UserEntity>> getAllUsers() async {
    final users = await _database.getAllUsers();
    return users.map((u) => UserModel.fromDriftUser(u)).toList();
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    final user = await _database.getUserById(id);
    return user != null ? UserModel.fromDriftUser(user) : null;
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    final companion = userModel.toCompanion();
    await _database.insertUser(companion);
    return user;
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    final driftUser = userModel.toDriftUser();
    await _database.updateUser(driftUser);
    return user;
  }

  @override
  Future<bool> deleteUser(String id) async {
    final result = await _database.deleteUser(id);
    return result > 0;
  }
}
