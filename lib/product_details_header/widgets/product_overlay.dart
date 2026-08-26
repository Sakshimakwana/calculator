import 'package:flutter/material.dart';

import '../theme/product_details_header_colors.dart';


class ProductOverlay extends StatelessWidget {
  const ProductOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: ProductDetailsHeaderColors.overlay,
      ),
    );
  }
}