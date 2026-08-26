import 'package:flutter/material.dart';

import '../theme/pricing_colors.dart';
import '../theme/pricing_typography.dart';

class PricingFeatureItem extends StatelessWidget {
  final String text;
  final bool available;
  final Color color;

  const PricingFeatureItem({
    super.key,
    required this.text,
    required this.available,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          available ? Icons.check_circle : Icons.cancel,
          size: 18,
          color: available ? color : PricingColors.disabledIcon,
        ),

        const SizedBox(width: 8),

        Flexible(
          child: Text(
            text,
            style: PricingTypography.feature.copyWith(
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}