import 'package:clean_riverpod/core/repositories/ad_repository.dart';
import 'package:clean_riverpod/core/repositories/mock_ad_repository.dart';
import 'package:clean_riverpod/providers/user_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the active [AdRepository] based on [activeDataSource].
///
/// Uses the same [DataSource] enum from user_repository_provider
/// so the whole app switches together.
final adRepositoryProvider = Provider<AdRepository>((ref) {
  switch (activeDataSource) {
    case DataSource.mock:
      return MockAdRepository();

    case DataSource.local:
      // TODO: return LocalAdRepository(ref.watch(databaseProvider));
      return MockAdRepository(); // fallback until Drift table is created

    case DataSource.api:
      // TODO: return ApiAdRepository(baseUrl: '...');
      return MockAdRepository(); // fallback until API is ready
  }
});
