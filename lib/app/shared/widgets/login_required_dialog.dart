import 'package:flutter/material.dart';
import '../../core/appExports/app_export.dart';

class LoginRequiredDialog extends StatelessWidget {
  const LoginRequiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            //  Icon Container
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 34,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 22),

            // Title
            Text(
              "Login Required",
              style: AppFontStyle.text_18_600(
                AppColors.primary,
                fontFamily: AppFontFamily.semiBold,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              maxLines: 6,
              "You're currently browsing as a guest. "
                  "Log in to unlock this feature and enjoy the full experience.",
              textAlign: TextAlign.center,
              style: AppFontStyle.text_14_400(
                AppColors.grey,
              ),
            ),

            const SizedBox(height: 28),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: AppFontStyle.text_14_500(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Login Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      "Login",
                      style: AppFontStyle.text_14_600(
                        AppColors.white,
                        fontFamily: AppFontFamily.semiBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}