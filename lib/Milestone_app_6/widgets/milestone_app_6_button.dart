import 'package:flutter/material.dart';

import '../theme/milestone_app_6_colors.dart';

class MilestoneApp6Button extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const MilestoneApp6Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,

      child: ElevatedButton.icon(
        onPressed: onPressed,

        icon: icon == null
            ? const SizedBox.shrink()
            : Icon(
          icon,
          size: 18,
        ),

        label: Text(label),

        style: ElevatedButton.styleFrom(
          backgroundColor:
          MilestoneApp6Colors.orange,

          foregroundColor: Colors.white,

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),

          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}