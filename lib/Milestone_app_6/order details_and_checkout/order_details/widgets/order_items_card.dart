import 'package:flutter/material.dart';

class MilestoneApp6OrderItemsCard extends StatelessWidget {
  final dynamic orderItems;

  const MilestoneApp6OrderItemsCard({
    super.key,
    required this.orderItems,
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

  int? _intValue(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  double? _doubleValue(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
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

  Widget _sectionTitle(
    IconData icon,
    String title, {
    String? trailing,
  }) {
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
        if (trailing != null)
          Text(
            trailing,
            style: const TextStyle(
              fontSize: 11.5,
              color: Colors.black45,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _networkImage(
    String url, {
    required double width,
    required double height,
    required double radius,
    required IconData fallbackIcon,
  }) {
    final imageUrl = url.trim();

    if (imageUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F1F3),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Icon(
          fallbackIcon,
          color: Colors.black38,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF0F1F3),
            child: Icon(
              fallbackIcon,
              color: Colors.black38,
            ),
          );
        },
      ),
    );
  }

  Widget _itemTile(Map<String, dynamic> item) {
    final menuItem = _map(item['menu_item']);

    final String name = _string(menuItem, 'name');
    final String image = _string(menuItem, 'image_url');

    final int quantity = _intValue(item['quantity']) ?? 1;

    final double price = _doubleValue(item['price_at_purchase']) ??
        _doubleValue(menuItem['price']) ??
        0;

    final double total = _doubleValue(item['total_price']) ?? price * quantity;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE9EAED),
        ),
      ),
      child: Row(
        children: [
          _networkImage(
            image,
            width: 70,
            height: 70,
            radius: 13,
            fallbackIcon: Icons.fastfood_rounded,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'Food item' : name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '₹${price.toStringAsFixed(2)} × $quantity',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '₹${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawItems = orderItems;

    final List<Map<String, dynamic>> items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList()
        : <Map<String, dynamic>>[];

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.shopping_bag_outlined,
            'Ordered Items',
            trailing: '${items.length} item${items.length == 1 ? '' : 's'}',
          ),
          const SizedBox(height: 15),
          if (items.isEmpty)
            const Text(
              'No ordered items found.',
              style: TextStyle(
                color: Colors.black54,
              ),
            )
          else
            ...List.generate(
              items.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == items.length - 1 ? 0 : 10,
                ),
                child: _itemTile(items[index]),
              ),
            ),
        ],
      ),
    );
  }
}
