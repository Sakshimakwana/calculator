import 'package:flutter/material.dart';

import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/theme/form_preferance_colors.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.child,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 27,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme
                                  .textTheme
                                  .titleMedium
                                  ?.color,
                            ),
                          ),
                        ),

                        if (trailing != null) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: trailing!,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        color: theme
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (child != null)
            SizedBox(
              width: double.infinity,
              child: child!,
            ),
        ],
      ),
    );
  }
}