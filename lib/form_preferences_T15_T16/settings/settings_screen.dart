import 'package:flutter/material.dart';

import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/theme/form_preferance_colors.dart';
import '../theme/app_language.dart';
import 'localization/app_localizations.dart';

import 'widgets/settings_header.dart';
import 'widgets/settings_tile.dart';
import 'widgets/theme_selector.dart';
import 'widgets/language_tile.dart';
import 'widgets/gender_selector.dart';
import 'widgets/volume_slider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;

  ThemeMode _themeMode = ThemeMode.light;

  String _language = 'en';

  String _gender = 'Female';

  double _volume = 75;

  AppLocalizations get l10n => AppLocalizations.of(context);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _themeMode == ThemeMode.dark
          ? ThemeData(
        brightness: Brightness.dark,
        fontFamily: AppLanguage.fontFamily,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.pink,
          brightness: Brightness.dark,
        ),
        dividerColor: AppColors.darkBorder,
      )
          : ThemeData(
        brightness: Brightness.light,
        fontFamily: AppLanguage.fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.pink,
          brightness: Brightness.light,
        ),
        dividerColor: const Color(0xFFE5E5E8),
      ),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,

            appBar: const SettingsHeader(),

            body: SafeArea(
              top: false,
              child: Container(
                color: isDark
                    ? AppColors.darkBackground
                    : Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Column(
                    children: [
                      // Notifications
                      SettingsTile(
                        icon: Icons.notifications_none_rounded,
                        iconBackground: AppColors.lightPink,
                        title: l10n.get('notifications'),
                        subtitle: l10n.get(
                          'notificationDescription',
                        ),
                        trailing: Switch(
                          value: _notifications,
                          activeThumbColor: AppColors.pink,
                          onChanged: (value) {
                            setState(() {
                              _notifications = value;
                            });
                          },
                        ),
                      ),

                      const _SettingsDivider(),

                      // Theme
                      SettingsTile(
                        icon: Icons.dark_mode_outlined,
                        iconBackground: AppColors.lightPurple,
                        title: l10n.get('theme'),
                        subtitle: l10n.get(
                          'themeDescription',
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                            right: 2,
                          ),
                          child: ThemeSelector(
                            value: _themeMode,
                            onChanged: (value) {
                              setState(() {
                                _themeMode = value;
                              });
                            },
                          ),
                        ),
                      ),

                      const _SettingsDivider(),

                      // Language
                      SettingsTile(
                        icon: Icons.language_rounded,
                        iconBackground: AppColors.lightBlue,
                        title: l10n.get('language'),
                        subtitle: l10n.get(
                          'languageDescription',
                        ),
                        trailing: LanguageTile(
                          language: _language,
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              _language = value;
                            });

                            AppLanguage.changeLanguage(value);
                          },
                        ),
                      ),

                      const _SettingsDivider(),

                      // Gender
                      SettingsTile(
                        icon: Icons.person_outline_rounded,
                        iconBackground: AppColors.lightPurple,
                        title: l10n.get('gender'),
                        subtitle: l10n.get(
                          'genderDescription',
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 2,
                          ),
                          child: GenderSelector(
                            value: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                        ),
                      ),

                      const _SettingsDivider(),

                      // Volume
                      SettingsTile(
                        icon: Icons.volume_up_outlined,
                        iconBackground: AppColors.lightGreen,
                        title: l10n.get('volume'),
                        subtitle: l10n.get(
                          'volumeDescription',
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 2,
                          ),
                          child: VolumeSlider(
                            value: _volume,
                            onChanged: (value) {
                              setState(() {
                                _volume = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            bottomNavigationBar: const _BottomNavigationBar(),
          );
        },
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      top: false,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: theme.dividerColor,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: _item(
                context,
                Icons.home_outlined,
                l10n.get('home'),
                false,
              ),
            ),
            Expanded(
              child: _item(
                context,
                Icons.search_rounded,
                l10n.get('search'),
                false,
              ),
            ),
            Expanded(
              child: _item(
                context,
                Icons.settings_outlined,
                l10n.get('settings'),
                true,
              ),
            ),
            Expanded(
              child: _item(
                context,
                Icons.person_outline_rounded,
                l10n.get('profile'),
                false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
      BuildContext context,
      IconData icon,
      String title,
      bool selected,
      ) {
    final theme = Theme.of(context);

    final color = selected
        ? AppColors.pink
        : theme.textTheme.bodyMedium?.color;

    return SizedBox(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 23,
            color: color,
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}