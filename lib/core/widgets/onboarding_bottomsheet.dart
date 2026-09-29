import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import 'custom_elevatedbutton.dart';

class OnboardingBottomsheet extends StatelessWidget {
  final String bottomSheetTitle;
  final String bottomSheetDiscribtion;
  final String buttonText;
  final VoidCallback navigatornext;
  final VoidCallback navigatorback;
  final bool isFirstPage;

  const OnboardingBottomsheet({
    super.key,
    required this.bottomSheetTitle,
    required this.bottomSheetDiscribtion,
    required this.buttonText,
    this.isFirstPage = false,
    required this.navigatornext,
    required this.navigatorback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.blackColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            bottomSheetTitle,
            style: AppStyles.bold24White,
            textAlign: TextAlign.center,
          ),
          if (bottomSheetDiscribtion.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              bottomSheetDiscribtion,
              style: AppStyles.bold20White,
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 10),
          // The page decides what "next" means (next page or finish).
          CustomElevatedButton(
            label: buttonText,
            textStyle: AppStyles.bold20black,
            onPressed: navigatornext,
          ),
          if (!isFirstPage) ...[
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: AppColors.amber),
                ),
              ),
              onPressed: navigatorback,
              child: Text(
                AppLocalizations.of(context)!.back,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
