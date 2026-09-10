import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationsShoppingLottie extends StatelessWidget {
  const AnimationsShoppingLottie({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/Shopping_cart.json',
      width: 260,
      height: 260,
      fit: BoxFit.contain,
      repeat: true,
      animate: true,
    );
  }
}