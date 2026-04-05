import 'dart:ui';
import 'package:coldbit_wallet/core/security/secure_enclave.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final lang = await SecureEnclave.read('coldbit_language');
    if (lang == 'es') {
      state = const Locale('es');
    } else if (lang == 'en') {
      state = const Locale('en');
    } else {
      state = null; // Use system default
    }
  }

  Future<void> setLocale(String languageCode) async {
    await SecureEnclave.write('coldbit_language', languageCode);
    state = Locale(languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});
