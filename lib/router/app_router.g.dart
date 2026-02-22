// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $dashboardRoute,
      $userCrudRoute,
      $adsRoute,
      $adDetailRoute,
      $analyticsRoute,
      $settingsRoute,
      $profileRoute,
      $notificationsRoute,
      $helpRoute,
    ];

// ── DashboardRoute ────────────────────────────────────────────────────────

RouteBase get $dashboardRoute => GoRouteData.$route(
      path: '/',
      factory: $DashboardRoute._fromState,
    );

mixin $DashboardRoute on GoRouteData {
  static DashboardRoute _fromState(GoRouterState state) =>
      const DashboardRoute();

  String get _location => GoRouteData.$location('/');

  void go(BuildContext context) => context.go(_location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(_location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(_location);

  void replace(BuildContext context) => context.replace(_location);
}

// ── UserCrudRoute ─────────────────────────────────────────────────────────

RouteBase get $userCrudRoute => GoRouteData.$route(
      path: '/user-crud',
      factory: $UserCrudRoute._fromState,
    );

mixin $UserCrudRoute on GoRouteData {
  static UserCrudRoute _fromState(GoRouterState state) => const UserCrudRoute();

  String get _location => GoRouteData.$location('/user-crud');

  void go(BuildContext context) => context.go(_location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(_location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(_location);

  void replace(BuildContext context) => context.replace(_location);
}

// ── AdsRoute ──────────────────────────────────────────────────────────────

RouteBase get $adsRoute => GoRouteData.$route(
      path: '/ads',
      factory: $AdsRoute._fromState,
    );

mixin $AdsRoute on GoRouteData {
  static AdsRoute _fromState(GoRouterState state) => const AdsRoute();

  String get _location => GoRouteData.$location('/ads');

  void go(BuildContext context) => context.go(_location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(_location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(_location);

  void replace(BuildContext context) => context.replace(_location);
}

// ── AdDetailRoute ─────────────────────────────────────────────────────────

RouteBase get $adDetailRoute => GoRouteData.$route(
      path: '/ads/:adId',
      factory: $AdDetailRoute._fromState,
    );

mixin $AdDetailRoute on GoRouteData {
  static AdDetailRoute _fromState(GoRouterState state) =>
      AdDetailRoute(adId: state.pathParameters['adId']!);

  String get _location =>
      GoRouteData.$location('/ads/${Uri.encodeComponent(adId)}');

  abstract final String adId;

  void go(BuildContext context) => context.go(_location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(_location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(_location);

  void replace(BuildContext context) => context.replace(_location);
}

// ── AnalyticsRoute ────────────────────────────────────────────────────────

RouteBase get $analyticsRoute => GoRouteData.$route(
      path: '/analytics',
      factory: $AnalyticsRoute._fromState,
    );

mixin $AnalyticsRoute on GoRouteData {
  static AnalyticsRoute _fromState(GoRouterState state) =>
      const AnalyticsRoute();

  String get _location => GoRouteData.$location('/analytics');

  void go(BuildContext context) => context.go(_location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(_location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(_location);

  void replace(BuildContext context) => context.replace(_location);
}

// ── SettingsRoute ─────────────────────────────────────────────────────────

RouteBase get $settingsRoute => GoRouteData.$route(
      path: '/settings',
      factory: $SettingsRoute._fromState,
    );

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  String get _location => GoRouteData.$location('/settings');

  void go(BuildContext context) => context.go(_location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(_location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(_location);

  void replace(BuildContext context) => context.replace(_location);
}

// ── ProfileRoute ──────────────────────────────────────────────────────────

RouteBase get $profileRoute => GoRouteData.$route(
      path: '/profile',
      factory: $ProfileRoute._fromState,
    );

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  String get _location => GoRouteData.$location('/profile');

  void go(BuildContext context) => context.go(_location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(_location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(_location);

  void replace(BuildContext context) => context.replace(_location);
}

// ── NotificationsRoute ────────────────────────────────────────────────────

RouteBase get $notificationsRoute => GoRouteData.$route(
      path: '/notifications',
      factory: $NotificationsRoute._fromState,
    );

mixin $NotificationsRoute on GoRouteData {
  static NotificationsRoute _fromState(GoRouterState state) =>
      const NotificationsRoute();

  String get _location => GoRouteData.$location('/notifications');

  void go(BuildContext context) => context.go(_location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(_location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(_location);

  void replace(BuildContext context) => context.replace(_location);
}

// ── HelpRoute ─────────────────────────────────────────────────────────────

RouteBase get $helpRoute => GoRouteData.$route(
      path: '/help',
      factory: $HelpRoute._fromState,
    );

mixin $HelpRoute on GoRouteData {
  static HelpRoute _fromState(GoRouterState state) => const HelpRoute();

  String get _location => GoRouteData.$location('/help');

  void go(BuildContext context) => context.go(_location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(_location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(_location);

  void replace(BuildContext context) => context.replace(_location);
}
