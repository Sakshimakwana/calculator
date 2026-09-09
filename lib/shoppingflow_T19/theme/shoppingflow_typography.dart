import 'package:flutter/material.dart';
import 'shoppingflow_colors.dart';

class ShoppingFlowTypography {
  ShoppingFlowTypography._();

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: ShoppingFlowColors.black,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: ShoppingFlowColors.black,
  );

  static const TextStyle productName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: ShoppingFlowColors.black,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ShoppingFlowColors.grey,
  );

  static const TextStyle price = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: ShoppingFlowColors.price,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: ShoppingFlowColors.white,
  );

  static const TextStyle success = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: ShoppingFlowColors.success,
  );
}