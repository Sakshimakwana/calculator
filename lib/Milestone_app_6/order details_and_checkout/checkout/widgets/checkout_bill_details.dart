
import 'package:app_matic_tech_flutter_app/Milestone_app_6/theme/milestone_app_6_colors.dart';
import 'package:flutter/material.dart';

class CheckoutBillDetails extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double discount;
  final double totalPayment;

  const CheckoutBillDetails({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.discount,
    required this.totalPayment,
  });

  String _formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  Widget _billRow(
      BuildContext context, {
        required String title,
        required String amount,
        bool isTotal = false,
        Color? amountColor,
      }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight:
                isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            amount,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight:
              isTotal ? FontWeight.bold : FontWeight.w500,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
            'Bill Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _billRow(
            context,
            title: 'Item Total',
            amount: _formatAmount(subtotal),
          ),
          _billRow(
            context,
            title: 'Delivery Fee',
            amount: _formatAmount(shipping),
          ),
          _billRow(
            context,
            title: 'Discount',
            amount: '-${_formatAmount(discount)}',
            amountColor: MilestoneApp6Colors.red,
          ),
          Divider(
            height: 20,
            color: theme.dividerColor,
          ),
          _billRow(
            context,
            title: 'To Pay',
            amount: _formatAmount(totalPayment),
            isTotal: true,
            amountColor:MilestoneApp6Colors.red ,
          ),
        ],
      ),
    );
  }
}
