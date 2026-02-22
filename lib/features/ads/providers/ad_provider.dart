import 'package:clean_riverpod/features/ads/models/ad_model.dart';
import 'package:clean_riverpod/providers/ad_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Reactive stream provider for all ads.
final adProvider =
    StreamNotifierProvider.autoDispose<AdNotifier, List<AdModel>>(
  AdNotifier.new,
);

class AdNotifier extends StreamNotifier<List<AdModel>> {
  final _uuid = const Uuid();

  @override
  Stream<List<AdModel>> build() {
    final repository = ref.watch(adRepositoryProvider);
    return repository.watchAllAds();
  }

  Future<void> createAd(AdModel ad) async {
    final repository = ref.read(adRepositoryProvider);
    final newAd = ad.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
    );
    await repository.createAd(newAd);
  }

  Future<void> updateAd(AdModel ad) async {
    final repository = ref.read(adRepositoryProvider);
    await repository.updateAd(ad);
  }

  Future<void> deleteAd(String id) async {
    final repository = ref.read(adRepositoryProvider);
    await repository.deleteAd(id);
  }

  Future<void> toggleLike(String adId) async {
    final repository = ref.read(adRepositoryProvider);
    await repository.toggleLike(adId);
  }

  Future<void> toggleStock(String adId) async {
    final repository = ref.read(adRepositoryProvider);
    await repository.toggleStock(adId);
  }
}
