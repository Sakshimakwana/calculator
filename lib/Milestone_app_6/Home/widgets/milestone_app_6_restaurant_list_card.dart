import 'package:flutter/material.dart';

import '../data/milestone_app_6_restaurants_data.dart';
import '../../widgets/milestone_app_6_image.dart';

class MilestoneApp6RestaurantListCard
    extends StatelessWidget {
  final MilestoneApp6Restaurant restaurant;
  final VoidCallback? onTap;

  const MilestoneApp6RestaurantListCard({
    super.key,
    required this.restaurant,
    this.onTap,
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
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(10),

          child: Row(
            children: [
              // ============================================================
              // RESTAURANT IMAGE + OPEN/CLOSED STATUS
              // ============================================================

              Stack(
                children: [
                  // --------------------------------------------------------
                  // IMAGE
                  // --------------------------------------------------------

                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(12),

                    child: MilestoneApp6Image(
                      url: restaurant.image,
                      width: 95,
                      height: 85,
                      fit: BoxFit.cover,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),

                  // --------------------------------------------------------
                  // OPEN / CLOSED
                  // --------------------------------------------------------

                  Positioned(
                    left: 6,
                    top: 6,

                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.75),

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Row(
                        mainAxisSize:
                        MainAxisSize.min,

                        children: [
                          // ------------------------------------------------
                          // STATUS DOT
                          // ------------------------------------------------

                          Container(
                            width: 6,
                            height: 6,

                            decoration:
                            BoxDecoration(
                              color:
                              restaurant.isOpen
                                  ? Colors.greenAccent
                                  : Colors.redAccent,

                              shape:
                              BoxShape.circle,
                            ),
                          ),

                          const SizedBox(
                            width: 4,
                          ),

                          // ------------------------------------------------
                          // STATUS TEXT
                          // ------------------------------------------------

                          Text(
                            restaurant.isOpen
                                ? 'OPEN'
                                : 'CLOSED',

                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontSize: 8,
                              fontWeight:
                              FontWeight.w800,
                              letterSpacing:
                              0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                width: 12,
              ),

              // ============================================================
              // DETAILS
              // ============================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [
                    // ------------------------------------------------------
                    // RESTAURANT NAME
                    // ------------------------------------------------------

                    Text(
                      restaurant.name,

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style:
                      const TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    // ------------------------------------------------------
                    // CUISINE
                    // ------------------------------------------------------

                    Text(
                      restaurant.cuisine,

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 11,
                        color:
                        theme.hintColor,
                      ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    // ------------------------------------------------------
                    // RATING + TIME + PRICE
                    // ------------------------------------------------------

                    Row(
                      children: [
                        Container(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),

                          decoration:
                          BoxDecoration(
                            color:
                            Colors.green,

                            borderRadius:
                            BorderRadius
                                .circular(
                              6,
                            ),
                          ),

                          child: Row(
                            mainAxisSize:
                            MainAxisSize.min,

                            children: [
                              Text(
                                restaurant
                                    .rating,

                                style:
                                const TextStyle(
                                  color:
                                  Colors.white,
                                  fontSize: 10,
                                  fontWeight:
                                  FontWeight
                                      .w700,
                                ),
                              ),

                              const SizedBox(
                                width: 2,
                              ),

                              const Icon(
                                Icons.star,
                                size: 10,
                                color:
                                Colors.white,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        Flexible(
                          child: Text(
                            restaurant.time,

                            maxLines: 1,

                            overflow:
                            TextOverflow
                                .ellipsis,

                            style: TextStyle(
                              fontSize: 10,
                              color:
                              theme.hintColor,
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        Text(
                          restaurant.price,

                          style: TextStyle(
                            fontSize: 10,
                            color:
                            theme.hintColor,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    // ------------------------------------------------------
                    // OPEN/CLOSED TEXT
                    // ------------------------------------------------------

                    Row(
                      children: [
                        Icon(
                          restaurant.isOpen
                              ? Icons
                              .access_time_rounded
                              : Icons
                              .schedule_rounded,

                          size: 13,

                          color:
                          restaurant.isOpen
                              ? Colors.green
                              : Colors.red,
                        ),

                        const SizedBox(
                          width: 4,
                        ),

                        Text(
                          restaurant.isOpen
                              ? 'Open now'
                              : 'Closed now',

                          style:
                          TextStyle(
                            fontSize: 10,
                            fontWeight:
                            FontWeight.w700,
                            color:
                            restaurant.isOpen
                                ? Colors.green
                                : Colors.red,
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