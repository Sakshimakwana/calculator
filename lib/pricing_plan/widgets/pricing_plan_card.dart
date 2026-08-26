import 'package:flutter/material.dart';
import '../theme/pricing_colors.dart';
import '../theme/pricing_typography.dart';
import 'pricing_feature_item.dart';

class PricingPlanCard extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final IconData icon;
  final Color color;
  final Color lightColor;
  final List<String> availableFeatures;
  final List<String> unavailableFeatures;
  final String buttonText;


  const PricingPlanCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.icon,
    required this.color,
    required this.lightColor,
    required this.availableFeatures,
    required this.unavailableFeatures,
    required this.buttonText,
  }
  );
  @override
  Widget build(BuildContext context) {
    double sizeheight= 250;
    return SizedBox(
      height: sizeheight,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: PricingColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 60,
                  decoration: BoxDecoration(
                    color: lightColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 12),

                // Name and description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: PricingTypography.planName.copyWith(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: PricingTypography.monthly.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$$price',
                      style: PricingTypography.price.copyWith(
                        color: color,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '/mo',
                      style: PricingTypography.monthly.copyWith(
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Divider(
              height: 4,
              color: PricingColors.border,
            ),

            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (availableFeatures.isNotEmpty)
                        PricingFeatureItem(
                          text: availableFeatures[0],
                          available: true,
                          color: color,
                        ),

                      const SizedBox(height: 2),

                      if (availableFeatures.length > 1)
                        PricingFeatureItem(
                          text: availableFeatures[1],
                          available: true,
                          color: color,
                        ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (availableFeatures.length > 2)
                        PricingFeatureItem(
                          text: availableFeatures[2],
                          available: true,
                          color: color,
                        ),

                      const SizedBox(height: 8),

                      if (unavailableFeatures.isNotEmpty)
                        PricingFeatureItem(
                          text: unavailableFeatures[0],
                          available: false,
                          color: color,
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 35,
              child: buttonText == 'Choose Plan'
                  ? ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: PricingTypography.button.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              )
                  : OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide(color: color),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: PricingTypography.button.copyWith(
                    color: color,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}