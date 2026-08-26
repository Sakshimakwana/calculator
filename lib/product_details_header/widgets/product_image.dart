import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.network(
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e'
            '?auto=format&fit=crop&w=1200&q=80',
        fit: BoxFit.cover,
      ),
    );
  }
}