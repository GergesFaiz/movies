import '../l10n/app_localizations.dart';

class AppValidator {
  // Validate Full Name
  static String? validateName(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.nameRequired;
    }
    // Accepts letters (English/Arabic) and spaces, minimum 3 characters
    final nameRegExp = RegExp(r"^[\p{L} ,.'-]{3,}$", unicode: true);
    if (!nameRegExp.hasMatch(value.trim())) {
      return l10n.invalidName;
    }
    return null;
  }

  // Validate Email
  static String? validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.emailRequired;
    }
    final emailRegExp = RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return l10n.invalidEmail;
    }
    return null;
  }

  // Validate Phone Number (Egypt Format: 010, 011, 012, 015 + 8 digits)
  static String? validatePhone(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.phoneRequired;
    }
    final phoneRegExp = RegExp(r'^01[0125][0-9]{8}$');
    if (!phoneRegExp.hasMatch(value.trim())) {
      return l10n.invalidPhone;
    }
    return null;
  }

  // Validate Password Strength
  static String? validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    // Requirements: 1 Uppercase, 1 Lowercase, 1 Number, Min 8 characters
    final passRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    if (!passRegExp.hasMatch(value)) {
      return l10n.weakPassword;
    }
    return null;
  }

  // Validate Confirm Password
  static String? validateConfirmPassword(
    String? value,
    String password,
    AppLocalizations l10n,
  ) {
    if (value == null || value.isEmpty) {
      return l10n.confirmPasswordRequired;
    }
    if (value != password) {
      return l10n.passwordsDoNotMatch;
    }
    return null;
  }
}
