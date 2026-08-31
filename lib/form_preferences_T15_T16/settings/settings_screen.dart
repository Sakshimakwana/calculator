import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/theme/form_preferance_colors.dart';
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
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;

  ThemeMode _themeMode = ThemeMode.light;

  String _language = 'English';

  String _gender = 'Female';

  double _volume = 75;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _themeMode == ThemeMode.dark
          ? ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor:
        AppColors.darkBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.pink,
          brightness: Brightness.dark,
        ),
        dividerColor: AppColors.darkBorder,
      )
          : ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.pink,
          brightness: Brightness.light,
        ),
      ),

      child: Builder(
        builder: (context) {
          final isDark =
              Theme.of(context).brightness == Brightness.dark;

          return Scaffold(
            backgroundColor: Theme.of(context)
                .scaffoldBackgroundColor,

            body: SafeArea(
              child: Container(
               width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCard
                      : Colors.white,
                ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),

                    child: Column(
                      children: [
                        const SettingsHeader(),

                        Expanded(
                          child: SingleChildScrollView(
                           padding: EdgeInsetsGeometry.all(5),

                            child: Column(
                              children: [
                                // Notifications
                                SettingsTile(
                                  icon: Icons.notifications_none,
                                  iconBackground:
                                  AppColors.lightPink,
                                  title: 'Notifications',
                                  subtitle:
                                  'Enable or disable notifications',
                                  trailing: Semantics(
                                    label: 'Notifications',
                                    value: _notifications
                                        ? 'On'
                                        : 'Off',
                                    child: Switch(
                                      value: _notifications,
                                      activeThumbColor:
                                      AppColors.pink,
                                      onChanged: (value) {
                                        setState(() {
                                          _notifications = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),

                                Divider(
                                  color: Theme.of(context)
                                      .dividerColor,
                                ),

                                // Theme
                                SettingsTile(
                                  icon: Icons.nightlight_outlined,
                                  iconBackground:
                                  AppColors.lightPurple,
                                  title: 'Theme',
                                  subtitle:
                                  'Choose your preferred theme',
                                  child: ThemeSelector(
                                    value: _themeMode,
                                    onChanged: (value) {
                                      setState(() {
                                        _themeMode = value;
                                      });
                                    },
                                  ),
                                ),

                                Divider(
                                  color: Theme.of(context)
                                      .dividerColor,
                                ),

                                // Language
                                SettingsTile(
                                  icon: Icons.language,
                                  iconBackground:
                                  AppColors.lightBlue,
                                  title: 'Language',
                                  subtitle:
                                  'Choose your language',
                                  trailing: LanguageTile(
                                    language: _language,
                                    onChanged: (value) {
                                      if (value == null) return;

                                      setState(() {
                                        _language = value;
                                      });
                                    },
                                  ),
                                ),

                                Divider(
                                  color: Theme.of(context)
                                      .dividerColor,
                                ),

                                // Gender
                                SettingsTile(
                                  icon: Icons.person_outline,
                                  iconBackground:
                                  AppColors.lightPurple,
                                  title: 'Gender',
                                  subtitle:
                                  'Select your gender',
                                  child: GenderSelector(
                                    value: _gender,
                                    onChanged: (value) {
                                      setState(() {
                                        _gender = value;
                                      });
                                    },
                                  ),
                                ),

                                Divider(
                                  color: Theme.of(context)
                                      .dividerColor,
                                ),

                                // Volume
                                SettingsTile(
                                  icon: Icons.volume_up_outlined,
                                  iconBackground:
                                  AppColors.lightGreen,
                                  title: 'Volume',
                                  subtitle:
                                  'Adjust media volume',
                                  child: VolumeSlider(
                                    value: _volume,
                                    onChanged: (value) {
                                      setState(() {
                                        _volume = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        _BottomNavigationBar(),
                      ],
                    ),
                  ),
                ),
              ),
          );
        },
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCard
            : Colors.white,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(
            context,
            Icons.home_outlined,
            'Home',
            false,
          ),
          _item(
            context,
            Icons.search,
            'Search',
            false,
          ),
          _item(
            context,
            Icons.settings,
            'Settings',
            true,
          ),
          _item(
            context,
            Icons.person_outline,
            'Profile',
            false,
          ),
        ],
      ),
    );
  }

  Widget _item(
      BuildContext context,
      IconData icon,
      String title,
      bool selected,
      ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: selected
              ? AppColors.pink
              : Theme.of(context)
              .textTheme
              .bodyMedium
              ?.color,
          size: 27,
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: selected
                ? AppColors.pink
                : Theme.of(context)
                .textTheme
                .bodyMedium
                ?.color,
          ),
        ),
      ],
    );
  }
}