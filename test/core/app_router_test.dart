import 'package:flutter_test/flutter_test.dart';
import 'package:movies/core/router/app_router.dart';

void main() {
  group('AppRouter.initialRoute', () {
    test('shows onboarding on the first launch', () {
      expect(
        AppRouter.initialRoute(onboardingSeen: false, isLoggedIn: false),
        AppRoutes.onBoarding,
      );
    });

    test('asks to log in after onboarding', () {
      expect(
        AppRouter.initialRoute(onboardingSeen: true, isLoggedIn: false),
        AppRoutes.loginScreen,
      );
    });

    test('opens home for a signed-in user', () {
      expect(
        AppRouter.initialRoute(onboardingSeen: true, isLoggedIn: true),
        AppRoutes.homeScreen,
      );
    });
  });
}
