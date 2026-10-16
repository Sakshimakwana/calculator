import 'package:app_matic_tech_flutter_app/Milestone_app_6/theme/milestone_app_6_colors.dart';
import 'package:flutter/material.dart';

class CheckoutSteps extends StatelessWidget {
  const CheckoutSteps({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: MilestoneApp6Colors.red.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _Step(
            number: '1',
            title: 'Address',
            active: true,
            theme: theme,
          ),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              color: MilestoneApp6Colors.red.withOpacity(0.25),
            ),
          ),
          _Step(
            number: '2',
            title: 'Payment',
            active: true,
            theme: theme,
          ),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              color: theme.dividerColor.withOpacity(0.4),
            ),
          ),
          _Step(
            number: '3',
            title: 'Done',
            active: false,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String title;
  final bool active;
  final ThemeData theme;

  const _Step({
    required this.number,
    required this.title,
    required this.active,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? MilestoneApp6Colors.red
                : theme.dividerColor.withOpacity(0.35),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: TextStyle(
              color: active ? Colors.white : theme.hintColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: active ? FontWeight.w800 : FontWeight.w500,
            color: active ? MilestoneApp6Colors.red : theme.hintColor,
          ),
        ),
      ],
    );
  }
}
