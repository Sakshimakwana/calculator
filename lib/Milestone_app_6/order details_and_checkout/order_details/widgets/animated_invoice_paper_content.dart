
import 'package:flutter/material.dart';

class AnimatedInvoicePaperContent extends StatelessWidget {
  final Map<String, dynamic>? invoice;
  final Map<String, dynamic>? order;
  final Object? orderId;
  final bool invoicePdfReady;
  final String paymentMethod;

  const AnimatedInvoicePaperContent({
    super.key,
    required this.invoice,
    required this.order,
    required this.orderId,
    required this.invoicePdfReady,
    required this.paymentMethod,
  });

  Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  String _string(Map<String, dynamic> data, String key) {
    final value = data[key];
    return value == null ? '' : value.toString();
  }

  double? _doubleValue(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  int? _intValue(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final invoiceData = invoice ?? <String, dynamic>{};
    final orderData = order ?? <String, dynamic>{};

    final restaurant = _map(orderData['restaurant']);
    final customer = _map(orderData['customer']);
    final address = _map(orderData['delivery_address']);

    final restaurantValue = _string(restaurant, 'name');
    final restaurantName =
    restaurantValue.isNotEmpty ? restaurantValue : 'Restaurant';

    final invoiceValue = _string(invoiceData, 'invoice_number');
    final invoiceNumber = invoiceValue.isNotEmpty
        ? invoiceValue
        : 'INV-${orderId ?? '-'}';

    final orderValue = _string(orderData, 'id');
    final orderNumber =
    orderValue.isNotEmpty ? orderValue : orderId?.toString() ?? '-';

    final customerValue = _string(customer, 'full_name');
    final customerName = customerValue.isNotEmpty
        ? customerValue
        : _string(_map(invoiceData['user']), 'full_name');

    final city = _string(address, 'city');
    final state = _string(address, 'state');
    final addressLine = _string(address, 'address_line');

    final deliveryFee =
        _doubleValue(invoiceData['delivery_fee']) ??
            _doubleValue(orderData['delivery_fee']) ??
            0.0;

    final total =
        _doubleValue(invoiceData['total']) ??
            _doubleValue(orderData['total']) ??
            0.0;

    final List<dynamic> items = orderData['order_items'] is List
        ? List<dynamic>.from(orderData['order_items'] as List)
        : orderData['items'] is List
        ? List<dynamic>.from(orderData['items'] as List)
        : <dynamic>[];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'ORDER INVOICE',
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFE53950),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEF1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  size: 16,
                  color: Color(0xFFE53950),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),
          Container(height: 1, color: Colors.black12),
          const SizedBox(height: 5),

          // Order details
          _invoicePreviewRow('Invoice', invoiceNumber),
          _invoicePreviewRow('Order', '#$orderNumber'),
          _invoicePreviewRow(
            'Customer',
            customerName.isEmpty ? '-' : customerName,
          ),

          if (city.isNotEmpty || state.isNotEmpty)
            _invoicePreviewRow(
              'Location',
              [city, state].where((e) => e.isNotEmpty).join(', '),
            ),

          // Delivery address
          if (addressLine.isNotEmpty) ...[
            const SizedBox(height: 4),
            const Text(
              'DELIVERY ADDRESS',
              style: TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w900,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              [addressLine, city, state]
                  .where((e) => e.isNotEmpty)
                  .join(', '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 7.2,
                height: 1.15,
                color: Colors.black87,
              ),
            ),
          ],

          const SizedBox(height: 5),
          Container(height: 1, color: Colors.black12),
          const SizedBox(height: 5),

          // Items
          const Text(
            'ITEMS',
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w900,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 3),

          if (items.isNotEmpty)
            ...items.take(3).map((rawItem) {
              final item = _map(rawItem);
              final menuItem = _map(item['menu_item']);
              final name = _string(menuItem, 'name');

              final quantity = _intValue(item['quantity']) ?? 1;

              final price =
                  _doubleValue(item['price_at_purchase']) ??
                      _doubleValue(menuItem['price']) ??
                      0.0;

              final itemTotal =
                  _doubleValue(item['total_price']) ?? price * quantity;

              return _invoiceItemPreviewRow(
                name.isEmpty ? 'Food Item' : name,
                quantity,
                itemTotal,
              );
            })
          else
            const Text(
              'Food items',
              style: TextStyle(
                fontSize: 7.5,
                color: Colors.black87,
              ),
            ),

          const SizedBox(height: 4),
          Container(height: 1, color: Colors.black12),
          const SizedBox(height: 4),

          // Amounts
          _invoicePreviewAmountRow('Delivery', deliveryFee),
          _invoicePreviewAmountRow('Total', total, bold: true),

          const SizedBox(height: 4),

          // Payment status
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF2FFF6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 13,
                  color: Colors.green,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    paymentMethod,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 7.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Center(
            child: Text(
              invoicePdfReady
                  ? '✓ Invoice Ready'
                  : 'Generating invoice...',
              style: TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w800,
                color: invoicePdfReady ? Colors.green : Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _invoicePreviewRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 6.2,
                color: Colors.black45,
              ),
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 6.4,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _invoiceItemPreviewRow(
      String name,
      int quantity,
      double amount,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 6.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '×$quantity',
            style: const TextStyle(
              fontSize: 6.1,
              color: Colors.black45,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 6.3,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _invoicePreviewAmountRow(
      String title,
      double amount, {
        bool bold = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: bold ? 7 : 6.3,
                fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: bold ? 7.2 : 6.3,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
