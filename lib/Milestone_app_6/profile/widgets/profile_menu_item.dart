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
    final isLogout = title.toLowerCase() == 'logout';

    const primaryBrown = Color(0xFF70452F);

    final foregroundColor = isLogout ? Colors.white : const Color(0xFF60331F);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isLogout
            ? primaryBrown
            : Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).cardColor
                : const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: foregroundColor,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isLogout ? FontWeight.w600 : FontWeight.w500,
                      color: isLogout
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                if (trailingText != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: MilestoneApp6Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      trailingText!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Icon(
                  Icons.chevron_right_rounded,
                  size: 23,
                  color: isLogout ? Colors.white : Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
