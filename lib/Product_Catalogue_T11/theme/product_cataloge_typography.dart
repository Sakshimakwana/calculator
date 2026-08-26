import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/Product_Catalogue_T11/theme/product_catalogue_colors.dart' ;

class AppTypography1 {
  static const title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors1.text,
  );

  static final productName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors1.text,
  );

  static const price = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors1.primary,
  );

  static const rating = TextStyle(
    fontSize: 12,
    color: AppColors1.grey,
  );

  static const body = TextStyle(
    fontSize: 13,
    color: AppColors1.grey,
  );
}