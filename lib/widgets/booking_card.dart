import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../theme/app_colors.dart';
import '../widgets/gold_divider.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;
  final VoidCallback onCheckIn;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Hotel image with overlay
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/resort.jpg',
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: AppColors.surface,
                      child: const Center(
                        child: Icon(Icons.hotel,
                            color: AppColors.accent, size: 40),
                      ),
                    ),
                  ),
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                  ),
                  if (booking.isCheckedIn)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'CHECKED IN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 12,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.hotelName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: AppColors.accent, size: 13),
                            const SizedBox(width: 3),
                            Text(
                              booking.location,
                              style: const TextStyle(
                                  color: AppColors.textSecondary, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Card details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _DatePill(
                        label: 'CHECK-IN',
                        date: booking.checkIn,
                        icon: Icons.login_rounded,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: const Icon(Icons.arrow_forward_rounded,
                            color: AppColors.textSecondary, size: 16),
                      ),
                      _DatePill(
                        label: 'CHECK-OUT',
                        date: booking.checkOut,
                        icon: Icons.logout_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const GoldDivider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.roomType,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${booking.pricePerNight.toStringAsFixed(0)}/night · ${booking.nights} nights',
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                      if (!booking.isCheckedIn)
                        ElevatedButton(
                          onPressed: onCheckIn,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            minimumSize: Size.zero,
                          ),
                          child: const Text(
                            'CHECK IN',
                            style:
                                TextStyle(fontSize: 11, letterSpacing: 1),
                          ),
                        )
                      else
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.success, size: 28),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Date Pill ────────────────────────────────────────────────────────────────

class _DatePill extends StatelessWidget {
  final String label;
  final String date;
  final IconData icon;

  const _DatePill(
      {required this.label, required this.date, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 9,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Icon(icon, color: AppColors.accent, size: 12),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    date,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
