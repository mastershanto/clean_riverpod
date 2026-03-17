import 'package:go_router/go_router.dart';
import '../features/crud/presentation/home_page.dart';
import '../features/ads/presentation/ads_page.dart';
import '../features/ads/presentation/ad_detail_page.dart';
import '../features/deshboard/deshboard.dart';
import '../features/deshboard/widgets/coming_soon_page.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Dashboard(),
    ),
    GoRoute(
      path: '/user-crud',
      builder: (context, state) => const HomePage(title: 'User Management'),
    ),
    GoRoute(
      path: '/ads',
      builder: (context, state) => const AdsPage(),
    ),
    GoRoute(
      path: '/ads/:adId',
      builder: (context, state) {
        final adId = state.pathParameters['adId'] ?? '';
        return AdDetailPage(adId: adId);
      },
    ),
    GoRoute(
      path: '/analytics',
      builder: (context, state) => const ComingSoonPage(title: 'Analytics'),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const ComingSoonPage(title: 'Settings'),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ComingSoonPage(title: 'Profile'),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const ComingSoonPage(title: 'Notifications'),
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) =>
          const ComingSoonPage(title: 'Help & Support'),
    ),
  ],
);
