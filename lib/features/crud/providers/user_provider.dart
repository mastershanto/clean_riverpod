import 'package:clean_riverpod/features/crud/models/user_model.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';

final userProvider = StateNotifierProvider<UserNotifier, List<UserModel>>((
  ref,
) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<List<UserModel>> {
  UserNotifier() : super([]);

  final _uuid = const Uuid();

  void addUser(UserModel user) {
    state = [...state, user.copyWith(id: _uuid.v4())];
  }

  void updateUser(UserModel updated) {
    state = [
      for (final user in state)
        if (user.id == updated.id) updated else user,
    ];
  }

  void deleteUser(String id) {
    state = state.where((user) => user.id != id).toList();
  }
}
