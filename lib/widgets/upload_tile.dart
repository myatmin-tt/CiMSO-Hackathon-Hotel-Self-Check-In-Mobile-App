import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class UploadTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isUploaded;
  final VoidCallback onTap;

  const UploadTile({
    super.key,
    required this.icon,
    required this.label,
    required this.isUploaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUploaded ? AppColors.success : AppColors.divider,
            width: isUploaded ? 2 : 1,
          ),
          color: isUploaded
              ? AppColors.success.withValues(alpha: 0.1)
              : AppColors.cardBg,
        ),
        child: Column(
          children: [
            Icon(
              isUploaded ? Icons.check_circle_rounded : icon,
              color: isUploaded ? AppColors.success : AppColors.accent,
              size: 36,
            ),
            const SizedBox(height: 8),
            Text(
              isUploaded ? 'Uploaded ✓' : label,
              style: TextStyle(
                color: isUploaded ? AppColors.success : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
