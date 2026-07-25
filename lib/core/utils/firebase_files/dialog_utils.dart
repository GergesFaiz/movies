import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_styles.dart';

class DialogUtils {
  static void showLoading(BuildContext context, {String? s}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(
            backgroundColor: AppColors.gray,
            content: Row(
              children: [
                const CircularProgressIndicator(color: AppColors.amber),
                const SizedBox(width: 20),
                Text(s ?? "Loading...", style: AppStyles.bold16White),
              ],
            ),
          ),
    );
  }
  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }
  static void showMessage(BuildContext context, String message, {String? title, String? posActionName, VoidCallback? posAction}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? 'Notice'),
          content: Text(message),
          actions: [
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