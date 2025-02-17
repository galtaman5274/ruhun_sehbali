import 'package:flutter/material.dart';

import '../../storage_controller/storage_controller.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  final StorageController _secureStorage = StorageController();

  Locale get locale => _locale;
  void init() async {
    final Locale _locale;
    final locale = await _secureStorage.getValue('locale');
    switch (locale) {
      case 'en':
        _locale = Locale('en');
      case 'ar':
        _locale = Locale('ar');
      case 'de':
        _locale = Locale('de');
      case 'tr':
        _locale = Locale('tr');
      default:
        _locale = Locale('tr');
    }
    setLocale(_locale);
  }

  void setLocale(Locale locale) async {
    await _secureStorage.saveValue('locale', locale.languageCode);
    _locale = locale;
    notifyListeners();
  }
}
