import 'package:clean_riverpod/features/ads/models/ad_model.dart';
import 'package:clean_riverpod/features/ads/providers/ad_provider.dart';
import 'package:clean_riverpod/features/ads/presentation/widgets/ad_card.dart';
import 'package:clean_riverpod/features/ads/presentation/widgets/ad_form_dialog.dart';
import 'package:clean_riverpod/features/ads/presentation/widgets/ads_empty_state.dart';
import 'package:clean_riverpod/features/ads/presentation/widgets/delete_ad_dialog.dart';
import 'package:clean_riverpod/features/crud/providers/theme_provider.dart';
import 'package:clean_riverpod/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdsPage extends ConsumerWidget {
  const AdsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsAsync = ref.watch(adProvider);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Marketplace',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            tooltip: isDark ? 'Light Mode' : 'Dark Mode',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateAdDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Create Ad'),
      ),
      body: adsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (ads) => ads.isEmpty
            ? const AdsEmptyState()
            : _buildAdsList(context, ref, ads),
      ),
    );
  }

  Widget _buildAdsList(
    BuildContext context,
    WidgetRef ref,
    List<AdModel> ads,
  ) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: ads.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final ad = ads[index];
        return AdCard(
          ad: ad,
          onTap: () => AdDetailRoute(adId: ad.id).push(context),
          onLike: () => ref.read(adProvider.notifier).toggleLike(ad.id),
          onEdit: () => _showEditAdDialog(context, ref, ad),
          onDelete: () => _showDeleteDialog(context, ref, ad),
          onToggleStock: () => ref.read(adProvider.notifier).toggleStock(ad.id),
        );
      },
    );
  }

  void _showCreateAdDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (_) => AdFormDialog(
        isEdit: false,
        onSave: (title, description, price, category, vendorName) async {
          await ref.read(adProvider.notifier).createAd(
                AdModel(
                  id: '',
                  vendorId: 'current-vendor', // TODO: get from auth
                  vendorName: vendorName,
                  title: title,
                  description: description,
                  price: price,
                  category: category,
                  imageUrl: '',
                  createdAt: DateTime.now(),
                ),
              );
        },
      ),
    );
  }

  void _showEditAdDialog(BuildContext context, WidgetRef ref, AdModel ad) {
    showDialog<void>(
      context: context,
      builder: (_) => AdFormDialog(
        isEdit: true,
        initialTitle: ad.title,
        initialDescription: ad.description,
        initialPrice: ad.price.toStringAsFixed(0),
        initialCategory: ad.category,
        initialVendorName: ad.vendorName,
        onSave: (title, description, price, category, vendorName) async {
          await ref.read(adProvider.notifier).updateAd(
                ad.copyWith(
                  title: title,
                  description: description,
                  price: price,
                  category: category,
                  vendorName: vendorName,
                ),
              );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, AdModel ad) {
    showDialog<void>(
      context: context,
      builder: (_) => DeleteAdDialog(
        adTitle: ad.title,
        onConfirm: () async {
          await ref.read(adProvider.notifier).deleteAd(ad.id);
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }
}
