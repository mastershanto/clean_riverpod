import 'package:clean_riverpod/features/auth/presentations/forgot_password/forgot_password_screen.dart';
import 'package:clean_riverpod/features/auth/presentations/forgot_password/reset_password_screen.dart';
import 'package:clean_riverpod/features/auth/presentations/login/presentation/ui/login_screen.dart';
import 'package:clean_riverpod/features/auth/presentations/otp_verify/otp_verify_screen.dart';
import 'package:clean_riverpod/features/auth/presentations/signup/presentation/ui/singup_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/deshboard/deshboard.dart';
import '../features/deshboard/widgets/coming_soon_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helper: no-animation page builder
// ─────────────────────────────────────────────────────────────────────────────
Page<void> _noTransition(BuildContext _, GoRouterState state, Widget child) =>
    NoTransitionPage(key: state.pageKey, child: child);

// ─────────────────────────────────────────────────────────────────────────────
// Router
// ─────────────────────────────────────────────────────────────────────────────
final goRouter = GoRouter(
  initialLocation: '/auth',
  routes: [
    // ── Auth ─────────────────────────────────────────────────────────────────
    GoRoute(
      path: '/auth',
      pageBuilder: (ctx, s) => _noTransition(ctx, s, const LoginScreen()),
    ),
    GoRoute(
      path: '/auth/signup',
      pageBuilder: (ctx, s) => _noTransition(ctx, s, const SignUpScreen()),
    ),
    GoRoute(
      path: '/auth/signup-verify',
      pageBuilder: (ctx, s) {
        final email = s.uri.queryParameters['email'] ?? '';
        return _noTransition(ctx, s, OtpVerifyScreen(email: email));
      },
    ),
    GoRoute(
      path: '/auth/forgot-password',
      pageBuilder: (ctx, s) =>
          _noTransition(ctx, s, const ForgotPasswordScreen()),
    ),
    GoRoute(
      path: '/auth/forgot-otp',
      pageBuilder: (ctx, s) {
        final email = s.uri.queryParameters['email'] ?? '';
        return _noTransition(ctx, s, ResetPasswordScreen(email: email));
      },
    ),

    // ── App ──────────────────────────────────────────────────────────────────
    GoRoute(
      path: '/',
      pageBuilder: (ctx, s) => _noTransition(ctx, s, const Dashboard()),
    ),
 
    GoRoute(
      path: '/analytics',
      pageBuilder: (ctx, s) =>
          _noTransition(ctx, s, const ComingSoonPage(title: 'Analytics')),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (ctx, s) =>
          _noTransition(ctx, s, const ComingSoonPage(title: 'Settings')),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (ctx, s) =>
          _noTransition(ctx, s, const ComingSoonPage(title: 'Profile')),
    ),
    GoRoute(
      path: '/notifications',
      pageBuilder: (ctx, s) =>
          _noTransition(ctx, s, const ComingSoonPage(title: 'Notifications')),
    ),
    GoRoute(
      path: '/help',
      pageBuilder: (ctx, s) =>
          _noTransition(ctx, s, const ComingSoonPage(title: 'Help & Support')),
    ),
  ],
);
