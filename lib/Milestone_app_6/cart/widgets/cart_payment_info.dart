import 'package:flutter/material.dart';

class MilestoneApp6CartPaymentInfo extends StatelessWidget {
  const MilestoneApp6CartPaymentInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(.07),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 19,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 9),

          Expanded(
            child: Text(
              'Your payment information is secure and protected.',
              style: TextStyle(
                fontSize: 11,
                color: theme.hintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}