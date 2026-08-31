import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/theme/form_preferance_colors.dart';

class VolumeSlider extends StatelessWidget {
  const VolumeSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.volume_down_outlined,
          size: 24,
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Semantics(
            label: 'Volume',
            value: '${value.round()} percent',
            child: Slider(
              value: value,
              min: 0,
              max: 100,
              divisions: 100,
              activeColor: AppColors.pink,
              inactiveColor: Colors.grey.shade300,
              onChanged: onChanged,
            ),
          ),
        ),

        const SizedBox(width: 6),

        SizedBox(
          width: 38,
          child: Text(
            '${value.round()}%',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}