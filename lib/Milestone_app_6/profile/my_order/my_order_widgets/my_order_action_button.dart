import 'package:flutter/material.dart';

class MyOrderActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;

  const MyOrderActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = theme.colorScheme.primary;

    return SizedBox(
      height: 38,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? accent : Colors.transparent,
          foregroundColor: filled
              ? Colors.white
              : isDark
                  ? Colors.white
                  : Colors.black87,
          side: BorderSide(
            color: filled
                ? accent
                : isDark
                    ? Colors.white.withOpacity(0.15)
                    : Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
