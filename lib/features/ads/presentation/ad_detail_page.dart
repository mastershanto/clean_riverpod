import 'package:clean_riverpod/features/ads/providers/ad_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

/// Detail page for a single ad.
///
/// Receives [adId] via the route; fetches data reactively from the provider.
class AdDetailPage extends ConsumerWidget {
  const AdDetailPage({super.key, required this.adId});

  final String adId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsAsync = ref.watch(adProvider);
    final theme = Theme.of(context);

    return adsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (ads) {
        final ad = ads.where((a) => a.id == adId).firstOrNull;
        if (ad == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Ad Not Found')),
            body: const Center(child: Text('This ad has been deleted.')),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // ── App Bar with Image ────────────────────────────────
              SliverAppBar(
                expandedHeight: 250.h,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Icon(
                        _categoryIcon(ad.category),
                        size: 80.sp,
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
                actions: [
                  // Share button
                  IconButton(
                    icon: const Icon(Icons.share),
                    tooltip: 'Share',
                    onPressed: () => _shareAd(ad.title, ad.price),
                  ),
                ],
              ),

              // ── Content ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stock + Category row
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: ad.isInStock ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              ad.isInStock ? 'In Stock' : 'Stock Out',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              ad.category,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Title
                      Text(
                        ad.title,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Price
                      Text(
                        '৳ ${ad.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Divider
                      const Divider(),
                      SizedBox(height: 8.h),

                      // Vendor info
                      _InfoSection(
                        icon: Icons.store_outlined,
                        label: 'Vendor',
                        value: ad.vendorName,
                      ),
                      SizedBox(height: 12.h),

                      // Posted date
                      _InfoSection(
                        icon: Icons.calendar_today_outlined,
                        label: 'Posted',
                        value: _formatDate(ad.createdAt),
                      ),
                      SizedBox(height: 12.h),

                      // Likes
                      _InfoSection(
                        icon: Icons.favorite_outline,
                        label: 'Likes',
                        value: '${ad.likesCount}',
                      ),
                      SizedBox(height: 16.h),

                      const Divider(),
                      SizedBox(height: 8.h),

                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        ad.description,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.6,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.8),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => ref
                                  .read(adProvider.notifier)
                                  .toggleLike(ad.id),
                              icon: Icon(
                                ad.isLikedByMe
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: ad.isLikedByMe ? Colors.red : null,
                              ),
                              label: Text(ad.isLikedByMe ? 'Unlike' : 'Like'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => ref
                                  .read(adProvider.notifier)
                                  .toggleStock(ad.id),
                              icon: Icon(
                                ad.isInStock
                                    ? Icons.remove_shopping_cart_outlined
                                    : Icons.add_shopping_cart,
                              ),
                              label:
                                  Text(ad.isInStock ? 'Stock Out' : 'Restock'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _shareAd(ad.title, ad.price),
                          icon: const Icon(Icons.share),
                          label: const Text('Share this Ad'),
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareAd(String title, double price) {
    Share.share(
      'Check out this ad!\n\n$title\nPrice: ৳ ${price.toStringAsFixed(0)}\n\n— Shared from Clean Riverpod Marketplace',
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.devices;
      case 'fashion':
        return Icons.checkroom;
      case 'furniture':
        return Icons.chair;
      case 'food':
        return Icons.restaurant;
      case 'vehicle':
        return Icons.directions_car;
      default:
        return Icons.shopping_bag;
    }
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: Colors.grey),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
