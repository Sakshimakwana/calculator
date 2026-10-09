import 'package:flutter/material.dart';

class MilestoneApp6OrderRestaurantCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String address;

  const MilestoneApp6OrderRestaurantCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.address,
  });

  Widget _networkImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        width: 68,
        height: 68,
        child: imageUrl.isEmpty
            ? const ColoredBox(
                color: Color(0xFFF1F1F1),
                child: Icon(
                  Icons.restaurant_rounded,
                  color: Colors.grey,
                  size: 30,
                ),
              )
            : Image.network(
                imageUrl,
                width: 68,
                height: 68,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const ColoredBox(
                    color: Color(0xFFF1F1F1),
                    child: Icon(
                      Icons.restaurant_rounded,
                      color: Colors.grey,
                      size: 30,
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (name.isEmpty && imageUrl.isEmpty && address.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(18),
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
          Row(
            children: [
              const Icon(
                Icons.storefront_rounded,
                color: Color(0xFFEF5B6B),
              ),
              const SizedBox(width: 9),
              const Text(
                'Restaurant',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _networkImage(),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty ? 'Restaurant' : name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (address.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
