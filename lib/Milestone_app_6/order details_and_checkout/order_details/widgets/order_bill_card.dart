import 'package:flutter/material.dart';

class MilestoneApp6OrderBillCard extends StatelessWidget {
  final Map<String, dynamic>? order;
  final double totalPayment;
  final double shipping;
  final double discount;

  const MilestoneApp6OrderBillCard({
    super.key,
    required this.order,
    required this.totalPayment,
    required this.shipping,
    required this.discount,
  });

  Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  int? _intValue(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  double? _doubleValue(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE8E9EC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEDF0),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 19,
            color: const Color(0xFFEF5B6B),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _billRow(
    String title,
    String value, {
    bool bold = false,
    double fontSize = 13.5,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
              color: bold ? Colors.black87 : Colors.black54,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderTotal = _doubleValue(order?['total']) ?? totalPayment;

    final deliveryFee = _doubleValue(order?['delivery_fee']) ?? shipping;

    final rawItems = order?['order_items'];

    final List<Map<String, dynamic>> items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList()
        : <Map<String, dynamic>>[];

    final itemTotal = items.fold<double>(
      0,
      (sum, item) {
        final menuItem = _map(item['menu_item']);

        final price = _doubleValue(item['price_at_purchase']) ??
            _doubleValue(menuItem['price']) ??
            0;

        final quantity = _intValue(item['quantity']) ?? 1;

        return sum + price * quantity;
      },
    );

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.receipt_long_outlined,
            'Bill Summary',
          ),
          const SizedBox(height: 17),
          _billRow(
            'Item Total',
            '₹${itemTotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _billRow(
            'Delivery Fee',
            '₹${deliveryFee.toStringAsFixed(2)}',
          ),
          if (discount > 0) ...[
            const SizedBox(height: 10),
            _billRow(
              'Discount',
              '-₹${discount.toStringAsFixed(2)}',
              valueColor: const Color(0xFF238B45),
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          _billRow(
            'Total',
            '₹${orderTotal.toStringAsFixed(2)}',
            bold: true,
            fontSize: 18,
          ),
        ],
      ),
    );
  }
}
