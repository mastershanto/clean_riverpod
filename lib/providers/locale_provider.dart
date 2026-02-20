import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));

  /// Toggle between English and Bangla
  void toggleLocale() {
    final newCode = isBangla ? 'en' : 'bn';
    state = Locale(newCode);
  }

  /// Explicitly set a locale
  void setLocale(Locale locale) {
    state = locale;
  }

  bool get isBangla => state.languageCode == 'bn';
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);
