import 'package:flutter/material.dart';
import 'pricing_colors.dart';

class PricingTypography {
  static const TextStyle title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: PricingColors.darkText,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: PricingColors.greyText,
  );

  static const TextStyle planName = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: PricingColors.darkText,
  );

  static const TextStyle price = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle monthly = TextStyle(
    fontSize: 16,
    color: PricingColors.greyText,
  );

  static const TextStyle feature = TextStyle(
    fontSize: 15,
    color: PricingColors.darkText,
  );

  static const TextStyle button = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle guarantee = TextStyle(
    fontSize: 15,
    color: PricingColors.greyText,
  );
}