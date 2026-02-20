import 'package:clean_riverpod/features/crud/providers/theme_provider.dart';
import 'package:clean_riverpod/providers/locale_provider.dart';
import 'package:clean_riverpod/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Clean Riverpod',
          debugShowCheckedModeBanner: false,
          routerConfig: goRouter,

          // ── Localization ──────────────────────────────────────────────
          locale: locale,
          supportedLocales: const [
            Locale('en'),
            Locale('bn'),
          ],
          // ─────────────────────────────────────────────────────────────

          themeMode: themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
