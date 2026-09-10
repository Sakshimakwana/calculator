import 'package:flutter/material.dart';

class ThemeSwitch extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const ThemeSwitch({
    super.key,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary =
        Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.light_mode_outlined,
          size: 21,
          color: isDark
              ? Colors.grey
              : primary,
        ),

        const SizedBox(width: 6),

        Switch(
          value: isDark,
          onChanged: onChanged,
        ),

        const SizedBox(width: 6),

        Icon(
          Icons.dark_mode_outlined,
          size: 21,
          color: isDark
              ? primary
              : Colors.grey,
        ),
      ],
    );
  }
}