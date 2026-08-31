import 'package:flutter/material.dart';
import '../theme/appointment_colors.dart';
import '../theme/appointment_typography.dart';

class ServiceDropdown extends StatelessWidget {
  const ServiceDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Service',
          style: AppointmentTypography.label,
        ),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.content_cut,
              color: AppointmentColors.icon,
              size: 19,
            ),
            filled: true,
            fillColor: AppointmentColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(
                color: AppointmentColors.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(
                color: AppointmentColors.border,
              ),
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
          ),
          style: AppointmentTypography.fieldText,
          items: const [
            DropdownMenuItem(
              value: 'Haircut & Styling',
              child: Text('Haircut & Styling'),
            ),
            DropdownMenuItem(
              value: 'Hair Coloring',
              child: Text('Hair Coloring'),
            ),
            DropdownMenuItem(
              value: 'Facial',
              child: Text('Facial'),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}