import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/Login_page_T14/theme/login_app_colors.dart';

class SocialLoginButton extends StatelessWidget {
  final Widget icon;

  const SocialLoginButton({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.lightBorder,
        ),
      ),
      child: Center(
        child: icon,
      ),
    );
  }
}