import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyOrdersShimmer extends StatelessWidget {
  const MyOrdersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor =
        isDark ? const Color(0xFF252525) : const Color(0xFFEEEEEE);
    final highlightColor =
        isDark ? const Color(0xFF3A3A3A) : const Color(0xFFFAFAFA);

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth >= 700 ? 32.0 : 16.0;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                30,
              ),
              children: [
// Search bar skeleton
                _shimmerBox(
                  height: 54,
                  radius: 16,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
                const SizedBox(height: 22),

// Order card skeletons
                ...List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _orderCard(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      isDark: isDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _orderCard({
    required Color baseColor,
    required Color highlightColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF171717) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isDark ? Colors.white.withOpacity(0.07) : const Color(0xFFECECEC),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 15,
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
// Restaurant name and order status
            Row(
              children: [
                _shimmerBox(
                  width: 48,
                  height: 48,
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
                        radius: 6,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                      const SizedBox(height: 9),
                      _shimmerBox(
                        width: 100,
                        height: 11,
                        radius: 5,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                    ],
                  ),
                ),
                _shimmerBox(
                  width: 85,
                  height: 28,
                  radius: 20,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
              ],
            ),

            const SizedBox(height: 18),
            Divider(
              height: 1,
              color: isDark ? Colors.white12 : const Color(0xFFECECEC),
            ),
            const SizedBox(height: 16),

// Ordered items
            Row(
              children: [
                _shimmerBox(
                  width: 64,
                  height: 64,
                  radius: 12,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(
                        width: 145,
                        height: 13,
                        radius: 5,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                      const SizedBox(height: 10),
                      _shimmerBox(
                        width: 95,
                        height: 11,
                        radius: 5,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                      const SizedBox(height: 10),
                      _shimmerBox(
                        width: 75,
                        height: 11,
                        radius: 5,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

// Total and action buttons
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(
                        width: 65,
                        height: 10,
                        radius: 4,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                      const SizedBox(height: 8),
                      _shimmerBox(
                        width: 90,
                        height: 16,
                        radius: 5,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                    ],
                  ),
                ),
                _shimmerBox(
                  width: 105,
                  height: 38,
                  radius: 12,
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
