import 'package:flutter/material.dart';

import '../../Login/auth_storage/auth_storage.dart';
import '../../theme/milestone_app_6_colors.dart';

class MilestoneApp6ProfileHeader extends StatelessWidget {
  const MilestoneApp6ProfileHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 44,
          backgroundColor: Color(0xFFFFE1D7),
          child: Icon(
            Icons.person,
            size: 54,
            color: MilestoneApp6Colors.orange,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          AuthStorage.fullName.isNotEmpty ? AuthStorage.fullName : 'User',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          AuthStorage.email.isNotEmpty
              ? AuthStorage.email
              : 'No email available',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        if (AuthStorage.phoneNumber.isNotEmpty)
          Text(
            AuthStorage.phoneNumber,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 12,
            ),
          ),
        const SizedBox(
          height: 28,
        ),
      ],
    );
  }
}