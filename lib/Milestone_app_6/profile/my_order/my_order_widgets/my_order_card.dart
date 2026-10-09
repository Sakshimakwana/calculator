import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/models/order/order_info_model.dart';
import 'my_order_restaurant_header.dart';
import 'my_order_items.dart';
import 'my_order_information.dart';
import 'my_order_actions.dart';

class MyOrderCard extends StatelessWidget {
  final OrderInfoModel order;
  final bool alreadySubmitted;
  final VoidCallback onTap;
  final VoidCallback onWriteReview;

  const MyOrderCard({
    super.key,
    required this.order,
    required this.alreadySubmitted,
    required this.onTap,
    required this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF111111) : Colors.white;

    final borderColor =
        isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE8E8E8);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                isDark ? 0.28 : 0.05,
              ),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            MyOrderRestaurantHeader(
              restaurantName: order.restaurant.name,
              restaurantImage: order.restaurant.imageUrl,
              restaurantAddress: order.restaurant.address,
              orderId: order.id.toString(),
              orderStatus: order.status,
            ),
            MyOrderItems(
              items: order.orderItems,
            ),
            MyOrderInformation(
              createdAt: order.createdAt,
              status: order.status,
              total: order.total,
            ),
            MyOrderActions(
              status: order.status,
              alreadySubmitted: alreadySubmitted,
              onWriteReview: onWriteReview,
            ),
          ],
        ),
      ),
    );
  }
}