import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/gold_divider.dart';
import '../screens/check_in_screen.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String bookingId;
  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final booking = state.getBookingById(bookingId);

    if (booking == null) {
      return const Scaffold(
        body: Center(child: Text('Booking not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: CustomScrollView(
        slivers: [
          // Hero image app bar
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.secondary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/resort.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.hotel,
                          color: AppColors.accent, size: 60),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.hotelName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: AppColors.accent, size: 15),
                            const SizedBox(width: 4),
                            Text(
                              booking.location,
                              style: const TextStyle(
                                  color: AppColors.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Confirmation code
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.confirmation_number_outlined,
                            color: AppColors.accent, size: 20),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Confirmation Code',
                                style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11)),
                            Text(
                              booking.confirmationCode,
                              style: const TextStyle(
                                color: AppColors.accent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stay Details
                  const _SectionLabel('Stay Details'),
                  Row(
                    children: [
                      Expanded(
                        child: _DetailBlock(
                          label: 'Check-In',
                          value: booking.checkIn,
                          icon: Icons.login_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DetailBlock(
                          label: 'Check-Out',
                          value: booking.checkOut,
                          icon: Icons.logout_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _DetailBlock(
                          label: 'Room Type',
                          value: booking.roomType,
                          icon: Icons.bed_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DetailBlock(
                          label: 'Duration',
                          value: '${booking.nights} Nights',
                          icon: Icons.nights_stay_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Amenities
                  const _SectionLabel('Amenities Included'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: booking.amenities.map((a) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_rounded,
                                color: AppColors.accent, size: 14),
                            const SizedBox(width: 5),
                            Text(a,
                                style: const TextStyle(
                                    color: AppColors.textPrimary, fontSize: 12)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Price summary
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      children: [
                        _PriceRow(
                          label: 'Room Rate',
                          value:
                              '\$${booking.pricePerNight.toStringAsFixed(0)} × ${booking.nights} nights',
                        ),
                        const SizedBox(height: 8),
                        _PriceRow(
                          label: 'Taxes & Fees',
                          value:
                              '\$${(booking.totalPrice * 0.1).toStringAsFixed(0)}',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: GoldDivider(),
                        ),
                        _PriceRow(
                          label: 'Total',
                          value:
                              '\$${(booking.totalPrice * 1.1).toStringAsFixed(0)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // CTA
                  if (!booking.isCheckedIn)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.login_rounded, size: 18),
                        label: const Text('PROCEED TO CHECK-IN'),
                        onPressed: () {
                          state.setSelectedBooking(bookingId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckInScreen(),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: AppColors.success),
                          SizedBox(width: 10),
                          Text(
                            'Already Checked In',
                            style: TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Local sub-widgets ───────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: AppColors.accent,
            fontSize: 11,
            letterSpacing: 3,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

class _DetailBlock extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailBlock(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accent, size: 14),
              const SizedBox(width: 5),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _PriceRow(
      {required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? AppColors.accent : AppColors.textPrimary,
            fontSize: isTotal ? 17 : 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
