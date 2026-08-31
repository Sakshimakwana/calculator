import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/theme/form_preferance_colors.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  Widget _button(
      BuildContext context,
      String text,
      ThemeMode mode,
      ) {
    final selected = value == mode;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: '$text theme',
        child: GestureDetector(
          onTap: () => onChanged(mode),
          child: Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? (Theme.of(context).brightness ==
                  Brightness.dark
                  ? AppColors.darkCard
                  : Colors.white)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected
                    ? AppColors.pink
                    : Theme.of(context).dividerColor,
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: selected
                    ? AppColors.pink
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight:
                selected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _button(context, 'Light', ThemeMode.light),
        const SizedBox(width: 10),
        _button(context, 'Dark', ThemeMode.dark),
        const SizedBox(width: 10),
        _button(context, 'System', ThemeMode.system),
      ],
    );
  }
}