import 'dart:async';
import 'package:clean_riverpod/core/repositories/user_repository.dart';
import 'package:clean_riverpod/features/crud/models/user_model.dart';

/// In-memory fake data source — no database, no API, no dependencies.
///
/// Perfect for:
///  • Building & testing UI before the backend is ready
///  • Unit tests that need deterministic data
///  • Offline demos
///
/// Swap to [LocalUserRepository] or [ApiUserRepository] later
/// by changing a single enum value in the provider.
class MockUserRepository implements UserRepository {
  // ── In-memory store ───────────────────────────────────────────────
  final List<UserModel> _users = [
    const UserModel(
      id: 'mock-1',
      name: 'Shanto',
      email: 'shanto@example.com',
      phone: '+8801700000001',
      address: 'Dhaka, Bangladesh',
    ),
    const UserModel( 
      id: 'mock-2',
      name: 'Rahim Uddin',
      email: 'rahim@example.com',
      phone: '+8801700000002',
      address: 'Chittagong, Bangladesh',
    ),
    const UserModel(
      id: 'mock-3',
      name: 'Karim Ahmed',
      email: 'karim@example.com',
      phone: '+8801700000003',
      address: 'Sylhet, Bangladesh',
    ),
  ];

  // Stream controller to mimic reactive behaviour like Drift's .watch()
  final _controller = StreamController<List<UserModel>>.broadcast();

  /// Push current state to all listeners.
  void _emit() => _controller.add(List.unmodifiable(_users));

  // ── UserRepository contract ───────────────────────────────────────

  @override
  Future<List<UserModel>> getAllUsers() async {
    // Simulate network / DB latency so the UI loading state is visible
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_users);
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _users.add(user);
    _emit();
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
      _emit();
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _users.removeWhere((u) => u.id == id);
    _emit();
  }

  @override
  Future<void> deleteAllUsers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _users.clear();
    _emit();
  }

  @override
  Stream<List<UserModel>> watchAllUsers() async* {
    // Emit current data immediately, then listen for changes
    yield List.unmodifiable(_users);
    yield* _controller.stream;
  }
}
