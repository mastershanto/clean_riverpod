import 'package:flutter/material.dart';
import 'package:clean_riverpod/localization/app_locale.dart';

/// Get localized string from the provided locale
String translate(String key, Locale locale) {
  final isRTL = locale.languageCode == 'bn';
  final translations = isRTL ? AppLocale.bn : AppLocale.en;
  return (translations[key] ?? key).toString();
}

/// Convenience extension for building context - requires passing locale
extension AppLocalizationsExt on BuildContext {
  /// Get translation: You must pass the locale from Riverpod
  String t(String key, Locale locale) => translate(key, locale);
}
