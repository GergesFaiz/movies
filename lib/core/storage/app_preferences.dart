import 'package:shared_preferences/shared_preferences.dart';

/// Small wrapper around [SharedPreferences] for the few flags the app keeps
/// on the device.
class AppPreferences {
  static const String _onboardingSeenKey = 'onboarding_seen';
  static const String _languageCodeKey = 'language_code';

  final SharedPreferences _prefs;

  AppPreferences(this._prefs);

  bool get isOnboardingSeen => _prefs.getBool(_onboardingSeenKey) ?? false;

  Future<void> setOnboardingSeen() => _prefs.setBool(_onboardingSeenKey, true);

  String? get languageCode => _prefs.getString(_languageCodeKey);

  Future<void> setLanguageCode(String code) =>
      _prefs.setString(_languageCodeKey, code);
}
