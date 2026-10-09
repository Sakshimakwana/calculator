import 'package:flutter/material.dart';

class MyOrderReviewSubmittedLabel extends StatelessWidget {
  const MyOrderReviewSubmittedLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 38,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF12351F) : const Color(0xFFEFFFF4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_rounded,
              size: 16,
              color: Color(0xFF00A651),
            ),
            SizedBox(width: 5),
            Text(
              'Review Submitted',
              style: TextStyle(
                color: Color(0xFF00A651),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
