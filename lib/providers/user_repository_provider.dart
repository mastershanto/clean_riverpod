import 'package:clean_riverpod/core/repositories/api_user_repository.dart';
import 'package:clean_riverpod/core/repositories/local_user_repository.dart';
import 'package:clean_riverpod/core/repositories/mock_user_repository.dart';
import 'package:clean_riverpod/core/repositories/user_repository.dart';
import 'package:clean_riverpod/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  🔀  CHANGE THIS ONE LINE TO SWAP YOUR ENTIRE DATA LAYER
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Current active data source for the whole app.
///
///  • [DataSource.mock]  → In-memory fake data   (UI development)
///  • [DataSource.local] → Drift/SQLite database  (offline-first)
///  • [DataSource.api]   → REST API               (production)
const activeDataSource = DataSource.mock;

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

enum DataSource { mock, local, api }

final userRepositoryProvider = Provider<UserRepository>((ref) {
  switch (activeDataSource) {
    case DataSource.mock:
      return MockUserRepository();

    case DataSource.local:
      final database = ref.watch(databaseProvider);
      return LocalUserRepository(database);

    case DataSource.api:
      // TODO: Replace with your real base URL when the backend is ready
      return ApiUserRepository(baseUrl: 'https://api.example.com');
  }
});
