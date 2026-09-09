import 'package:flutter/material.dart';

import '../theme/product_filter_t18_colors.dart';
import '../theme/product_filter_t18_typography.dart';

class ProductFilterT18DeleteDialog extends StatelessWidget {
  const ProductFilterT18DeleteDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const CircleAvatar(
        radius: 28,
        backgroundColor: ProductFilterT18Colors.delete,
        child: Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 30,
        ),
      ),
      title: const Text(
        'Delete Product',
        textAlign: TextAlign.center,
        style: ProductFilterT18Typography.title,
      ),
      content: Text(
        'Are you sure you want to delete this product?\n'
            'This action cannot be undone.',
        textAlign: TextAlign.center,
        style: ProductFilterT18Typography.title,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text(
            'DELETE',
            style: TextStyle(
              color: ProductFilterT18Colors.delete,
            ),
          ),
        ),
      ],
    );
  }
}