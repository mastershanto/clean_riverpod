import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));

  /// Toggle between English and Bangla
  void toggleLocale() {
    final newCode = isBangla ? 'en' : 'bn';
    // Notify flutter_localization so context.formatString() returns new strings
    FlutterLocalization.instance.translate(newCode);
    state = Locale(newCode);
  }

  /// Explicitly set a locale
  void setLocale(Locale locale) {
    FlutterLocalization.instance.translate(locale.languageCode);
    state = locale;
  }

  bool get isBangla => state.languageCode == 'bn';
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);
