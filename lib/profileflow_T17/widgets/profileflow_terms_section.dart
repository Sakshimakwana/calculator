import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_colors.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_typography.dart';
class TermsSection extends StatelessWidget {
  const TermsSection({
    super.key,
    required this.termsAccepted,
    required this.privacyAccepted,
    required this.onTermsChanged,
    required this.onPrivacyChanged,
  });

  final bool termsAccepted;
  final bool privacyAccepted;

  final ValueChanged<bool?> onTermsChanged;
  final ValueChanged<bool?> onPrivacyChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          value: termsAccepted,
          onChanged: onTermsChanged,
          controlAffinity:
          ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
          activeColor: RegistrationColors.primary,
          title: RichText(
            text: const TextSpan(
              style: RegistrationTypography.body,
              children: [
                TextSpan(
                  text: 'I agree to the ',
                ),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(
                    color: RegistrationColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        CheckboxListTile(
          value: privacyAccepted,
          onChanged: onPrivacyChanged,
          controlAffinity:
          ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
          activeColor: RegistrationColors.primary,
          title: RichText(
            text: const TextSpan(
              style: RegistrationTypography.body,
              children: [
                TextSpan(
                  text: 'I agree to the ',
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: RegistrationColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}