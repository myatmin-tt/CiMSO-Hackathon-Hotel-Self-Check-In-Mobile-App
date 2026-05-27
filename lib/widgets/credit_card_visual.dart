import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CreditCardVisual extends StatelessWidget {
  final String holderName;
  final String number;
  final String expiry;

  const CreditCardVisual({
    super.key,
    required this.holderName,
    required this.number,
    required this.expiry,
  });

  @override
  Widget build(BuildContext context) {
    final displayNumber = number.isEmpty
        ? '**** **** **** ****'
        : number
            .replaceAll(' ', '')
            .padRight(16, '*')
            .replaceAllMapped(RegExp(r'.{4}'), (m) => '${m.group(0)} ')
            .trim();

    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C3E6B), Color(0xFF1A1A2E), Color(0xFF3D2B1F)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'LUXE STAY',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 13,
                ),
              ),
              Icon(Icons.wifi_rounded, color: AppColors.textSecondary, size: 20),
            ],
          ),
          const Spacer(),
          Text(
            displayNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 3,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARD HOLDER',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                        letterSpacing: 1.5),
                  ),
                  Text(
                    holderName.isEmpty
                        ? 'YOUR NAME'
                        : holderName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXPIRES',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                        letterSpacing: 1.5),
                  ),
                  Text(
                    expiry.isEmpty ? 'MM/YY' : expiry,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
