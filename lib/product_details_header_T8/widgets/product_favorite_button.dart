import 'package:flutter/material.dart';

import '../theme/product_details_header_colors.dart';


class ProductFavoriteButton extends StatelessWidget {
  const ProductFavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 20,
      right: 20,
      child: CircleAvatar(
        radius: 25,
        backgroundColor:
        ProductDetailsHeaderColors.buttonBackground,
        child: Icon(
          Icons.favorite,
          color: ProductDetailsHeaderColors.favorite,
        ),
      ),
    );
  }
}
