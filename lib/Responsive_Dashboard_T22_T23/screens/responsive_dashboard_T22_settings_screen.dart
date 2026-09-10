import 'package:flutter/material.dart';
import '../Widgets_T23/Theme_T23_theme_switch.dart';


class ResponsiveDashboardT22SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const ResponsiveDashboardT22SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          // ======================================================
          // APPEARANCE
          // ======================================================

          Text(
            'Appearance',
            style: Theme.of(context)
                .textTheme
                .titleLarge,
          ),

          const SizedBox(height: 12),

          // ======================================================
          // THEME CARD
          // ======================================================

          Card(
            child: Padding(
              padding: const EdgeInsets.all(6),

              child: ListTile(
                leading: Container(
                  width: 46,
                  height: 46,

                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(
                      alpha: 0.12,
                    ),

                    borderRadius:
                    BorderRadius.circular(14),
                  ),

                  child: Icon(
                    isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,

                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
                ),

                title: Text(
                  'Theme Mode',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),

                subtitle: Text(
                  isDarkMode
                      ? 'Dark mode is enabled'
                      : 'Light mode is enabled',

                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),

                trailing: ThemeSwitch(
                  isDark: isDarkMode,
                  onChanged: onThemeChanged,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ======================================================
          // CURRENT THEME
          // ======================================================

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Text(
                    'Current Theme',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,

                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        isDarkMode
                            ? 'Dark'
                            : 'Light',

                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ======================================================
          // INFORMATION
          // ======================================================

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.info_outline,
              ),

              title: const Text(
                'Theme Preference',
              ),

              subtitle: const Text(
                'Your selected theme is saved automatically.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}