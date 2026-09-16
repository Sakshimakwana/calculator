import 'package:flutter/material.dart';

class MilestoneApp6Image extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const MilestoneApp6Image({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,

      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,

        loadingBuilder: (
            context,
            child,
            progress,
            ) {
          if (progress == null) {
            return child;
          }

          return _placeholder(context);
        },

        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return _placeholder(context);
        },
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: width,
      height: height,

      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest,

      alignment: Alignment.center,

      child: Icon(
        Icons.restaurant_rounded,
        color: Theme.of(context)
            .colorScheme
            .onSurfaceVariant,
        size: 30,
      ),
    );
  }
}