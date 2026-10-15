
import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/common_widgets/milestone_app_6_button.dart';

class MilestoneApp6CartBottomCheckoutBar extends StatelessWidget {
  final double grandTotal;
  final VoidCallback onCheckout;

  const MilestoneApp6CartBottomCheckoutBar({
    super.key,
    required this.grandTotal,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.hintColor,
                ),
              ),
              Text(
                '₹${grandTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 54,
            child: MilestoneApp6Button(
              label: 'Proceed to Checkout',
              onPressed: onCheckout,
            ),
          ),
        ],
      ),
    );
  }
}
