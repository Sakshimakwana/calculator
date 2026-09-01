import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/settings/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/theme/form_preferance_colors.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  Widget _radio(
      BuildContext context,
      String title,
      String gender,
      ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: gender,
          groupValue: value,
          activeColor: AppColors.pink,
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _radio(
          context,
          l10n.get('male'),
          'Male',
        ),
        _radio(
          context,
          l10n.get('female'),
          'Female',
        ),
        _radio(
          context,
          l10n.get('other'),
          'Other',
        ),
      ],
    );
  }
}