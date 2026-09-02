import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_colors.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationTextField extends StatelessWidget {
  const RegistrationTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction,
    this.onFieldSubmitted,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      style: RegistrationTypography.field,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: RegistrationTypography.field.copyWith(
          color: RegistrationColors.secondaryText,
        ),
        prefixIcon: Icon(
          icon,
          size: 20,
          color: RegistrationColors.secondaryText,
        ),
        suffixIcon: suffixIcon,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: RegistrationColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: RegistrationColors.error,
          ),
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          color: RegistrationColors.error,
        ),
      ),
    );
  }
}