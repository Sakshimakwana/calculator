import 'package:flutter/material.dart';

class ResponsiveDashboardT22QuickActionButton
    extends StatelessWidget {
  const ResponsiveDashboardT22QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: color.withValues(alpha: .10),
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(11),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 8,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 19,
                color: color,
              ),

              const SizedBox(height: 5),

              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}