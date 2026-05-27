import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/booking_model.dart';
import '../theme/app_colors.dart';
import '../screens/login_screen.dart';
import '../screens/booking_details_screen.dart';
import '../screens/check_in_screen.dart';

import '../widgets/booking_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.secondary,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: AppColors.textSecondary),
                onPressed: () {
                  state.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D1B2A), AppColors.secondary],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.hotel_rounded, color: AppColors.accent, size: 22),
                                SizedBox(width: 8),
                                Text(
                                  'LUXE STAY',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: AppColors.accent,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Good Morning,',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                        Text(
                          state.username.isNotEmpty
                              ? _capitalize(state.username.split('@').first)
                              : 'Valued Guest',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _StatCard(
                        icon: Icons.calendar_today_rounded,
                        label: 'Upcoming',
                        value: '${state.bookings.where((b) => !b.isCheckedIn).length}',
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.check_circle_outline_rounded,
                        label: 'Checked In',
                        value: '${state.bookings.where((b) => b.isCheckedIn).length}',
                        isHighlighted: true,
                      ),
                      const SizedBox(width: 12),
                      const _StatCard(
                        icon: Icons.star_outline_rounded,
                        label: 'Points',
                        value: '2,840',
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      'YOUR UPCOMING STAYS',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final BookingModel booking = state.bookings[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  child: BookingCard(
                    booking: booking,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingDetailsScreen(bookingId: booking.id),
                      ),
                    ),
                    onCheckIn: () {
                      state.setSelectedBooking(booking.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CheckInScreen()),
                      );
                    },
                  ),
                );
              },
              childCount: state.bookings.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ── Stat Card ──────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isHighlighted;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isHighlighted
              ? AppColors.accent.withValues(alpha: 0.15)
              : AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlighted
                ? AppColors.accent.withValues(alpha: 0.5)
                : AppColors.divider,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isHighlighted ? AppColors.accent : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: isHighlighted ? AppColors.accent : AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
