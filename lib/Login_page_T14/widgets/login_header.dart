import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/Login_page_T14/theme/login_typogarphy.dart';
import 'package:app_matic_tech_flutter_app/Login_page_T14/theme/login_app_colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 150,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
              ),

              const Icon(
                Icons.shield,
                size: 120,
                color: AppColors.primary,
              ),

              const Icon(
                Icons.lock,
                size: 50,
                color: AppColors.white,
              ),
            ],
          ),
        ),


        const Text(
          'Welcome Back',
          style: AppTypography.title,
        ),

        const Text(
          'Login to continue to your account',
          style: AppTypography.subtitle,
        ),
      ],
    );
  }
}