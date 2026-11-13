// lib/widgets/common_loader.dart (Example file path)
import 'package:flutter/material.dart';
import '../utils/global_colors.dart';

// --- CibilLoader Class Definition ---
/// A custom, elevated, branded loader that displays an image asset
/// (e.g., 'assets/logo.png') inside a CircularProgressIndicator.
class CibilLoader extends StatelessWidget {
  final String message;
  final Color indicatorColor;
  final Color backgroundColor;

  const CibilLoader({
    super.key,
    required this.message,
    this.indicatorColor = AppColors.primaryColor,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fixed width provides a stable size for the dialog content
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        // Adding BoxShadow for the elevated look
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Crucial to size the dialog to its content
        children: [
          _LogoCircularLoader(indicatorColor: indicatorColor),
          const SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper Widget to display the logo within the spinning circle.
class _LogoCircularLoader extends StatelessWidget {
  final Color indicatorColor;
  const _LogoCircularLoader({required this.indicatorColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. The Rotating Circular Progress Indicator
          SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
              backgroundColor: indicatorColor.withOpacity(0.2),
            ),
          ),
          // 2. The Logo Image Container
          Container(
            width: 45,
            height: 45,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              // Error builder for asset loading failure (ensure 'assets/logo.png' is in pubspec.yaml)
              errorBuilder: (context, error, stackTrace) {
                // Returns a simple icon if the asset is not found (prevents StackOverflow)
                return const Icon(
                  Icons.report_problem,
                  color: Colors.red,
                  size: 30,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
// --- End of CibilLoader Class Definition ---

// --- Reusable Utility Function ---
/// A utility class to easily show and hide the custom CibilLoader dialog.
class LoaderUtils {
  /// Displays the custom loader dialog with a black shaded background.
  /// Use this method to show the loader in a single line: `await LoaderUtils.show(context, message: 'Loading...');`
  static Future<void> show(
    BuildContext context, {
    required String message,
    Color indicatorColor = AppColors.primaryColor, // Default indicator color
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: CibilLoader(
              message: message,
              indicatorColor: indicatorColor,
              backgroundColor: Colors.white,
            ),
          ),
        );
      },
    );
  }

  /// Hides the currently displayed loader dialog.
  /// Use this method to hide the loader: `LoaderUtils.hide(context);`
  static void hide(BuildContext context) {
    // Only pop if the current route is the dialog
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
