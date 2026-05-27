import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GoldDivider extends StatelessWidget {
  const GoldDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, AppColors.accent, Colors.transparent],
        ),
      ),
    );
  }
}
