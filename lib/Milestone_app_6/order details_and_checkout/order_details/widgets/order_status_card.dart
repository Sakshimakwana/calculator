import 'package:flutter/material.dart';

class MilestoneApp6OrderStatusCard extends StatelessWidget {
  final String? orderStatus;
  final String? deliveryStatus;

  const MilestoneApp6OrderStatusCard({
    super.key,
    this.orderStatus,
    this.deliveryStatus,
  });

  String _normalize(String? status) {
    return (status ?? '')
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
  }

  int get _currentStep {
    final order = _normalize(orderStatus);
    final delivery = _normalize(deliveryStatus);

    // Delivered: all four steps are complete.
    if (order == 'delivered' || delivery == 'delivered') {
      return 3;
    }

    // Out for delivery.
    if (order == 'out_for_delivery' ||
        order == 'picked' ||
        order == 'picked_up' ||
        delivery == 'out_for_delivery' ||
        delivery == 'picked' ||
        delivery == 'picked_up') {
      return 2;
    }

    // Delivery partner assigned.
    if (order == 'assigned' ||
        order == 'partner_assigned' ||
        order == 'delivery_assigned' ||
        delivery == 'assigned' ||
        delivery == 'partner_assigned' ||
        delivery == 'delivery_assigned') {
      return 1;
    }

    // Default: order placed.
    return 0;
  }

  static const Color _red = Color(0xFFE9435F);
  static const Color _grey = Color(0xFFF1F1F1);

  static const List<_OrderStatusStep> _steps = [
    _OrderStatusStep(
      title: 'Order\nPlaced',
      shortTitle: 'Order Placed',
      icon: Icons.receipt_long_rounded,
    ),
    _OrderStatusStep(
      title: 'Partner\nAssigned',
      shortTitle: 'Partner Assigned',
      icon: Icons.delivery_dining_rounded,
    ),
    _OrderStatusStep(
      title: 'Out for\nDelivery',
      shortTitle: 'Out for Delivery',
      icon: Icons.two_wheeler_rounded,
    ),
    _OrderStatusStep(
      title: 'Delivered',
      shortTitle: 'Delivered',
      icon: Icons.home_rounded,
    ),
  ];

  static const List<String> _messages = [
    'Your order is confirmed',
    'A delivery partner has been assigned',
    'Your order is on the way',
    'Your order has been delivered',
  ];

  @override
  Widget build(BuildContext context) {
    final currentStep = _currentStep;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF171717),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Track your order in real time',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF929292),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 122,
            child: Stack(
              children: [
                Positioned(
                  left: 28,
                  right: 28,
                  top: 23,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9E9E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                if (currentStep > 0)
                  Positioned(
                    left: 28,
                    right: 28,
                    top: 23,
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: currentStep / 3,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: _red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_steps.length, (index) {
                    final isCompleted = index < currentStep;
                    final isCurrent = index == currentStep;
                    final isActive = index <= currentStep;

                    return Expanded(
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: isCurrent ? 48 : 44,
                            height: isCurrent ? 48 : 44,
                            decoration: BoxDecoration(
                              color: isActive ? _red : _grey,
                              shape: BoxShape.circle,
                              border: isCurrent
                                  ? Border.all(
                                color: const Color(0xFFFFC4CE),
                                width: 5,
                              )
                                  : null,
                              boxShadow: isCurrent
                                  ? [
                                BoxShadow(
                                  color: _red.withOpacity(0.22),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ]
                                  : null,
                            ),
                            child: Icon(
                              isCompleted
                                  ? Icons.check_rounded
                                  : _steps[index].icon,
                              size: 21,
                              color: isActive
                                  ? Colors.white
                                  : const Color(0xFF9B9B9B),
                            ),
                          ),
                          const SizedBox(height: 11),
                          SizedBox(
                            height: 34,
                            child: Text(
                              _steps[index].title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                height: 1.15,
                                fontWeight: isCurrent
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: isActive
                                    ? _red
                                    : const Color(0xFF888888),
                              ),
                            ),
                          ),
                          if (isCurrent)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEEF1),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: const Text(
                                'CURRENT',
                                style: TextStyle(
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.w900,
                                  color: _red,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7F8),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: const Color(0xFFFFDCE2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8EC),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: _red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _steps[currentStep].shortTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF202020),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _messages[currentStep],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8B8B8B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Color(0xFFAAAAAA),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderStatusStep {
  final String title;
  final String shortTitle;
  final IconData icon;

  const _OrderStatusStep({
    required this.title,
    required this.shortTitle,
    required this.icon,
  });
}