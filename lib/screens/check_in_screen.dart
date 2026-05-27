import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/upload_tile.dart';
import '../widgets/credit_card_visual.dart';

import '../screens/confirmation_screen.dart';

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final booking = state.selectedBookingId != null
        ? state.getBookingById(state.selectedBookingId!)
        : null;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textSecondary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Self Check-In',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking summary strip
            if (booking != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.35)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.hotel_rounded,
                        color: AppColors.accent, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.hotelName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${booking.checkIn} → ${booking.checkOut}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${(booking.totalPrice * 1.1).toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ── Step 01: Identity ──────────────────────────────────────────
            _StepHeader(number: '01', title: 'Identity Verification'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: UploadTile(
                    icon: Icons.badge_outlined,
                    label: 'Upload Passport\nor ID',
                    isUploaded: state.passportUploaded,
                    onTap: state.mockUploadPassport,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: UploadTile(
                    icon: Icons.face_outlined,
                    label: 'Upload\nSelfie Photo',
                    isUploaded: state.selfieUploaded,
                    onTap: state.mockUploadSelfie,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Step 02: Payment ───────────────────────────────────────────
            _StepHeader(number: '02', title: 'Payment Information'),
            const SizedBox(height: 12),

            // Live card preview
            CreditCardVisual(
              holderName: state.cardHolderName,
              number: state.creditCardNumber,
              expiry: state.cardExpiry,
            ),
            const SizedBox(height: 16),

            TextField(
              onChanged: state.setCardHolderName,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Card Holder Name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (v) {
                final digits = v.replaceAll(' ', '');
                final formatted = digits
                    .replaceAllMapped(
                      RegExp(r'.{4}'),
                      (m) => '${m.group(0)} ',
                    )
                    .trim();
                state.setCreditCardNumber(formatted);
              },
              style: const TextStyle(color: AppColors.textPrimary),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ],
              decoration: const InputDecoration(
                labelText: 'Card Number',
                prefixIcon: Icon(Icons.credit_card_rounded),
                counterText: '',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: AppColors.textPrimary),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Expiry (MM/YY)',
                      prefixIcon: Icon(Icons.date_range_outlined),
                    ),
                    onChanged: (v) {
                      String val = v.replaceAll('/', '');
                      if (val.length >= 2) {
                        val =
                            '${val.substring(0, 2)}/${val.substring(2)}';
                      }
                      state.setCardExpiry(val);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: state.setCardCVV,
                    style: const TextStyle(color: AppColors.textPrimary),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Error banner
            if (state.errorMessage.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage,
                        style: const TextStyle(
                            color: AppColors.error, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: const Text('CONFIRM CHECK-IN'),
                onPressed: () {
                  if (state.validateCheckIn()) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConfirmationScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '🔒  Your payment data is encrypted and secure.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Step header ─────────────────────────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  final String number;
  final String title;
  const _StepHeader({required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
