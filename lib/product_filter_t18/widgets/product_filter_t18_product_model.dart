import 'package:flutter/material.dart';

class ProductFilterT18ProductModel {
  final int id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final int reviews;
  final bool inStock;
  final String imageUrl;

  const ProductFilterT18ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.inStock,
    required this.imageUrl,
  });
}