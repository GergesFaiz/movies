import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movies/core/router/app_router.dart';

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

  Future<void> _onFinish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }

  void _navigate(String direction) {
    if (direction == 'next') {
      if (_currentPage == onboardingPages.length - 1) {
        _onFinish();
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
    return PageView.builder(
      controller: _pageController,
      itemCount: onboardingPages.length,
      onPageChanged: (index) => setState(() => _currentPage = index),
      itemBuilder: (context, index) {
        final data = onboardingPages[index];
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
                  ? _buildFirstPage(data)
                  : Align(
                      alignment: AlignmentGeometry.bottomCenter,
                      child: OnboardingBottomsheet(
                        bottomSheetTitle: data.title,
                        bottomSheetDiscribtion: data.description,
                        buttonText: data.buttonText,
                        isFirstPage: index == 1,
                        navigatornext: () => _navigate('next'),
                        navigatorback: () => _navigate('back'),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFirstPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 2),
          Text(data.title,
              style: AppStyles.medium36white,
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Text(data.description,
              style: AppStyles.bold20White,
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          CustomElevatedButton(
            label: data.buttonText,
            textStyle: AppStyles.bold20black,
            onPressed: () => _navigate('next'),
          ),
        ],
      ),
    );
  }
}
