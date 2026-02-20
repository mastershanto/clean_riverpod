import 'package:clean_riverpod/localization/app_locale.dart';
import 'package:clean_riverpod/localization/app_localization_ext.dart';
import 'package:clean_riverpod/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ComingSoonPage extends ConsumerWidget {
  const ComingSoonPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    // Helper function to translate
    String tr(String key) => translate(key, locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.work_outline, size: 80.sp, color: Colors.grey),
              SizedBox(height: 24.h),
              Text(
                '$title ${tr(AppLocale.comingSoon)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                tr(AppLocale.comingSoonDesc),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
              SizedBox(height: 40.h),
              FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home),
                label: Text(tr(AppLocale.backToDashboard),
                    style: TextStyle(fontSize: 14.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
