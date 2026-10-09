import 'package:flutter/material.dart';

class MilestoneApp6OrderPaymentCard extends StatelessWidget {
  final Map<String, dynamic>? order;
  final String paymentType;

  const MilestoneApp6OrderPaymentCard({
    super.key,
    required this.order,
    required this.paymentType,
  });

  Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  String _string(Map<String, dynamic>? map, String key) {
    return map?[key]?.toString().trim() ?? '';
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  String _formatPaymentMethod(String value) {
    final normalized = value.trim().toLowerCase();

    switch (normalized) {
      case 'cod':
      case 'cash_on_delivery':
      case 'cash on delivery':
        return 'Cash on Delivery';
      case 'razorpay':
      case 'online':
        return 'Online Payment';
      default:
        return value
            .replaceAll('_', ' ')
            .split(' ')
            .where((part) => part.isNotEmpty)
            .map(_capitalize)
            .join(' ');
    }
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE8E9EC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEDF0),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 19,
            color: const Color(0xFFEF5B6B),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final backendPayment = _map(order?['order_payment']);

    final backendMethod = _string(
      backendPayment,
      'method',
    );

// Use the checkout-selected method when the backend
// does not return a payment method.
    final selectedMethod = backendMethod.isNotEmpty
        ? _formatPaymentMethod(backendMethod)
        : paymentType.trim().isNotEmpty
            ? paymentType.trim()
            : 'Payment';

    final backendStatus = _string(
      backendPayment,
      'status',
    );

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.account_balance_wallet_outlined,
            'Payment Details',
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE9ED),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    selectedMethod.toLowerCase().contains('cash')
                        ? Icons.payments_outlined
                        : Icons.credit_card_rounded,
                    color: const Color(0xFFEF5B6B),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        selectedMethod,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (backendStatus.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Status: ${_capitalize(backendStatus)}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF238B45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          Text(
            selectedMethod.toLowerCase().contains('cash')
                ? 'You will pay when your order is delivered.'
                : 'Your selected online payment method is shown here.',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
