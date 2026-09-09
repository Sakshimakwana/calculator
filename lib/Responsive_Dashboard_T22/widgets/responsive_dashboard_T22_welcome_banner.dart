import 'package:flutter/material.dart';

class ResponsiveDashboardT22WelcomeBanner extends StatelessWidget {
  const ResponsiveDashboardT22WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5269F4),
            Color(0xFF7773F4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Good Morning!',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Stay organized and achieve\nmore today.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .16),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              size: 38,
              color: Color(0xFFFFD15C),
            ),
          ),
        ],
      ),
    );
  }
}