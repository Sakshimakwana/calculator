import 'package:flutter/material.dart';
import '../theme/appointment_colors.dart';
import '../theme/appointment_typography.dart';

class EmployeeDropdown extends StatelessWidget {
  const EmployeeDropdown({
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
          'Select Employee',
          style: AppointmentTypography.label,
        ),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.person,
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
              value: 'Jessica Brown',
              child: Text('Jessica Brown'),
            ),
            DropdownMenuItem(
              value: 'Emily Smith',
              child: Text('Emily Smith'),
            ),
            DropdownMenuItem(
              value: 'Sophia Wilson',
              child: Text('Sophia Wilson'),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}