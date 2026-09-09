import 'package:app_matic_tech_flutter_app/shoppingflow_T19/widgets/shoppingflow_product_model.dart';
import 'package:flutter/material.dart';

class ShoppingFlowProducts {
  ShoppingFlowProducts._();

  static const List<ShoppingFlowProduct> products = [
    ShoppingFlowProduct(
      id: 1,
      name: 'Travel Backpack',
      description:
      'A comfortable and spacious backpack suitable for travel and daily use.',
      price: 1499,
      rating: 4.5,
      image:
      'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800',
    ),

    ShoppingFlowProduct(
      id: 2,
      name: 'Running Shoes',
      description:
      'Lightweight running shoes designed for comfortable everyday running.',
      price: 2499,
      rating: 4.7,
      image:
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
    ),

    ShoppingFlowProduct(
      id: 3,
      name: 'Smart Watch',
      description:
      'Modern smartwatch with fitness tracking and notification support.',
      price: 3999,
      rating: 4.6,
      image:
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
    ),

    ShoppingFlowProduct(
      id: 4,
      name: 'Wireless Headphones',
      description:
      'Wireless headphones with comfortable ear cushions and clear sound.',
      price: 2999,
      rating: 4.4,
      image:
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
    ),

    ShoppingFlowProduct(
      id: 5,
      name: 'Classic Watch',
      description:
      'Elegant classic watch suitable for office, casual and formal occasions.',
      price: 1899,
      rating: 4.3,
      image:
      'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=800',
    ),

    ShoppingFlowProduct(
      id: 6,
      name: 'Sunglasses',
      description:
      'Stylish sunglasses with a lightweight frame for everyday outdoor use.',
      price: 999,
      rating: 4.2,
      image:
      'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800',
    ),
  ];
}