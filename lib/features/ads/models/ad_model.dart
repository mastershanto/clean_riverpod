/// Domain model for an advertisement / product listing.
///
/// This model is used across ALL layers (UI, provider, repository).
/// The repository implementations convert their raw data → [AdModel].
class AdModel {
  final String id;
  final String vendorId;
  final String vendorName;
  final String title;
  final String description;
  final double price;
  final String category;

  /// Primary image URL or local file path.
  final String imageUrl;

  /// Additional images (URLs or local file paths).
  final List<String> images;
  final bool isInStock;
  final int likesCount;
  final bool isLikedByMe;
  final DateTime createdAt;

  const AdModel({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.images = const [],
    this.isInStock = true,
    this.likesCount = 0,
    this.isLikedByMe = false,
    required this.createdAt,
  });

  /// All images combined — primary first, then extras.
  List<String> get allImages => [if (imageUrl.isNotEmpty) imageUrl, ...images];

  AdModel copyWith({
    String? id,
    String? vendorId,
    String? vendorName,
    String? title,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    List<String>? images,
    bool? isInStock,
    int? likesCount,
    bool? isLikedByMe,
    DateTime? createdAt,
  }) {
    return AdModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      isInStock: isInStock ?? this.isInStock,
      likesCount: likesCount ?? this.likesCount,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
