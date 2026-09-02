import 'package:flutter/material.dart';
import 'package:dotlottie_flutter/dotlottie_flutter.dart';

class LottieAnimation extends StatelessWidget {
  const LottieAnimation({
    super.key,
    required this.path,
    this.width = 300,
    this.height = 300,
    this.backgroundColor = Colors.transparent,
  });

  final String path;
  final int width;
  final int height;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.toDouble(),
      height: height.toDouble(),
      color: backgroundColor,
      child: DotLottieView(
        sourceType: 'asset',
        source: path,
        autoplay: true,
        loop: true,
        mode: 'forward',
        width: width,
        height: height,
      ),
    );
  }
}