import 'package:flutter/material.dart';
import 'product_details_header_colors.dart';

class ProductDetailsHeaderTypography {
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: ProductDetailsHeaderColors.black,
  );

  static const TextStyle price = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: ProductDetailsHeaderColors.black,
  );

  static const TextStyle oldPrice = TextStyle(
    fontSize: 16,
    color: ProductDetailsHeaderColors.greyText,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle discount = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: ProductDetailsHeaderColors.white,
  );

  static const TextStyle counter = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: ProductDetailsHeaderColors.white,
  );

  static const TextStyle reviews = TextStyle(
    fontSize: 15,
    color: ProductDetailsHeaderColors.greyText,
  );
}