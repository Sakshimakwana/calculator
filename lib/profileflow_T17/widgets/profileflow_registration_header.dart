import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_colors.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_typography.dart';
class RegistrationHeader extends StatelessWidget {
  const RegistrationHeader({
    super.key,
    required this.onBack,
    required this.step,
  });

  final VoidCallback onBack;
  final int step;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 19,
              ),
              color: RegistrationColors.text,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

            const Spacer(),

            Text(
              'Step $step of 4',
              style: RegistrationTypography.subtitle,
            ),

            const Spacer(),

            const SizedBox(width: 19),
          ],
        ),

        const SizedBox(height: 18),

        Row(
          children: List.generate(
            4,
                (index) {
              final active = index < step;

              return Expanded(
                child: Container(
                  height: 3,
                  margin: EdgeInsets.only(
                    right: index == 3 ? 0 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? RegistrationColors.primary
                        : RegistrationColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}