import 'package:flutter/material.dart';
import '../../typography_profile/app_colors.dart';


class ContactPlaceholder extends StatelessWidget {
  const ContactPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundColor: Color(0xFFE3EDFF),
      child: Icon(
        Icons.person,
        color: AppColors.primary,
        size: 32,
      ),
    );
  }
}