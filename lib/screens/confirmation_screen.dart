import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/gold_divider.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final booking = state.selectedBookingId != null
        ? state.getBookingById(state.selectedBookingId!)
        : null;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withValues(alpha: 0.15),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(Icons.check_rounded,
                    color: AppColors.success, size: 52),
              ),
              const SizedBox(height: 28),
              const Text(
                'Check-In Confirmed!',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Your room will be ready. Please proceed to the front desk to collect your key.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Booking summary card
              if (booking != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        booking.hotelName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.location,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: GoldDivider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ConfirmDetail(
                              label: 'Room Type', value: booking.roomType),
                          _ConfirmDetail(
                              label: 'Check-In', value: booking.checkIn),
                          _ConfirmDetail(
                              label: 'Nights',
                              value: '${booking.nights}'),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: GoldDivider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Confirmation',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 12),
                          ),
                          Text(
                            booking.confirmationCode,
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),

              // Back to Dashboard
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                    (_) => false,
                  ),
                  child: const Text('BACK TO DASHBOARD'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  state.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
                  );
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmDetail extends StatelessWidget {
  final String label;
  final String value;
  const _ConfirmDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
        ),
      ],
    );
  }
}
