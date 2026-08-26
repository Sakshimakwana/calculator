import 'package:flutter/material.dart';
import '../theme/pricing_colors.dart';

class PricingToggle extends StatelessWidget {
  const PricingToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.90,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: PricingColors.border,
          ),
          borderRadius: BorderRadius.circular(30),
          color: PricingColors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PricingColors.purple,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Monthly',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Yearly',
                    style: TextStyle(
                      fontSize: 16,
                      color: PricingColors.darkText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: PricingColors.purpleLight,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      '20% OFF',
                      style: TextStyle(
                        color: PricingColors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}