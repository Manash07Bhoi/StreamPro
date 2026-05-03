import '../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool showRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.showRetry = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/error_state.json',
              height: 150,
              repeat: false,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error_outline_rounded, size: 64, color: AppColors.colorError),
            ),
            const SizedBox(height: 24),
            const Text(
              'Something Went Wrong',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.colorTextSecondary),
            ),
            if (showRetry) ...[
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.colorPrimary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Try Again', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
