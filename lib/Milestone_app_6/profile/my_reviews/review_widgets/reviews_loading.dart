import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MilestoneApp6ReviewsLoading extends StatelessWidget {
  const MilestoneApp6ReviewsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor =
        isDark ? const Color(0xFF292929) : const Color(0xFFEAEAEA);

    final highlightColor =
        isDark ? const Color(0xFF414141) : const Color(0xFFF8F8F8);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 25, 28, 30),
      children: [
// Header skeleton
        _shimmerBox(
          width: 175,
          height: 23,
          radius: 7,
          baseColor: baseColor,
          highlightColor: highlightColor,
        ),
        const SizedBox(height: 10),
        _shimmerBox(
          width: 235,
          height: 13,
          radius: 5,
          baseColor: baseColor,
          highlightColor: highlightColor,
        ),
        const SizedBox(height: 25),

// Review card skeletons
        ...List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _reviewCard(
              baseColor: baseColor,
              highlightColor: highlightColor,
              isDark: isDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _reviewCard({
    required Color baseColor,
    required Color highlightColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF171717) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEDEDED),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        period: const Duration(milliseconds: 1400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
// Restaurant image and name
            Row(
              children: [
                _shimmerBox(
                  width: 52,
                  height: 52,
                  radius: 14,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(
                        width: 155,
                        height: 15,
                        radius: 5,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                      const SizedBox(height: 9),
                      _shimmerBox(
                        width: 105,
                        height: 11,
                        radius: 5,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                    ],
                  ),
                ),
                _shimmerBox(
                  width: 62,
                  height: 25,
                  radius: 8,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
              ],
            ),

            const SizedBox(height: 20),

// Star rating skeleton
            Row(
              children: List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: _shimmerBox(
                    width: 17,
                    height: 17,
                    radius: 4,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 17),

// Review text skeleton
            _shimmerBox(
              height: 12,
              radius: 5,
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
            const SizedBox(height: 9),
            _shimmerBox(
              width: double.infinity,
              height: 12,
              radius: 5,
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
            const SizedBox(height: 9),
            _shimmerBox(
              width: 185,
              height: 12,
              radius: 5,
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),

            const SizedBox(height: 20),

            Divider(
              height: 1,
              color: isDark ? Colors.white12 : const Color(0xFFECECEC),
            ),

            const SizedBox(height: 15),

// Bottom action skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _shimmerBox(
                  width: 95,
                  height: 12,
                  radius: 5,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
                _shimmerBox(
                  width: 75,
                  height: 32,
                  radius: 9,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({
    double? width,
    required double height,
    required double radius,
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
