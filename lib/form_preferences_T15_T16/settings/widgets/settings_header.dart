import 'package:flutter/material.dart';

import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/settings/localization/app_localizations.dart';
import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/theme/form_preferance_colors.dart';

class SettingsHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const SettingsHeader({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,

      backgroundColor: theme.brightness == Brightness.dark
          ? AppColors.darkBackground
          : const Color(0xFFFFE8F0),

      title: Text(
        l10n.get('settings'),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: theme.brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}