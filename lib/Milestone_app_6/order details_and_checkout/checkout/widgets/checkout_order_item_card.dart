
import 'package:flutter/material.dart';

import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/data/milestone_app_6_cart_item.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/common_widgets/milestone_app_6_image.dart';

class CheckoutOrderItemCard extends StatelessWidget {
  final MilestoneApp6CartItem item;

  const CheckoutOrderItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            height: 76,
            child: MilestoneApp6Image(
              url: item.food.image,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.food.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Qty: ${item.quantity}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 5),
                Text(
                  '₹${item.totalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
