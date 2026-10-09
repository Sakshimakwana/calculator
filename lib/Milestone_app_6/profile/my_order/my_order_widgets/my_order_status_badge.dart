import 'package:flutter/material.dart';

class MyOrderStatusBadge extends StatelessWidget {
  final String status;

  const MyOrderStatusBadge({
    super.key,
    required this.status,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'placed':
      case 'preparing':
        return const Color(0xFFE67E22);

      case 'out_for_delivery':
        return const Color(0xFF3B82F6);

      case 'delivered':
        return const Color(0xFF16A34A);

      case 'cancelled':
        return const Color(0xFFD62828);

      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    if (status.isEmpty) {
      return 'Unknown';
    }

    return status
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}'
                  '${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.20),
        ),
      ),
      child: Text(
        _formatStatus(status),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}
