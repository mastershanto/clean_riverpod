import 'package:clean_riverpod/features/crud/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Provider to track the current logged-in user
final currentUserProvider = StateProvider<UserModel?>(
  (ref) => null, // Initially no user is logged in
);

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(currentUserProvider) != null,
);
