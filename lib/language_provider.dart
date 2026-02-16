import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  dutch('nl'),
  english('en');

  final String code;
  const AppLanguage(this.code);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (l) => l.code == code,
      orElse: () => AppLanguage.dutch,
    );
  }
}

class LanguageProvider extends ValueNotifier<AppLanguage> {
  static final LanguageProvider _instance = LanguageProvider._internal();
  factory LanguageProvider() => _instance;

  static const String _languageKey = 'app_language';

  LanguageProvider._internal() : super(AppLanguage.dutch) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_languageKey);
    if (code != null) {
      value = AppLanguage.fromCode(code);
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    value = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.code);
  }
}
