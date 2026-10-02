import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MilestoneApp6RestaurantShimmer extends StatelessWidget {
  const MilestoneApp6RestaurantShimmer({
    super.key,
    this.itemCount = 6,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        return MilestoneApp6RestaurantShimmerCard(
          isDark: isDark,
        );
      },
    );
  }
}

class MilestoneApp6RestaurantShimmerCard
    extends StatelessWidget {
  const MilestoneApp6RestaurantShimmerCard({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = isDark
        ? Colors.grey.shade800
        : Colors.grey.shade300;

    final Color highlightColor = isDark
        ? Colors.grey.shade700
        : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey.shade900
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.35,
              child: Container(
                width: double.infinity,
                color: Colors.white,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                10,
                9,
                10,
                10,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 15,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(5),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Container(
                        height: 11,
                        width: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(5),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        height: 11,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Container(
                    height: 11,
                    width: 95,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(5),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    height: 11,
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}