import 'package:clean_riverpod/features/ads/models/ad_model.dart';
import 'package:clean_riverpod/features/ads/presentation/widgets/ad_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Card widget for displaying a single ad in the listing.
class AdCard extends StatelessWidget {
  const AdCard({
    super.key,
    required this.ad,
    required this.onTap,
    required this.onLike,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStock,
  });

  final AdModel ad;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image + Stock Badge ─────────────────────────────────
            Stack(
              children: [
                SizedBox(
                  height: 180.h,
                  width: double.infinity,
                  child: ad.allImages.isNotEmpty
                      ? AdImage(
                          imageSource: ad.allImages.first,
                          borderRadius: BorderRadius.zero,
                        )
                      : Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            _categoryIcon(ad.category),
                            size: 64.sp,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.3),
                          ),
                        ),
                ),
                // Stock badge
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: ad.isInStock ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      ad.isInStock ? 'In Stock' : 'Stock Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Like button
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Material(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.r),
                      onTap: onLike,
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              ad.isLikedByMe
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: ad.isLikedByMe ? Colors.red : Colors.white,
                              size: 18.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${ad.likesCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Content ─────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      ad.category,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Title
                  Text(
                    ad.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),

                  // Price
                  Text(
                    '৳ ${ad.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Vendor
                  Row(
                    children: [
                      Icon(Icons.store_outlined,
                          size: 14.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          ad.vendorName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Action buttons
                  Row(
                    children: [
                      _ActionChip(
                        icon: ad.isInStock
                            ? Icons.remove_shopping_cart_outlined
                            : Icons.add_shopping_cart,
                        label: ad.isInStock ? 'Stock Out' : 'Restock',
                        color: ad.isInStock ? Colors.orange : Colors.green,
                        onTap: onToggleStock,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.edit_outlined, size: 20.sp),
                        tooltip: 'Edit',
                        onPressed: onEdit,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.all(4.w),
                      ),
                      SizedBox(width: 4.w),
                      IconButton(
                        icon: Icon(Icons.delete_outline,
                            size: 20.sp, color: Colors.redAccent),
                        tooltip: 'Delete',
                        onPressed: onDelete,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.all(4.w),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1.2),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.sp, color: color),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
