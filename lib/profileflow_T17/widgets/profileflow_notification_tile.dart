import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_colors.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_typography.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: RegistrationColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: RegistrationColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.notifications_none_rounded,
              color: RegistrationColors.primary,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: RegistrationTypography.label,
                ),

                SizedBox(height: 4),

                Text(
                  'Receive updates about new\nfeatures and offers',
                  style: RegistrationTypography.body,
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor:
            RegistrationColors.primary,
          ),
        ],
      ),
    );
  }
}