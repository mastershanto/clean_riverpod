import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/iuser_repository.dart';
import '../models/user_model.dart';

class MockUserRepository implements IUserRepository {
  // In-memory 'database' for mock testing and agile prototyping.
  final List<UserModel> _users = [
    const UserModel(
      id: 'u_1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1 555-0100',
      address: '123 Fake Street, NY',
    ),
    const UserModel(
      id: 'u_2',
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
      phone: '+1 555-0200',
      address: '456 Imaginary Ave, LA',
    ),
  ];

  static const _mockDelay = Duration(milliseconds: 800);

  @override
  Future<List<UserEntity>> getAllUsers() async {
    // Simulating API network call delay
    await Future.delayed(_mockDelay);
    return _users.map((u) => u.toEntity()).toList();
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    await Future.delayed(_mockDelay);
    try {
      return _users.firstWhere((user) => user.id == id).toEntity();
    } catch (e) {
      // User not found
      return null;
    }
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    await Future.delayed(_mockDelay);

    // Simulate ID generation from backend if not provided.
    final newId = user.id.isEmpty
        ? 'u_${DateTime.now().millisecondsSinceEpoch}'
        : user.id;

    final newUserModel = UserModel(
      id: newId,
      name: user.name,
      email: user.email,
      phone: user.phone,
      address: user.address,
    );

    _users.add(newUserModel);

    return newUserModel.toEntity();
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    await Future.delayed(_mockDelay);

    final index = _users.indexWhere((u) => u.id == user.id);
    if (index >= 0) {
      final updatedModel = UserModel.fromEntity(user);
      _users[index] = updatedModel;
      return updatedModel.toEntity();
    } else {
      throw Exception('User not found. Could not update.');
    }
  }

  @override
  Future<bool> deleteUser(String id) async {
    await Future.delayed(_mockDelay);

    final initialLength = _users.length;
    _users.removeWhere((u) => u.id == id);

    return _users.length < initialLength;
  }
}
