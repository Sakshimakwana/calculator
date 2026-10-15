import 'package:flutter/material.dart';

import '../../Login/auth_storage/auth_storage.dart';
import '../../theme/milestone_app_6_colors.dart';

class MilestoneApp6ProfileHeader extends StatelessWidget {
  const MilestoneApp6ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final name = AuthStorage.fullName.trim();
    final email = AuthStorage.email.trim();
    final phone = AuthStorage.phoneNumber.trim();

    final mutedColor = Theme.of(context).hintColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFE9E2),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 45,
                  color: MilestoneApp6Colors.orange,
                ),
              ),
              Positioned(
                bottom: 0,
                right: -2,
                child: Container(
                  width: 37,
                  height: 37,
                  decoration: const BoxDecoration(
                    color: Color(0xFF60331F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            name.isNotEmpty ? name : 'User',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: Color(0xFF171717),
            ),
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              email,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: mutedColor,
              ),
            ),
          ],
          if (phone.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              phone,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: mutedColor,
              ),
            ),
          ],
          // const SizedBox(height: 13),
          // Container(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 16,
          //     vertical: 9,
          //   ),
          //   // decoration: BoxDecoration(
          //   //   color: const Color(0xFFFFF1E3),
          //   //   borderRadius: BorderRadius.circular(30),
          //   // ),
          //   // child: const Row(
          //   //   mainAxisSize: MainAxisSize.min,
          //   //   children: [
          //   //     Icon(
          //   //       Icons.workspace_premium_rounded,
          //   //       color: Color(0xFF60331F),
          //   //       size: 19,
          //   //     ),
          //   //     SizedBox(width: 8),
          //   //     Text(
          //   //       'Food Lover',
          //   //       style: TextStyle(
          //   //         color: Color(0xFF60331F),
          //   //         fontSize: 14,
          //   //         fontWeight: FontWeight.w600,
          //   //       ),
          //   //     ),
          //   //   ],
          //   // ),
          // ),
        ],
      ),
    );
  }
}