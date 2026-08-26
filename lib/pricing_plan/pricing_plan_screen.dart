import 'package:flutter/material.dart';

import 'theme/pricing_colors.dart';
import 'theme/pricing_typography.dart';
import 'widgets/pricing_toggle.dart';
import 'widgets/pricing_plan_card.dart';

class PricingPlanScreen extends StatelessWidget {
  const PricingPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PricingColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),

          child: Column(
            children: [

              // Header
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Icon(
                      Icons.menu,
                      size: 32,
                      color: PricingColors.darkText,
                    ),
                  ),

                  const Text(
                    'Pricing Plans',
                    style: PricingTypography.title,
                  ),
                ],
              ),

              const SizedBox(height: 5),

              const Text(
                "Choose the plan that's right for you",
                style: PricingTypography.subtitle,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height:10),

              // Monthly / Yearly
              const PricingToggle(),

              const SizedBox(height: 15),

              // Free Plan
              PricingPlanCard(
                name: 'Free',
                price: '0',
                description: 'Forever free',
                icon: Icons.send_outlined,
                color: PricingColors.purple,
                lightColor: PricingColors.purpleLight,
                availableFeatures: [
                  'Basic Features',
                  '1 User',
                  'Community Support',
                ],
                unavailableFeatures: [
                  'Advanced Analytics',
                ],
                buttonText: 'Get Started',
              ),

              const SizedBox(height: 15),

              // Standard Plan
              PricingPlanCard(
                name: 'Standard',
                price: '9.99',
                description: 'Billed monthly',
                icon: Icons.star_outline,
                color: PricingColors.green,
                lightColor: PricingColors.greenLight,
                availableFeatures: [
                  'All Free Features',
                  '5 Users',
                  'Email Support',
                  'Basic Analytics',
                ],
                unavailableFeatures: [
                  'Priority Support',
                ],
                buttonText: 'Choose Plan',
              ),

              const SizedBox(height: 15),

              // Premium Plan
              PricingPlanCard(
                name: 'Premium',
                price: '19.99',
                description: 'Billed monthly',
                icon: Icons.workspace_premium_outlined,
                color: PricingColors.orange,
                lightColor: PricingColors.orangeLight,
                availableFeatures: [
                  'All Standard Features',
                  'Unlimited Users',
                  'Priority Support',
                  'Advanced Analytics',
                  'Custom Reports',
                  'Full Access',
                ],
                unavailableFeatures: [],
                buttonText: 'Choose Plan',
              ),

              const SizedBox(height: 28),

              // Guarantee
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    color: PricingColors.purple,
                  ),

                  const SizedBox(width: 10),

                  const Flexible(
                    child: Text(
                      '30-day money back guarantee',
                      style: PricingTypography.guarantee,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}