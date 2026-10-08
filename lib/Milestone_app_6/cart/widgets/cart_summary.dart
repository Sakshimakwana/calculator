import 'package:flutter/material.dart';

class MilestoneApp6CartSummary extends StatelessWidget {
  final double itemTotal;
  final double deliveryFee;
  final double discount;
  final double grandTotal;

  const MilestoneApp6CartSummary({
    super.key,
    required this.itemTotal,
    required this.deliveryFee,
    required this.discount,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bill Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 17),

          _summaryRow(
            context,
            'Item Total',
            '₹${itemTotal.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 10),

          _summaryRow(
            context,
            'Delivery Fee',
            deliveryFee == 0
                ? 'FREE'
                : '₹${deliveryFee.toStringAsFixed(2)}',
            valueColor:
            deliveryFee == 0 ? Colors.green : null,
          ),

          if (discount > 0) ...[
            const SizedBox(height: 10),

            _summaryRow(
              context,
              'Coupon Discount',
              '-₹${discount.toStringAsFixed(2)}',
              valueColor: Colors.green,
            ),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
          ),

          _summaryRow(
            context,
            'Grand Total',
            '₹${grandTotal.toStringAsFixed(2)}',
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
      BuildContext context,
      String title,
      String value, {
        bool bold = false,
        Color? valueColor,
      }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: bold ? 15 : 13,
              fontWeight:
              bold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 16 : 13,
            color: valueColor,
            fontWeight:
            bold ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}