import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguageCubit extends Cubit<Locale> {
  final SharedPreferences _prefs;

  AppLanguageCubit(this._prefs) : super(Locale(_prefs.getString('lang') ?? 'en'));

  void changeLanguage(String langCode) {
    if (state.languageCode == langCode) return;
    _prefs.setString('lang', langCode);
    emit(Locale(langCode));
  }
}
