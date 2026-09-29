import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies/core/l10n/app_localizations.dart';
import 'package:movies/core/utils/app_validator.dart';

void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  final ar = lookupAppLocalizations(const Locale('ar'));

  group('AppValidator', () {
    test('validateEmail', () {
      expect(AppValidator.validateEmail('', en), en.emailRequired);
      expect(AppValidator.validateEmail('not-an-email', en), en.invalidEmail);
      expect(AppValidator.validateEmail('name@example.com', en), isNull);
      expect(
        AppValidator.validateEmail('first.last+tag@mail.online', en),
        isNull,
      );
    });

    test('validatePassword requires upper, lower, digit and 8 chars', () {
      expect(AppValidator.validatePassword('', en), en.passwordRequired);
      expect(AppValidator.validatePassword('abc12345', en), en.weakPassword);
      expect(AppValidator.validatePassword('Abc12345', en), isNull);
    });

    test('validateConfirmPassword', () {
      expect(
        AppValidator.validateConfirmPassword('', 'Abc12345', en),
        en.confirmPasswordRequired,
      );
      expect(
        AppValidator.validateConfirmPassword('Abc1234', 'Abc12345', en),
        en.passwordsDoNotMatch,
      );
      expect(
        AppValidator.validateConfirmPassword('Abc12345', 'Abc12345', en),
        isNull,
      );
    });

    test('validatePhone accepts Egyptian mobile numbers', () {
      expect(AppValidator.validatePhone('', en), en.phoneRequired);
      expect(AppValidator.validatePhone('0101234567', en), en.invalidPhone);
      expect(AppValidator.validatePhone('01012345678', en), isNull);
    });

    test('validateName accepts English and Arabic names', () {
      expect(AppValidator.validateName('', en), en.nameRequired);
      expect(AppValidator.validateName('Jo', en), en.invalidName);
      expect(AppValidator.validateName('John Safwat', en), isNull);
      expect(AppValidator.validateName('جرجس فايز', en), isNull);
    });

    test('messages follow the selected language', () {
      expect(AppValidator.validateEmail('', ar), ar.emailRequired);
      expect(ar.emailRequired, isNot(en.emailRequired));
    });
  });
}
