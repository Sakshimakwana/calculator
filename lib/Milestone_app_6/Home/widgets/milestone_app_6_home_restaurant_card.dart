import 'package:flutter/material.dart';
import '../../widgets/milestone_app_6_image.dart';

class MilestoneApp6RestaurantCard extends StatelessWidget {
  final String name;
  final String image;
  final String rating;
  final String time;
  final bool isOpen;
  final String distance;
  final String address;
  final String categories;
  final VoidCallback? onTap;

  const MilestoneApp6RestaurantCard({
    super.key,
    required this.name,
    required this.image,
    required this.rating,
    required this.time,
    required this.isOpen,
    this.distance = '',
    this.address = '',
    this.categories = '',
    this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark =
        theme.brightness == Brightness.dark;

    final bool isClosed = !isOpen;

    // ==========================================================
    // COLORS
    // ==========================================================

    final Color cardColor = isDark
        ? const Color(0xFF171717)
        : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFEAEAEA);

    final Color titleColor = isDark
        ? Colors.white
        : const Color(0xFF171717);

    final Color secondaryColor = isDark
        ? const Color(0xFFB5B5B5)
        : const Color(0xFF666666);

    final Color statusColor = isOpen
        ? const Color(0xFF2E9D55)
        : const Color(0xFFE53935);

    // ==========================================================
    // CARD
    // ==========================================================

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  isDark ? 0.28 : 0.06,
                ),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TOP IMAGE
              // ==================================================

              AspectRatio(
                aspectRatio: 1.35,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // IMAGE
                    isClosed
                        ? ColorFiltered(
                      colorFilter:
                      const ColorFilter.matrix(
                        <double>[
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0,
                          0,
                          0,
                          1,
                          0,
                        ],
                      ),
                      child:
                      MilestoneApp6Image(
                        url: image,
                        width:
                        double.infinity,
                        height:
                        double.infinity,
                        fit: BoxFit.cover,
                        borderRadius:
                        BorderRadius.zero,
                      ),
                    )
                        : MilestoneApp6Image(
                      url: image,
                      width:
                      double.infinity,
                      height:
                      double.infinity,
                      fit: BoxFit.cover,
                      borderRadius:
                      BorderRadius.zero,
                    ),

                    // =================================================
                    // CLOSED DARK OVERLAY
                    // =================================================

                    if (isClosed)
                      Container(
                        color: Colors.black
                            .withOpacity(0.28),
                      ),

                    // =================================================
                    // OPEN / CLOSED BADGE
                    // =================================================

                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black
                              .withOpacity(0.72),
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration:
                              BoxDecoration(
                                color: isOpen
                                    ? Colors
                                    .greenAccent
                                    : Colors
                                    .redAccent,
                                shape:
                                BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isOpen
                                  ? 'OPEN'
                                  : 'CLOSED',
                              style:
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight:
                                FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // ALL CONTENT BELOW IMAGE
              // ==================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  10,
                  9,
                  10,
                  11,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    // ==============================================
                    // RESTAURANT NAME + FAVOURITE
                    // ==============================================

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name.trim().isEmpty
                                ? 'Restaurant'
                                : name.trim(),
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: TextStyle(
                              color: titleColor,
                              fontSize: 14,
                              fontWeight:
                              FontWeight.w700,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          isOpen
                              ? Icons
                              .check_circle_rounded
                              : Icons
                              .storefront_outlined,
                          size: 13,
                          color: statusColor,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          isOpen ? 'Open' : 'Closed',
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 10.5,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),

                        if (distance.trim().isNotEmpty) ...[
                          const SizedBox(width: 7),

                          Text(
                            '│',
                            style: TextStyle(
                              color: secondaryColor
                                  .withOpacity(.45),
                              fontSize: 10,
                            ),
                          ),

                          const SizedBox(width: 7),

                          const Icon(
                            Icons
                                .location_on_outlined,
                            size: 12,
                          ),

                          const SizedBox(width: 2),

                          Flexible(
                            child: Text(
                              distance.trim(),
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 10.5,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                          ),
                        ],

                        if (time.trim().isNotEmpty) ...[
                          const SizedBox(width: 7),

                          Flexible(
                            child: Text(
                              time.trim(),
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    // ==============================================
                    // ADDRESS
                    // ==============================================

                    if (address.trim().isNotEmpty) ...[
                      const SizedBox(height: 7),

                      Row(
                        children: [
                          Icon(
                            Icons
                                .location_city_outlined,
                            size: 12,
                            color: secondaryColor,
                          ),

                          const SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              address.trim(),
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 10,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // ==============================================
                    // CATEGORIES
                    // ==============================================

                    if (categories.trim().isNotEmpty) ...[
                      const SizedBox(height: 7),

                      Text(
                        categories.trim(),
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 10,
                          height: 1.2,
                        ),
                      ),
                    ],
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