import 'package:flutter/material.dart';

class MilestoneApp6OrderHeroHeader extends StatelessWidget {
  final String orderId;
  final String createdAt;
  final String status;
  final String formattedDate;
  final Widget statusPill;

  const MilestoneApp6OrderHeroHeader({
    super.key,
    required this.orderId,
    required this.createdAt,
    required this.status,
    required this.formattedDate,
    required this.statusPill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEF5B6B),
            Color(0xFFE84458),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF5B6B).withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order placed successfully',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Order #$orderId',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (createdAt.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          statusPill,
        ],
      ),
    );
  }
}
