import 'package:flutter/material.dart';

import '../data/milestone_app_6_restaurants_data.dart';
import 'milestone_app_6_image.dart';

class MilestoneApp6RestaurantListCard
    extends StatelessWidget {
  final MilestoneApp6Restaurant restaurant;

  const MilestoneApp6RestaurantListCard({
    super.key,
    required this.restaurant, required Null Function() onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Restaurant details can be added here later.
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // ---------------------------------------------------------
              // IMAGE
              // ---------------------------------------------------------
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MilestoneApp6Image(
                  url: restaurant.image,
                  width: 95,
                  height: 85,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              const SizedBox(width: 12),

              // ---------------------------------------------------------
              // DETAILS
              // ---------------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      restaurant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      restaurant.cuisine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.hintColor,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                            BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [
                              Text(
                                restaurant.rating,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.star,
                                size: 10,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          restaurant.time,
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.hintColor,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          restaurant.price,
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.hintColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}