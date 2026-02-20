// Convenience extension — use context.t(AppLocale.someKey)
// instead of the longer context.formatString(AppLocale.someKey, [])
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

extension AppLocalizationsExt on BuildContext {
  /// Shorthand: context.t(AppLocale.dashboardTitle)
  String t(String key) => formatString(key, []);
}
