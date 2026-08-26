import 'package:flutter/material.dart';
import '../theme/calculator_colors.dart';

class CalculatorTopButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;

  const CalculatorTopButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: CalculatorColors.topButton,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}