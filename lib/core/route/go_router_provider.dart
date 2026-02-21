import 'package:clean_riverpod/core/route/route_name.dart';
import 'package:clean_riverpod/features/auth/login/presentation/ui/login_screen.dart';
import 'package:clean_riverpod/features/auth/signup/presentation/ui/singup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouteProvider = Provider<GoRouter>((ref) {
  return GoRouter(initialLocation: '/home', routes: [
    GoRoute(
      path: '/login',
      name: loginRoute,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: signupRoute,
      builder: (context, state) => const SingupScreen(),
    )
  ]);
});
