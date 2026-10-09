import 'package:flutter/material.dart';
import '../../theme/milestone_app_6_colors.dart';

class MilestoneApp6ProfileActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const MilestoneApp6ProfileActionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: MilestoneApp6Colors.orange,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 20,
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      },
    );
  }
}
