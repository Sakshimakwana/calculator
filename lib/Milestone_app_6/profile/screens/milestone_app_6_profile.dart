import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/widgets/logout_dialog.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/widgets/profile_action_item.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/widgets/profile_header.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/widgets/profile_logout_loading.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/widgets/profile_menu_item.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/widgets/profile_theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../my_reviews/screens/my_reviews_screen.dart';
import '../../Login/data/auth_controller/auth_controller.dart';
import '../../theme/milestone_app_6_colors.dart';
import '../../state/milestone_app_6_state.dart';

class MilestoneApp6ProfileScreen extends StatelessWidget {
  final MilestoneApp6State state;

  const MilestoneApp6ProfileScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme
              .of(context)
              .scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Theme
                .of(context)
                .scaffoldBackgroundColor,
            leadingWidth: 80,
            leading: TextButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(
                Icons.chevron_left_rounded,
                size: 27,
                color: MilestoneApp6Colors.orange,
              ),
              label: const Text(
                'Home',
                style: TextStyle(
                  color: MilestoneApp6Colors.orange,
                  fontSize: 14,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
            ),
            centerTitle: true,
            title: const Text(
              'Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const MilestoneApp6ProfileHeader(),

                const SizedBox(height: 2),


                _sectionTitle(context, 'My Account'),

                MilestoneApp6ProfileMenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'My Orders',
                  onTap: () => context.push('/my-orders'),
                ),

                MilestoneApp6ProfileMenuItem(
                  icon: Icons.star_border_rounded,
                  title: 'My Reviews',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const MilestoneApp6MyReviewsScreen(),
                      ),
                    );
                  },
                ),

                _sectionTitle(context, 'Preferences'),
                MilestoneApp6ProfileThemeSwitch(
                  state: state,
                ),

                const SizedBox(height: 100),

                // Logout — retains the existing confirmation and API.
                _logoutButton(context),

                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 10,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme
              .of(context)
              .hintColor,
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return SizedBox(
        height: 54,
        child: ElevatedButton.icon(
          onPressed: () async {
            final shouldLogout = await MilestoneApp6LogoutDialog.show(
              context,
            );

            if (shouldLogout && context.mounted) {
              await _logout(context);
            }
          },
          icon: const Icon(
            Icons.logout_rounded,
            size: 21,
          ),
          label: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF70452F), // Primary brown
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),)
    );
  }

  Future<void> _logout(BuildContext context) async {
    final authController = context.read<AuthController>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const MilestoneApp6ProfileLogoutLoading(),
    );

    try {
      await authController.logout();

      if (!context.mounted) return;

      Navigator.of(context, rootNavigator: true).pop();
      context.go('/login');
    } catch (e) {
      if (!context.mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
        ),
      );
    }
  }
}