import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/models/order/order_info_model.dart';

class MyOrderProductRow extends StatelessWidget {
  final OrderItemModel item;

  const MyOrderProductRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isDark ? const Color(0xFF252525) : const Color(0xFFF3F3F3),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              item.menuItem.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.fastfood_outlined,
                  size: 25,
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItem.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF171717),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '₹${item.priceAtPurchase.toStringAsFixed(2)} × ${item.quantity}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '₹${item.totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF171717),
            ),
          ),
        ],
      ),
    );
  }
}
