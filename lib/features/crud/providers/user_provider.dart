import 'package:clean_riverpod/features/crud/models/user_model.dart';
import 'package:clean_riverpod/providers/user_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final userProvider =
    StreamNotifierProvider.autoDispose<UserNotifier, List<UserModel>>(
  UserNotifier.new,
);

class UserNotifier extends StreamNotifier<List<UserModel>> {
  final _uuid = const Uuid();

  @override
  Stream<List<UserModel>> build() {
    final repository = ref.watch(userRepositoryProvider);
    return repository.watchAllUsers();
  }

  Future<void> addUser(UserModel user) async {
    final repository = ref.read(userRepositoryProvider);
    final newUser = user.copyWith(id: _uuid.v4());
    await repository.addUser(newUser);
  }

  Future<void> updateUser(UserModel updated) async {
    final repository = ref.read(userRepositoryProvider);
    await repository.updateUser(updated);
  }

  Future<void> deleteUser(String id) async {
    final repository = ref.read(userRepositoryProvider);
    await repository.deleteUser(id);
  }

  Future<void> deleteAllUsers() async {
    final repository = ref.read(userRepositoryProvider);
    await repository.deleteAllUsers();
  }
}
