import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MilestoneApp6HomeCategoryShimmer extends StatelessWidget {
  final int itemCount;

  const MilestoneApp6HomeCategoryShimmer({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) {
        return const SizedBox(width: 10);
      },
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: isDark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
          highlightColor: isDark
              ? Colors.grey.shade700
              : Colors.grey.shade100,
          child: Container(
            width: 72,
            height: 74,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      },
    );
  }
}