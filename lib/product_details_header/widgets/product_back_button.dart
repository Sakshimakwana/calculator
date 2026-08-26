import 'package:flutter/material.dart';

import '../theme/product_details_header_colors.dart';


class ProductBackButton extends StatelessWidget {
  const ProductBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 20,
      left: 20,
      child: CircleAvatar(
        radius: 25,
        backgroundColor:
        ProductDetailsHeaderColors.buttonBackground,
        child: Icon(
          Icons.arrow_back,
          color: ProductDetailsHeaderColors.white,
        ),
      ),
    );
  }
}