import 'package:clean_riverpod/core/repositories/user_repository.dart';
import 'package:clean_riverpod/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return UserRepository(database);
});
