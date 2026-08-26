import 'package:flutter/material.dart';
import '../theme/calculator_typography.dart';

class CalculatorDisplay extends StatelessWidget {
  final String value;

  const CalculatorDisplay({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 24,
          bottom: 12,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            value,
            style: CalculatorTypography.display,
          ),
        ),
      ),
    );
  }
}