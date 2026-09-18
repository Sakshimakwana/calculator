import 'package:flutter/material.dart';

import '../theme/milestone_app_6_colors.dart';
import 'milestone_app_6_image.dart';

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

    return Container(
      width: 210,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // Restaurant Image + OPEN/CLOSED badge
              Stack(
                children: [
                  MilestoneApp6Image(
                    url: image,
                    width: 90,
                    height: 100,
                    borderRadius: BorderRadius.circular(14),
                  ),

                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
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
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 6),

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
                            style: const TextStyle(
                              fontSize: 12,
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
                                color: theme.hintColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      // OPEN / CLOSED status
                      Row(
                        children: [
                          Icon(
                            isOpen
                                ? Icons.access_time_rounded
                                : Icons.schedule_rounded,
                            size: 13,
                            color: isOpen
                                ? Colors.green
                                : Colors.red,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            isOpen ? 'Open now' : 'Closed now',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isOpen
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
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