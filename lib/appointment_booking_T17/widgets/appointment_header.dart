import 'package:flutter/material.dart';
import '../theme/appointment_colors.dart';
import '../theme/appointment_typography.dart';

class AppointmentHeader extends StatelessWidget {
  const AppointmentHeader({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back,
                color: AppointmentColors.text,
                size: 22,
              ),
            ),
            const Spacer(),
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppointmentColors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_outlined,
                size: 19,
                color: AppointmentColors.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Appointment Booking',
          style: AppointmentTypography.title,
        ),
        const SizedBox(height: 5),
        const Text(
          'Book your service in few easy steps',
          style: AppointmentTypography.subtitle,
        ),
      ],
    );
  }
}