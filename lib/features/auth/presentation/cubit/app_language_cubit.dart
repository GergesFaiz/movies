import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/app_preferences.dart';

class AppLanguageCubit extends Cubit<Locale> {
  final AppPreferences _preferences;

  AppLanguageCubit(this._preferences)
    : super(Locale(_preferences.languageCode ?? 'en'));

  void changeLanguage(String langCode) {
    if (state.languageCode == langCode) return;
    _preferences.setLanguageCode(langCode);
    emit(Locale(langCode));
  }
}
