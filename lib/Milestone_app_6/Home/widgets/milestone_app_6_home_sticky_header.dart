import 'package:flutter/material.dart';

class MilestoneApp6HomeStickyHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  const MilestoneApp6HomeStickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: overlapsContent ? 3 : 0,
      shadowColor: Colors.black.withOpacity(.12),
      child: child,
    );
  }

  @override
  bool shouldRebuild(
      covariant MilestoneApp6HomeStickyHeaderDelegate
      oldDelegate,
      ) {
    return minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight ||
        child != oldDelegate.child;
  }
}