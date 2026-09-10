import 'package:flutter/material.dart';

class ModernStoreHomeImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const ModernStoreHomeImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;

          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFF1F2F1),
            alignment: Alignment.center,
            child: const Icon(
              Icons.image_outlined,
              size: 42,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}