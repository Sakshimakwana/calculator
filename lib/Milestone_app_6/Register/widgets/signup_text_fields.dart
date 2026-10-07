import 'package:flutter/material.dart';

class SignupTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLength;
  final VoidCallback? onSuffixPressed;
  final VoidCallback? onSubmitted;

  const SignupTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLength,
    this.onSuffixPressed,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      validator: validator,
      obscureText: obscureText,
      maxLength: maxLength,
      onFieldSubmitted: onSubmitted == null
          ? null
          : (_) => onSubmitted!(),
      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: Icon(
          icon,
          size: 21,
          color: theme.colorScheme.primary.withOpacity(.70),
        ),

        suffixIcon: suffixIcon,

        filled: true,

        fillColor: theme.colorScheme.surfaceContainerHighest
            .withOpacity(.45),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: theme.dividerColor.withOpacity(.35),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: theme.dividerColor.withOpacity(.35),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),

        counterText: maxLength != null ? '' : null,
      ),
    );
  }
}