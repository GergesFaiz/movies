import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';

class OnboardingData {
  final String image;
  final String title;
  final String description;
  final String buttonText;
  final Color gradientColor;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.gradientColor,
  });
}

List<OnboardingData> onboardingPages(AppLocalizations l10n) => [
  OnboardingData(
    image: AppOnboardingImage.onbaordingImage1,
    title: l10n.onboardingTitle1,
    description: l10n.onboardingDescription1,
    buttonText: l10n.exploreNow,
    gradientColor: AppColors.blackColor,
  ),
  OnboardingData(
    image: AppOnboardingImage.onbaordingImage2,
    title: l10n.onboardingTitle2,
    description: l10n.onboardingDescription2,
    buttonText: l10n.next,
    gradientColor: const Color(0XFF084250),
  ),
  OnboardingData(
    image: AppOnboardingImage.onbaordingImage3,
    title: l10n.onboardingTitle3,
    description: l10n.onboardingDescription3,
    buttonText: l10n.next,
    gradientColor: const Color(0XFF85210E),
  ),
  OnboardingData(
    image: AppOnboardingImage.onbaordingImage4,
    title: l10n.onboardingTitle4,
    description: l10n.onboardingDescription4,
    buttonText: l10n.next,
    gradientColor: const Color(0XFF4C2471),
  ),
  OnboardingData(
    image: AppOnboardingImage.onbaordingImage5,
    title: l10n.onboardingTitle5,
    description: l10n.onboardingDescription5,
    buttonText: l10n.next,
    gradientColor: const Color(0XFF601321),
  ),
  OnboardingData(
    image: AppOnboardingImage.onbaordingImage6,
    title: l10n.onboardingTitle6,
    description: '',
    buttonText: l10n.finish,
    gradientColor: const Color(0XFF2A2C30),
  ),
];
