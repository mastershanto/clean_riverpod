import 'package:clean_riverpod/features/auth/presentation/forgot_password/forgot_password_screen.dart';
import 'package:clean_riverpod/features/auth/presentation/forgot_password/reset_password_screen.dart';
import 'package:clean_riverpod/features/auth/presentation/login/login_screen.dart';
import 'package:clean_riverpod/features/auth/presentation/otp_verify/otp_verify_screen.dart';
import 'package:clean_riverpod/features/auth/presentation/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/deshboard/deshboard.dart';
import '../features/deshboard/widgets/coming_soon_page.dart';
import 'transitions/fade_transition_mixin.dart';
import 'transitions/no_transition_mixin.dart';
import 'transitions/slide_transition_mixin.dart';

part 'app_router.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GoRouter Configuration
// ─────────────────────────────────────────────────────────────────────────────
final goRouter = GoRouter(
  initialLocation: '/auth',
  routes: $appRoutes,
);

// ─────────────────────────────────────────────────────────────────────────────
// Auth Routes
// ─────────────────────────────────────────────────────────────────────────────

// Login Screen - No Animation
@TypedGoRoute<AuthRoute>(
  path: '/auth',
  routes: [
    TypedGoRoute<SignUpRoute>(path: 'signup'),
    TypedGoRoute<OtpVerifyRoute>(path: 'signup-verify'),
    TypedGoRoute<ForgotPasswordRoute>(path: 'forgot-password'),
    TypedGoRoute<ResetPasswordRoute>(path: 'forgot-otp'),
  ],
)
class AuthRoute extends GoRouteData with $AuthRoute, NoTransitionMixin {
  const AuthRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

// Signup Screen - Slide Animation
class SignUpRoute extends GoRouteData with $SignUpRoute, SlideTransitionMixin {
  const SignUpRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const SignUpScreen();
}

// OTP Verify Screen - Slide Animation with email parameter
class OtpVerifyRoute extends GoRouteData
    with $OtpVerifyRoute, SlideTransitionMixin {
  const OtpVerifyRoute({required this.email});

  final String email;

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      OtpVerifyScreen(email: email);
}

// Forgot Password Screen - Slide Animation
class ForgotPasswordRoute extends GoRouteData
    with $ForgotPasswordRoute, SlideTransitionMixin {
  const ForgotPasswordRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const ForgotPasswordScreen();
}

// Reset Password Screen - Slide Animation with email parameter
class ResetPasswordRoute extends GoRouteData
    with $ResetPasswordRoute, SlideTransitionMixin {
  const ResetPasswordRoute({required this.email});

  final String email;

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      ResetPasswordScreen(email: email);
}

// ─────────────────────────────────────────────────────────────────────────────
// App Routes
// ─────────────────────────────────────────────────────────────────────────────

// Dashboard - No Animation
@TypedGoRoute<DashboardRoute>(
  path: '/',
  routes: [
    TypedGoRoute<AnalyticsRoute>(path: 'analytics'),
    TypedGoRoute<SettingsRoute>(path: 'settings'),
    TypedGoRoute<ProfileRoute>(path: 'profile'),
    TypedGoRoute<NotificationsRoute>(path: 'notifications'),
    TypedGoRoute<HelpRoute>(path: 'help'),
  ],
)
class DashboardRoute extends GoRouteData
    with $DashboardRoute, NoTransitionMixin {
  const DashboardRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const Dashboard();
}

// Analytics - Fade Animation
class AnalyticsRoute extends GoRouteData
    with $AnalyticsRoute, FadeTransitionMixin {
  const AnalyticsRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const ComingSoonPage(title: 'Analytics');
}

// Settings - Fade Animation
class SettingsRoute extends GoRouteData
    with $SettingsRoute, FadeTransitionMixin {
  const SettingsRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const ComingSoonPage(title: 'Settings');
}

// Profile - Fade Animation
class ProfileRoute extends GoRouteData with $ProfileRoute, FadeTransitionMixin {
  const ProfileRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const ComingSoonPage(title: 'Profile');
}

// Notifications - Fade Animation
class NotificationsRoute extends GoRouteData
    with $NotificationsRoute, FadeTransitionMixin {
  const NotificationsRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const ComingSoonPage(title: 'Notifications');
}

// Help & Support - Fade Animation
class HelpRoute extends GoRouteData with $HelpRoute, FadeTransitionMixin {
  const HelpRoute();

  @override
  Widget buildScreen(BuildContext context, GoRouterState state) =>
      const ComingSoonPage(title: 'Help & Support');
}
