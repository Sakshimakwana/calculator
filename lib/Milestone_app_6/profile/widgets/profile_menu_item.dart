import 'package:flutter/material.dart';
import '../../theme/milestone_app_6_colors.dart';

class MilestoneApp6ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;

  const MilestoneApp6ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.onTap,
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: MilestoneApp6Colors.orange.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                trailingText!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: MilestoneApp6Colors.orange,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
          const Icon(
            Icons.chevron_right,
            size: 20,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
