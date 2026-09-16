import 'package:flutter/material.dart';

import '../theme/milestone_app_6_colors.dart';
import 'milestone_app_6_image.dart';

class MilestoneApp6RestaurantCard extends StatelessWidget {
  final String name;
  final String image;
  final String rating;
  final String time;

  const MilestoneApp6RestaurantCard({
    super.key,
    required this.name,
    required this.image,
    required this.rating,
    required this.time,
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
          // Restaurant information
          Row(
            children: [
              MilestoneApp6Image(
                url: image,
                width: 90,
                height: 100,
                borderRadius: BorderRadius.circular(14),
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