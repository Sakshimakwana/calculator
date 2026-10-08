import 'package:flutter/material.dart';

import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/model/cart_response_model.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/common_widgets/milestone_app_6_image.dart';

class MilestoneApp6CartItem extends StatelessWidget {
  final CartItemModel item;

  final Future<void> Function(
      BuildContext context,
      CartItemModel item,
      int quantity,
      ) onUpdateQuantity;

  final Future<void> Function(
      BuildContext context,
      CartItemModel item,
      ) onDelete;

  const MilestoneApp6CartItem({
    super.key,
    required this.item,
    required this.onUpdateQuantity,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final quantity = item.quantity;
    final lineTotal = item.menuItem.price * quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withOpacity(.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MilestoneApp6Image(
            url: item.menuItem.imageUrl,
            width: 88,
            height: 88,
            borderRadius: BorderRadius.circular(15),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.menuItem.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    IconButton(
                      tooltip: 'Remove item',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      onPressed: () => onDelete(
                        context,
                        item,
                      ),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                Text(
                  item.restaurant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.hintColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '₹${item.menuItem.price.toStringAsFixed(2)} each',
                  style: TextStyle(
                    color: theme.hintColor,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 9),

                Row(
                  children: [
                    // ------------------------------------------------
                    // MINUS
                    // ------------------------------------------------
                    _counter(
                      context,
                      Icons.remove,
                      quantity > 1
                          ? () => onUpdateQuantity(
                        context,
                        item,
                        quantity - 1,
                      )
                          : null,
                    ),

                    // ------------------------------------------------
                    // QUANTITY
                    // ------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                      ),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // ------------------------------------------------
                    // PLUS
                    // ------------------------------------------------
                    _counter(
                      context,
                      Icons.add,
                          () => onUpdateQuantity(
                        context,
                        item,
                        quantity + 1,
                      ),
                    ),

                    const Spacer(),

                    // ------------------------------------------------
                    // TOTAL
                    // ------------------------------------------------
                    Text(
                      '₹${lineTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // COUNTER
  // ================================================================

  Widget _counter(
      BuildContext context,
      IconData icon,
      VoidCallback? onTap,
      ) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: onTap == null
                ? theme.dividerColor.withOpacity(.08)
                : theme.colorScheme.primary.withOpacity(.10),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            size: 16,
            color: onTap == null
                ? theme.hintColor
                : theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}