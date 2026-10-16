
import 'package:app_matic_tech_flutter_app/Milestone_app_6/theme/milestone_app_6_colors.dart';
import 'package:flutter/material.dart';

class CheckoutCouponSection extends StatelessWidget {
  final TextEditingController controller;
  final bool couponApplied;
  final VoidCallback onApply;
  final VoidCallback onRemove;

  const CheckoutCouponSection({
    super.key,
    required this.controller,
    required this.couponApplied,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apply Coupon',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !couponApplied,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.dividerColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              couponApplied
                  ? OutlinedButton(
                onPressed: onRemove,
                style: OutlinedButton.styleFrom(
                  foregroundColor: MilestoneApp6Colors.red,
                  side: const BorderSide(
                    color: MilestoneApp6Colors.red,
                  ),
                ),
                child: const Text('Remove'),
              )
                  : FilledButton(
                onPressed: onApply,
                style: FilledButton.styleFrom(
                  backgroundColor: MilestoneApp6Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
          if (couponApplied) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: MilestoneApp6Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'FOOD10 applied • 10% OFF',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: MilestoneApp6Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
