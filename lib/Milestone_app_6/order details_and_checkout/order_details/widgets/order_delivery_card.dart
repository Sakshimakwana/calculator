import 'package:flutter/material.dart';

class MilestoneApp6OrderDeliveryCard extends StatelessWidget {
  final Map<String, dynamic>? order;

  const MilestoneApp6OrderDeliveryCard({
    super.key,
    required this.order,
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

  String _addressText(Map<String, dynamic> address) {
    final parts = <String>[];

    final addressLine = _string(address, 'address_line');
    final city = _string(address, 'city');
    final state = _string(address, 'state');
    final pincode = _string(address, 'pincode');

    if (addressLine.isNotEmpty) parts.add(addressLine);
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    if (pincode.isNotEmpty) parts.add(pincode);

    return parts.join(', ');
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

  Widget _detailRow(
    IconData icon,
    String label,
    String value, {
    String? secondary,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 21,
          color: Colors.black54,
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (secondary != null && secondary.trim().isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  secondary,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.black54,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final address = _map(order?['delivery_address']);

    final customer = _map(order?['customer']).isNotEmpty
        ? _map(order?['customer'])
        : _map(order?['user']);

    final fullAddress = _addressText(address);
    final customerName = _string(customer, 'full_name');
    final phone = _string(customer, 'phone_number');
    final instructions = _string(order, 'delivery_instructions');

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.location_on_rounded,
            'Delivery Details',
          ),
          const SizedBox(height: 16),
          _detailRow(
            Icons.person_outline_rounded,
            'Customer',
            customerName.isEmpty ? 'Customer' : customerName,
            secondary: phone,
          ),
          const SizedBox(height: 15),
          _detailRow(
            Icons.home_outlined,
            address['label']?.toString().trim().isEmpty ?? true
                ? 'Delivery Address'
                : address['label'].toString(),
            fullAddress.isEmpty ? 'Address not available' : fullAddress,
          ),
          if (instructions.isNotEmpty) ...[
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F8),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.notes_rounded,
                    size: 19,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      instructions,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.black54,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
