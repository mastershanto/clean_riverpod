import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin NoTransitionMixin on GoRouteData {
  Widget buildScreen(BuildContext context, GoRouterState state);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: buildScreen(context, state),
    );
  }
}
