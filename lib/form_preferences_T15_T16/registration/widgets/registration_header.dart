import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/theme/form_preferance_colors.dart';

class RegistrationHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const RegistrationHeader({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 90,
      backgroundColor: AppColors.veryLightPink,
      elevation: 0,
      centerTitle: true,

      leading: IconButton(
        onPressed: onBack,
        icon: const Icon(
          Icons.arrow_back,
          size: 25,
          color: Colors.black,
        ),
      ),

      title: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
    );
  }
}