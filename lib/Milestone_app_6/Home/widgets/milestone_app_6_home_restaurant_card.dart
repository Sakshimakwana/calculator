import 'package:flutter/material.dart';

import '../../theme/milestone_app_6_colors.dart';
import '../../widgets/milestone_app_6_image.dart';

class MilestoneApp6RestaurantCard extends StatelessWidget {
  final String name;
  final String image;
  final String rating;
  final String time;
  final bool isOpen;

  const MilestoneApp6RestaurantCard({
    super.key,
    required this.name,
    required this.image,
    required this.rating,
    required this.time,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ==============================================================
    // THEME COLORS
    // ==============================================================

    final Color cardColor = isDark
        ? const Color(0xFF171717)
        : const Color(0xFFFDFDFD);

    final Color borderColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.06);

    final Color primaryTextColor = isDark
        ? Colors.white
        : Colors.black87;

    final Color secondaryTextColor = isDark
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    final Color shadowColor = isDark
        ? Colors.black.withOpacity(0.35)
        : Colors.black.withOpacity(0.05);

    final Color statusBackground = isOpen
        ? (isDark
        ? const Color(0xFF12301F)
        : const Color(0xFFEAF8EF))
        : (isDark
        ? const Color(0xFF35191B)
        : const Color(0xFFFFEEEE));

    final Color statusColor = isOpen
        ? const Color(0xFF00A651)
        : const Color(0xFFE53935);

    return Container(
      width: 210,
      padding: const EdgeInsets.all(5),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: borderColor,
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: isDark ? 12 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Stack(
        children: [
          Row(
            children: [
              // ==========================================================
              // RESTAURANT IMAGE + OPEN/CLOSED BADGE
              // ==========================================================

              Stack(
                children: [
                  MilestoneApp6Image(
                    url: image,
                    width: 90,
                    height: 100,
                    borderRadius: BorderRadius.circular(14),
                  ),

                  // OPEN / CLOSED BADGE
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(
                          isDark ? 0.82 : 0.75,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isOpen
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 4),

                          Text(
                            isOpen ? 'OPEN' : 'CLOSED',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 10),

              // ==========================================================
              // RESTAURANT INFORMATION
              // ==========================================================

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    right: 38,
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // ==================================================
                      // RESTAURANT NAME
                      // ==================================================

                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: primaryTextColor,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // ==================================================
                      // RATING + TIME
                      // ==================================================

                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: MilestoneApp6Colors.star,
                          ),

                          const SizedBox(width: 3),

                          Text(
                            rating,
                            style: TextStyle(
                              fontSize: 12,
                              color: primaryTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Flexible(
                            child: Text(
                              time,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                fontSize: 12,
                                color: secondaryTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      // ==================================================
                      // OPEN / CLOSED STATUS
                      // ==================================================

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),

                        decoration: BoxDecoration(
                          color: statusBackground,
                          borderRadius: BorderRadius.circular(7),

                          border: Border.all(
                            color: statusColor.withOpacity(
                              isDark ? 0.25 : 0.15,
                            ),
                          ),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isOpen
                                  ? Icons.access_time_rounded
                                  : Icons.schedule_rounded,
                              size: 13,
                              color: statusColor,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              isOpen
                                  ? 'Open now'
                                  : 'Closed now',

                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}