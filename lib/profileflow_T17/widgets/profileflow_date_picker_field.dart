import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_colors.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_typography.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.value,
    required this.onTap,
    this.errorText,
  });

  final DateTime? value;
  final VoidCallback onTap;
  final String? errorText;

  String _format(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.calendar_today_outlined,
            size: 19,
            color: RegistrationColors.secondaryText,
          ),

          filled: true,
          fillColor: RegistrationColors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 15,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: RegistrationColors.border,
            ),
          ),

          errorText: errorText,

          errorStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            color: RegistrationColors.error,
          ),
        ),
        child: Text(
          value == null
              ? 'Select your birth date'
              : _format(value!),
          style: RegistrationTypography.field.copyWith(
            color: value == null
                ? RegistrationColors.secondaryText
                : RegistrationColors.text,
          ),
        ),
      ),
    );
  }
}