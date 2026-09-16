import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MilestoneApp6DetailsShimmer
    extends StatelessWidget {
  const MilestoneApp6DetailsShimmer({
    super.key,
  });

  // ================================================================
  // SHIMMER BOX
  // ================================================================

  Widget _shimmerBox({
    double? width,
    required double height,
    double radius = 12,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(radius),
      ),
    );
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);

    final isDark =
        theme.brightness ==
            Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark
          ? const Color(0xFF292929)
          : const Color(0xFFE1E1E1),
      highlightColor: isDark
          ? const Color(0xFF3B3B3B)
          : const Color(0xFFF7F7F7),
      child: SingleChildScrollView(
        physics:
        const BouncingScrollPhysics(),
        child: Padding(
          padding:
          const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // ======================================================
              // IMAGE
              // ======================================================

              _shimmerBox(
                width: double.infinity,
                height: 280,
                radius: 22,
              ),

              const SizedBox(
                height: 20,
              ),

              // ======================================================
              // FOOD NAME
              // ======================================================

              _shimmerBox(
                width: 230,
                height: 27,
                radius: 7,
              ),

              const SizedBox(
                height: 10,
              ),

              // ======================================================
              // RESTAURANT
              // ======================================================

              _shimmerBox(
                width: 150,
                height: 17,
                radius: 6,
              ),

              const SizedBox(
                height: 18,
              ),

              // ======================================================
              // RATING
              // ======================================================

              _shimmerBox(
                width: 100,
                height: 32,
                radius: 9,
              ),

              const SizedBox(
                height: 18,
              ),

              // ======================================================
              // PRICE
              // ======================================================

              _shimmerBox(
                width: 105,
                height: 30,
                radius: 7,
              ),

              const SizedBox(
                height: 28,
              ),

              // ======================================================
              // DESCRIPTION TITLE
              // ======================================================

              _shimmerBox(
                width: 130,
                height: 21,
                radius: 7,
              ),

              const SizedBox(
                height: 12,
              ),

              // ======================================================
              // DESCRIPTION
              // ======================================================

              _shimmerBox(
                width: double.infinity,
                height: 14,
                radius: 5,
              ),

              const SizedBox(
                height: 8,
              ),

              _shimmerBox(
                width: double.infinity,
                height: 14,
                radius: 5,
              ),

              const SizedBox(
                height: 8,
              ),

              _shimmerBox(
                width: 250,
                height: 14,
                radius: 5,
              ),

              const SizedBox(
                height: 28,
              ),

              // ======================================================
              // SIZE TITLE
              // ======================================================

              _shimmerBox(
                width: 110,
                height: 21,
                radius: 7,
              ),

              const SizedBox(
                height: 12,
              ),

              // ======================================================
              // SIZE OPTIONS
              // ======================================================

              Row(
                children: [
                  Expanded(
                    child: _shimmerBox(
                      height: 68,
                      radius: 14,
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child: _shimmerBox(
                      height: 68,
                      radius: 14,
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child: _shimmerBox(
                      height: 68,
                      radius: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 28,
              ),

              // ======================================================
              // QUANTITY TITLE
              // ======================================================

              _shimmerBox(
                width: 100,
                height: 21,
                radius: 7,
              ),

              const SizedBox(
                height: 12,
              ),

              // ======================================================
              // QUANTITY
              // ======================================================

              _shimmerBox(
                width: 145,
                height: 42,
                radius: 11,
              ),

              const SizedBox(
                height: 30,
              ),

              // ======================================================
              // ADD TO CART
              // ======================================================

              _shimmerBox(
                width: double.infinity,
                height: 55,
                radius: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}