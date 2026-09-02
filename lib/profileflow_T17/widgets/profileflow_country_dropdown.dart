import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_colors.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_typography.dart';

class CountryDropdown extends StatelessWidget {
  const CountryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  static const countries = [
    'India',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'United Arab Emirates',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,

      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: RegistrationColors.secondaryText,
      ),

      style: RegistrationTypography.field,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your country';
        }

        return null;
      },

      decoration: InputDecoration(
        hintText: 'Select your country',

        hintStyle: RegistrationTypography.field.copyWith(
          color: RegistrationColors.secondaryText,
        ),

        prefixIcon: const Icon(
          Icons.public_outlined,
          size: 20,
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

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: RegistrationColors.border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: RegistrationColors.primary,
            width: 1.4,
          ),
        ),

        errorStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          color: RegistrationColors.error,
        ),
      ),

      items: countries.map(
            (country) {
          return DropdownMenuItem<String>(
            value: country,
            child: Text(country),
          );
        },
      ).toList(),
    );
  }
}