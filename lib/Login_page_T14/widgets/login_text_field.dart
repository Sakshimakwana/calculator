import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/Login_page_T14/theme/login_typogarphy.dart';
import 'package:app_matic_tech_flutter_app/Login_page_T14/theme/login_app_colors.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.label,
        ),

        const SizedBox(height: 6),

        SizedBox(
          width: 450,
          height: 50,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            obscureText: obscureText,

            textInputAction: nextFocusNode != null
                ? TextInputAction.next
                : TextInputAction.done,

            onSubmitted: (_) {
              if (nextFocusNode != null) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              }
            },

            style: AppTypography.input,

            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.hint,

              prefixIcon: Icon(
                prefixIcon,
                size: 20,
                color: AppColors.icon,
              ),

              suffixIcon: suffixIcon,

              isDense: true,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 13,
              ),

              // Normal / unfocused border
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFD0D0D0),
                  width: 1,
                ),
              ),

              // Focused border
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}