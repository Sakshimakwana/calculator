import 'package:flutter/material.dart';
import 'my_order_status_badge.dart';

class MyOrderRestaurantHeader extends StatelessWidget {
  final String restaurantName;
  final String restaurantImage;
  final String restaurantAddress;
  final String orderId;
  final String orderStatus;

  const MyOrderRestaurantHeader({
    super.key,
    required this.restaurantName,
    required this.restaurantImage,
    required this.restaurantAddress,
    required this.orderId,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.grey.shade200,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              restaurantImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: isDark
                      ? const Color(0xFF242424)
                      : const Color(0xFFF3F3F3),
                  child: Icon(
                    Icons.restaurant_rounded,
                    size: 28,
                    color: Colors.grey.shade500,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        restaurantName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color:
                              isDark ? Colors.white : const Color(0xFF171717),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '#$orderId',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Colors.grey.shade500
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color:
                          isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        restaurantAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey.shade500
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
