import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/router/app_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/storage/app_preferences.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/custom_elevatedbutton.dart';
import '../../../../core/widgets/onboarding_bottomsheet.dart';
import '../../../../core/widgets/onboarding_data.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await sl<AppPreferences>().setOnboardingSeen();
    if (!mounted) return;
    final isLoggedIn = sl<FirebaseAuth>().currentUser != null;
    Navigator.pushReplacementNamed(
      context,
      isLoggedIn ? AppRoutes.homeScreen : AppRoutes.loginScreen,
    );
  }

  void _navigate(String direction, int pageCount) {
    if (direction == 'next') {
      if (_currentPage == pageCount - 1) {
        _finish();
      } else {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = onboardingPages(AppLocalizations.of(context)!);

    return PageView.builder(
      controller: _pageController,
      itemCount: pages.length,
      onPageChanged: (index) => setState(() => _currentPage = index),
      itemBuilder: (context, index) {
        final data = pages[index];
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(data.image, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      data.gradientColor.withValues(alpha: 0.6),
                      data.gradientColor,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
              index == 0
                  ? _buildFirstPage(data, pages.length)
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: OnboardingBottomsheet(
                        bottomSheetTitle: data.title,
                        bottomSheetDiscribtion: data.description,
                        buttonText: data.buttonText,
                        isFirstPage: index == 1,
                        navigatornext: () => _navigate('next', pages.length),
                        navigatorback: () => _navigate('back', pages.length),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFirstPage(OnboardingData data, int pageCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 2),
          Text(
            data.title,
            style: AppStyles.medium36white,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            style: AppStyles.bold20White,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CustomElevatedButton(
            label: data.buttonText,
            textStyle: AppStyles.bold20black,
            onPressed: () => _navigate('next', pageCount),
          ),
        ],
      ),
    );
  }
}
