import 'package:flutter/material.dart';

import '../theme/instagram_style_ui_typography.dart';

class InstagramStyleUiProfileStats extends StatelessWidget {
  const InstagramStyleUiProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _InstagramStyleUiStat(
            value: '254',
            label: 'Posts',
          ),
          _InstagramStyleUiStat(
            value: '12.8K',
            label: 'Followers',
          ),
          _InstagramStyleUiStat(
            value: '312',
            label: 'Following',
          ),
        ],
      ),
    );
  }
}

class _InstagramStyleUiStat extends StatelessWidget {
  final String value;
  final String label;

  const _InstagramStyleUiStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: InstagramStyleUiTypography.statValue,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: InstagramStyleUiTypography.statLabel,
        ),
      ],
    );
  }
}