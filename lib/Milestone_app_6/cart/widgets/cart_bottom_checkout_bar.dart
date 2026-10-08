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
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withOpacity(.25),
          ),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                '₹${grandTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),

          Expanded(
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