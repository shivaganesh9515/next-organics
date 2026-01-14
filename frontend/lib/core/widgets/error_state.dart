import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Reusable error state widget with retry functionality.
///
/// Use this for displaying API errors, network failures, etc.
class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'Please try again later',
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  /// Factory for network errors
  factory ErrorState.network({VoidCallback? onRetry}) => ErrorState(
        title: 'No Connection',
        message: 'Please check your internet and try again',
        icon: Icons.wifi_off,
        onRetry: onRetry,
      );

  /// Factory for server errors
  factory ErrorState.server({VoidCallback? onRetry}) => ErrorState(
        title: 'Server Error',
        message: 'Our servers are having issues. Please try again.',
        icon: Icons.cloud_off,
        onRetry: onRetry,
      );

  /// Factory for empty search results
  factory ErrorState.noResults({String query = ''}) => ErrorState(
        title: 'No Results Found',
        message: query.isNotEmpty
            ? 'No products found for "$query"'
            : 'No products available',
        icon: Icons.search_off,
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
