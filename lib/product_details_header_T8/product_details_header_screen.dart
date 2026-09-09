import 'package:app_matic_tech_flutter_app/product_details_header_T8/theme/product_details_header_colors.dart';
import 'package:app_matic_tech_flutter_app/product_details_header_T8/widgets/product_details.dart';
import 'package:app_matic_tech_flutter_app/product_details_header_T8/widgets/product_header.dart';
import 'package:flutter/material.dart';


class ProductDetailsHeaderScreen extends StatelessWidget {
  const ProductDetailsHeaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProductDetailsHeaderColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              ProductHeader(),
              ProductDetails(),
            ],
          ),
        ),
      ),
    );
  }
}