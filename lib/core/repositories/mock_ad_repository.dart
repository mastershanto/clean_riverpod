import 'dart:async';
import 'package:clean_riverpod/core/repositories/ad_repository.dart';
import 'package:clean_riverpod/features/ads/models/ad_model.dart';

/// In-memory fake data source for ads — no database, no API.
///
/// Perfect for building the full UI before the backend is ready.
class MockAdRepository implements AdRepository {
  // ── In-memory store ───────────────────────────────────────────────
  final List<AdModel> _ads = [
    AdModel(
      id: 'ad-1',
      vendorId: 'vendor-1',
      vendorName: 'TechBD Store',
      title: 'iPhone 15 Pro Max',
      description:
          'Brand new iPhone 15 Pro Max 256GB. Natural Titanium color. Full box with warranty card. Factory unlocked for all carriers.',
      price: 185000,
      category: 'Electronics',
      imageUrl: 'https://picsum.photos/seed/iphone/400/300',
      images: [
        'https://picsum.photos/seed/iphone2/400/300',
        'https://picsum.photos/seed/iphone3/400/300',
      ],
      isInStock: true,
      likesCount: 24,
      isLikedByMe: false,
      createdAt: DateTime(2026, 2, 10),
    ),
    AdModel(
      id: 'ad-2',
      vendorId: 'vendor-2',
      vendorName: 'FashionHub BD',
      title: 'Premium Leather Jacket',
      description:
          'Genuine leather jacket, perfect for winter. Available in black and brown. Sizes: M, L, XL. Free home delivery in Dhaka.',
      price: 4500,
      category: 'Fashion',
      imageUrl: 'https://picsum.photos/seed/jacket/400/300',
      isInStock: true,
      likesCount: 12,
      isLikedByMe: true,
      createdAt: DateTime(2026, 2, 15),
    ),
    AdModel(
      id: 'ad-3',
      vendorId: 'vendor-1',
      vendorName: 'TechBD Store',
      title: 'Samsung Galaxy Tab S9',
      description:
          'Samsung Galaxy Tab S9 with S-Pen. 128GB storage, Wi-Fi only. Graphite color. Comes with original cover and charger.',
      price: 72000,
      category: 'Electronics',
      imageUrl: 'https://picsum.photos/seed/tablet/400/300',
      isInStock: false,
      likesCount: 8,
      isLikedByMe: false,
      createdAt: DateTime(2026, 2, 18),
    ),
    AdModel(
      id: 'ad-4',
      vendorId: 'vendor-3',
      vendorName: 'HomeDecor BD',
      title: 'Handmade Wooden Bookshelf',
      description:
          'Beautiful handmade wooden bookshelf. 5 shelves, solid teak wood. Dimensions: 6ft x 3ft. Assembly included for Dhaka orders.',
      price: 12500,
      category: 'Furniture',
      imageUrl: 'https://picsum.photos/seed/shelf/400/300',
      isInStock: true,
      likesCount: 5,
      isLikedByMe: false,
      createdAt: DateTime(2026, 2, 20),
    ),
    AdModel(
      id: 'ad-5',
      vendorId: 'vendor-2',
      vendorName: 'FashionHub BD',
      title: 'Running Shoes - Nike Air Max',
      description:
          'Original Nike Air Max 270. Size 42. Black/White colorway. Imported from Singapore. Cash on delivery available.',
      price: 8900,
      category: 'Fashion',
      imageUrl: 'https://picsum.photos/seed/shoes/400/300',
      images: [
        'https://picsum.photos/seed/shoes2/400/300',
        'https://picsum.photos/seed/shoes3/400/300',
        'https://picsum.photos/seed/shoes4/400/300',
      ],
      isInStock: true,
      likesCount: 31,
      isLikedByMe: true,
      createdAt: DateTime(2026, 2, 21),
    ),
  ];

  final _controller = StreamController<List<AdModel>>.broadcast();

  void _emit() => _controller.add(List.unmodifiable(_ads));

  // ── AdRepository contract ─────────────────────────────────────────

  @override
  Future<List<AdModel>> getAllAds() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_ads);
  }

  @override
  Future<AdModel?> getAdById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _ads.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> createAd(AdModel ad) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _ads.insert(0, ad); // newest first
    _emit();
  }

  @override
  Future<void> updateAd(AdModel ad) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _ads.indexWhere((a) => a.id == ad.id);
    if (index != -1) {
      _ads[index] = ad;
      _emit();
    }
  }

  @override
  Future<void> deleteAd(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _ads.removeWhere((a) => a.id == id);
    _emit();
  }

  @override
  Future<void> toggleLike(String adId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _ads.indexWhere((a) => a.id == adId);
    if (index != -1) {
      final ad = _ads[index];
      _ads[index] = ad.copyWith(
        isLikedByMe: !ad.isLikedByMe,
        likesCount: ad.isLikedByMe ? ad.likesCount - 1 : ad.likesCount + 1,
      );
      _emit();
    }
  }

  @override
  Future<void> toggleStock(String adId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _ads.indexWhere((a) => a.id == adId);
    if (index != -1) {
      final ad = _ads[index];
      _ads[index] = ad.copyWith(isInStock: !ad.isInStock);
      _emit();
    }
  }

  @override
  Stream<List<AdModel>> watchAllAds() async* {
    yield List.unmodifiable(_ads);
    yield* _controller.stream;
  }
}
