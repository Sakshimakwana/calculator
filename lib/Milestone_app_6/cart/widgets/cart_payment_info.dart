import 'package:app_matic_tech_flutter_app/Milestone_app_6/theme/milestone_app_6_colors.dart';
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
            color: MilestoneApp6Colors.red,
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