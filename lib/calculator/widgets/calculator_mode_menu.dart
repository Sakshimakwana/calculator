import 'package:flutter/material.dart';

class CalculatorModeMenu extends StatelessWidget {
  final String selectedMode;
  final Function(String) onSelected;

  const CalculatorModeMenu({
    super.key,
    required this.selectedMode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white12,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuItem(
              context,
              'Basic',
              'Basic',
            ),
            _menuItem(
              context,
              'Scientific',
              'Scientific',
            ),
            _menuItem(
              context,
              'Maths Notes',
              'Maths Notes',
            ),
            const Divider(
              color: Colors.white12,
              indent: 24,
              endIndent: 28,
            ),
            _menuItem(
              context,
              'Convert',
              'Convert',
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
      BuildContext context,
      String title,
      String value,
      ) {
    final selected = selectedMode == value;

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onSelected(value);
      },
      child: SizedBox(
        height: 62,
        child: Row(
          children: [
            const SizedBox(width: 28),

            SizedBox(
              width: 30,
              child: selected
                  ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 22,
              )
                  : null,
            ),

            const SizedBox(width: 12),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}