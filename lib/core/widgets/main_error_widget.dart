import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';

class MainErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onPressed;

  const MainErrorWidget({
    super.key,
    required this.message,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.amber),
              child: Text(
                AppLocalizations.of(context)!.tryAgain,
                style: const TextStyle(color: AppColors.blackColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
