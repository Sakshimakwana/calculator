import 'package:app_matic_tech_flutter_app/Milestone_app_6/theme/milestone_app_6_colors.dart';
import 'package:flutter/material.dart';

import '../../../cart/data/milestone_app_6_cart_item.dart';
import '../../../common_widgets/milestone_app_6_image.dart';

class CheckoutOrderItems extends StatelessWidget {
  final List<MilestoneApp6CartItem> items;

  const CheckoutOrderItems({
    super.key,
    required this.items,
  });

  int get totalItemCount {
    return items.fold<int>(
      0,
      (total, item) => total + item.quantity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Order Items',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '$totalItemCount item'
                '${totalItemCount == 1 ? '' : 's'}',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CheckoutItem(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutItem extends StatelessWidget {
  final MilestoneApp6CartItem item;

  const _CheckoutItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MilestoneApp6Image(
          url: item.food.image,
          width: 68,
          height: 68,
          borderRadius: BorderRadius.circular(13),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.food.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Size: ${item.size}',
                style: TextStyle(
                  fontSize: 11,
                  color: MilestoneApp6Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Qty: ${item.quantity}',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '\$${item.totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
