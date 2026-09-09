import 'package:flutter/material.dart';

import '../theme/product_filter_t18_typography.dart';

class ProductFilterT18SortDialog extends StatelessWidget {
  const ProductFilterT18SortDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        'Sort By',
        style: ProductFilterT18Typography.title,
      ),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(
              context,
              'Popularity',
            );
          },
          child: const Text('Popularity'),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(
              context,
              'Price: Low to High',
            );
          },
          child: const Text('Price: Low to High'),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(
              context,
              'Price: High to Low',
            );
          },
          child: const Text('Price: High to Low'),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(
              context,
              'Rating: High to Low',
            );
          },
          child: const Text('Rating: High to Low'),
        ),
      ],
    );
  }
}