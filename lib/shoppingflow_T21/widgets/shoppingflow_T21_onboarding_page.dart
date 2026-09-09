import 'package:flutter/material.dart';

import '../theme/shoppingflow_T21_typography.dart';

class ShoppingFlowT21OnboardingData {
  final String image;
  final String title;
  final String description;

  const ShoppingFlowT21OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}

class ShoppingFlowT21OnboardingPage extends StatelessWidget {
  final ShoppingFlowT21OnboardingData data;

  const ShoppingFlowT21OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Image.asset(
              data.image,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            data.title,
            textAlign: TextAlign.center,
            style: ShoppingFlowT21Typography.onboardingTitle,
          ),

          const SizedBox(height: 10),

          Text(
            data.description,
            textAlign: TextAlign.center,
            style: ShoppingFlowT21Typography.onboardingDescription,
          ),

          const Spacer(),
        ],
      ),
    );
  }
}