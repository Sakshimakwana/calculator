import 'package:flutter/material.dart';

import '../theme/shoppingflow_T20_colors.dart';

class ShoppingFlowT20ProductImage extends StatelessWidget {
  final String image;
  final double height;

  const ShoppingFlowT20ProductImage({
    super.key,
    required this.image,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ShoppingFlowT20Colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Icon(Icons.image_outlined);
        },
      ),
    );
  }
}