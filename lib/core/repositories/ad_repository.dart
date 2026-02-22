import 'package:clean_riverpod/features/ads/models/ad_model.dart';

/// Abstract contract for ad/listing operations.
///
/// UI only knows this interface — never the implementation.
/// Same pattern as [UserRepository].
abstract class AdRepository {
  /// Get all ads (one-shot).
  Future<List<AdModel>> getAllAds();

  /// Get a single ad by [id].
  Future<AdModel?> getAdById(String id);

  /// Create a new ad.
  Future<void> createAd(AdModel ad);

  /// Update an existing ad.
  Future<void> updateAd(AdModel ad);

  /// Delete an ad by [id].
  Future<void> deleteAd(String id);

  /// Toggle like on an ad.
  Future<void> toggleLike(String adId);

  /// Toggle stock status (in-stock ↔ out-of-stock).
  Future<void> toggleStock(String adId);

  /// Reactive stream of all ads.
  Stream<List<AdModel>> watchAllAds();
}
