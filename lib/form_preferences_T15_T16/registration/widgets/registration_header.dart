import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/theme/form_preferance_colors.dart';

class RegistrationHeader extends StatelessWidget {
  const RegistrationHeader({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 105,
            decoration: const BoxDecoration(
              color: AppColors.veryLightPink,
            ),
          ),

          Positioned(
            top: 22,
            left: 10,
            child: IconButton(
              onPressed: onBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 35,
                minHeight: 35,
              ),
              icon: const Icon(
                Icons.arrow_back,
                size: 25,
                color: Colors.black,
              ),
            ),
          ),

          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Fill in your details to get started',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}