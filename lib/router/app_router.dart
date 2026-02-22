import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'transitions/no_transition_mixin.dart';
import '../features/crud/presentation/home_page.dart';
import '../features/ads/presentation/ads_page.dart';
import '../features/ads/presentation/ad_detail_page.dart';
import '../features/deshboard/deshboard.dart';
import '../features/deshboard/widgets/coming_soon_page.dart';

part 'app_router.g.dart';

// কোনো এনিমেশন নেই - Dashboard (রুট)
@TypedGoRoute<DashboardRoute>(path: '/')
class DashboardRoute extends GoRouteData
    with $DashboardRoute, NoTransitionMixin {
  const DashboardRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const Dashboard();
}

// কোনো এনিমেশন নেই - User CRUD
@TypedGoRoute<UserCrudRoute>(path: '/user-crud')
class UserCrudRoute extends GoRouteData with $UserCrudRoute, NoTransitionMixin {
  const UserCrudRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const HomePage(title: 'User Management');
}

// কোনো এনিমেশন নেই - Ads Marketplace
@TypedGoRoute<AdsRoute>(path: '/ads')
class AdsRoute extends GoRouteData with $AdsRoute, NoTransitionMixin {
  const AdsRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const AdsPage();
}

// কোনো এনিমেশন নেই - Ad Detail
@TypedGoRoute<AdDetailRoute>(path: '/ads/:adId')
class AdDetailRoute extends GoRouteData with $AdDetailRoute, NoTransitionMixin {
  const AdDetailRoute({required this.adId});

  final String adId;

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      AdDetailPage(adId: adId);
}

// কোনো এনিমেশন নেই - Analytics
@TypedGoRoute<AnalyticsRoute>(path: '/analytics')
class AnalyticsRoute extends GoRouteData
    with $AnalyticsRoute, NoTransitionMixin {
  const AnalyticsRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const ComingSoonPage(title: 'Analytics');
}

// কোনো এনিমেশন নেই - Settings
@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute, NoTransitionMixin {
  const SettingsRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const ComingSoonPage(title: 'Settings');
}

// কোনো এনিমেশন নেই - Profile
@TypedGoRoute<ProfileRoute>(path: '/profile')
class ProfileRoute extends GoRouteData with $ProfileRoute, NoTransitionMixin {
  const ProfileRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const ComingSoonPage(title: 'Profile');
}

// কোনো এনিমেশন নেই - Notifications
@TypedGoRoute<NotificationsRoute>(path: '/notifications')
class NotificationsRoute extends GoRouteData
    with $NotificationsRoute, NoTransitionMixin {
  const NotificationsRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const ComingSoonPage(title: 'Notifications');
}

// কোনো এনিমেশন নেই - Help
@TypedGoRoute<HelpRoute>(path: '/help')
class HelpRoute extends GoRouteData with $HelpRoute, NoTransitionMixin {
  const HelpRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const ComingSoonPage(title: 'Help & Support');
}

final goRouter = GoRouter(
  initialLocation: '/',
  routes: $appRoutes,
);
