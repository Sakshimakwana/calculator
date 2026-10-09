import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/models/order/order_info_model.dart';
import 'my_order_product_row.dart';

class MyOrderItems extends StatelessWidget {
  final List<OrderItemModel> items;

  const MyOrderItems({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161616) : const Color(0xFFFCFCFC),
      ),
      child: Column(
        children: [
          for (int index = 0; index < items.length; index++) ...[
            MyOrderProductRow(
              item: items[index],
            ),
            if (index != items.length - 1)
              Divider(
                height: 1,
                color: isDark
                    ? Colors.white.withOpacity(0.07)
                    : Colors.grey.shade200,
              ),
          ],
        ],
      ),
    );
  }
}
