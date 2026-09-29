import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_styles.dart';

class DialogUtils {
  static void showLoading(BuildContext context, {String? s}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.gray,
        content: Row(
          children: [
            const CircularProgressIndicator(color: AppColors.amber),
            const SizedBox(width: 20),
            Flexible(
              child: Text(s ?? "Loading...", style: AppStyles.bold16White),
            ),
          ],
        ),
      ),
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(
    BuildContext context,
    String message, {
    String? title,
    String? posActionName,
    VoidCallback? posAction,
    String? negActionName,
    VoidCallback? negAction,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? 'Notice'),
          content: Text(message),
          actions: [
            if (negActionName != null)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  negAction?.call();
                },
                child: Text(negActionName),
              ),
            if (posActionName != null)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  posAction?.call();
                },
                child: Text(posActionName),
              ),
          ],
        );
      },
    );
  }
}
