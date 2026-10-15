import 'package:flutter/material.dart';

import '../../state/milestone_app_6_state.dart';

class MilestoneApp6ProfileThemeSwitch extends StatelessWidget {
  final MilestoneApp6State state;

  const MilestoneApp6ProfileThemeSwitch({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final bool dark = state.themeMode == ThemeMode.dark;

    final background = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).cardColor
        : const Color(0xFFF5F6F8);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.dark_mode_outlined,
            color: Color(0xFF60331F),
            size: 24,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Theme',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  dark ? 'Dark mode enabled' : 'Switch between light and dark',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFF60331F),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ThemeOption(
                  icon: Icons.light_mode_rounded,
                  selected: !dark,
                  onTap: () => state.setDarkMode(false),
                ),
                _ThemeOption(
                  icon: Icons.dark_mode_rounded,
                  selected: dark,
                  onTap: () => state.setDarkMode(true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 37,
        height: 34,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF1E3) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          icon,
          size: 18,
          color: selected ? const Color(0xFF60331F) : Colors.white,
        ),
      ),
    );
  }
}