import 'package:flutter/material.dart';

class AddressWidgetsSectionTitle extends StatelessWidget {
  final String title;

  const AddressWidgetsSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w600,
        color: theme
            .textTheme
            .bodyMedium
            ?.color
            ?.withOpacity(0.75),
      ),
    );
  }
}