import 'package:clean_riverpod/features/crud/providers/theme_provider.dart';
import 'package:clean_riverpod/features/deshboard/widgets/feature_card.dart';
import 'package:clean_riverpod/localization/app_locale.dart';
import 'package:clean_riverpod/localization/app_localization_ext.dart';
import 'package:clean_riverpod/providers/locale_provider.dart';
import 'package:clean_riverpod/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ watch the state directly — rebuilds reactively when toggled
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final isBangla = locale.languageCode == 'bn';

    // Helper function to translate
    String tr(String key) => translate(key, locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(AppLocale.dashboardTitle),
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        elevation: 0,
        actions: [
          // ── Language Toggle ───────────────────────────────────────────
          Tooltip(
            message: isBangla
                ? tr(AppLocale.switchToEnglish)
                : tr(AppLocale.switchToBangla),
            child: GestureDetector(
              onTap: () => ref.read(localeProvider.notifier).toggleLocale(),
              child: Container(
                margin: EdgeInsets.only(right: 6.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  isBangla ? 'EN' : 'বাং',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          // ── Theme Toggle ──────────────────────────────────────────────
          IconButton(
            tooltip: isDark
                ? tr(AppLocale.switchToLightMode)
                : tr(AppLocale.switchToDarkMode),
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(AppLocale.welcomeBack),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    tr(AppLocale.selectFeature),
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Features Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.65,
              children: [
                // User Management Card
                FeatureCard(
                  title: tr(AppLocale.userCrud),
                  description: tr(AppLocale.userCrudDesc),
                  icon: Icons.people_outline,
                  color: const Color(0xFF7C3AED),
                  onTap: () => const UserCrudRoute().push(context),
                ),

                // Marketplace / Ads Card
                FeatureCard(
                  title: tr(AppLocale.marketplace),
                  description: tr(AppLocale.marketplaceDesc),
                  icon: Icons.campaign_outlined,
                  color: const Color(0xFFE11D48),
                  onTap: () => const AdsRoute().push(context),
                ),

                // Analytics Card
                FeatureCard(
                  title: tr(AppLocale.analytics),
                  description: tr(AppLocale.analyticsDesc),
                  icon: Icons.analytics_outlined,
                  color: const Color(0xFF0EA5E9),
                  onTap: () => const AnalyticsRoute().push(context),
                ),

                // Settings Card
                FeatureCard(
                  title: tr(AppLocale.settings),
                  description: tr(AppLocale.settingsDesc),
                  icon: Icons.settings_outlined,
                  color: const Color(0xFF10B981),
                  onTap: () => const SettingsRoute().push(context),
                ),

                // Profile Card
                FeatureCard(
                  title: tr(AppLocale.profile),
                  description: tr(AppLocale.profileDesc),
                  icon: Icons.account_circle_outlined,
                  color: const Color(0xFFF59E0B),
                  onTap: () => const ProfileRoute().push(context),
                ),

                // Notifications Card
                FeatureCard(
                  title: tr(AppLocale.notifications),
                  description: tr(AppLocale.notificationsDesc),
                  icon: Icons.notifications_outlined,
                  color: const Color(0xFFEC4899),
                  onTap: () => const NotificationsRoute().push(context),
                ),

                // Help Card
                FeatureCard(
                  title: tr(AppLocale.helpSupport),
                  description: tr(AppLocale.helpSupportDesc),
                  icon: Icons.help_outline,
                  color: const Color(0xFF8B5CF6),
                  onTap: () => const HelpRoute().push(context),
                ),
              ],
            ),

            // Footer info
            Padding(
              padding: EdgeInsets.only(top: 32.h),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.grey.withValues(alpha: 0.1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outlined, color: Colors.grey, size: 20.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        tr(AppLocale.moreFeaturesSoon),
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
