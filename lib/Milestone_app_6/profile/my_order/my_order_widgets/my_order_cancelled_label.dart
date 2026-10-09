import 'package:flutter/material.dart';

class MyOrderCancelledLabel extends StatelessWidget {
  const MyOrderCancelledLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 34,
      width: 117,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3A1717) : const Color(0xFFFFEAEA),
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Text(
        'Order Cancelled',
        style: TextStyle(
          color: Color(0xFFD62828),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
