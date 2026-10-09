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
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.go('/home');
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: const Text(
              'Profile',
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              20,
            ),
            children: [
// ----------------------------------------------------------
// PROFILE HEADER
// ----------------------------------------------------------

              const MilestoneApp6ProfileHeader(),

              const SizedBox(
                height: 12,
              ),

// ----------------------------------------------------------
// MY ORDERS
// ----------------------------------------------------------

              MilestoneApp6ProfileMenuItem(
                icon: Icons.receipt_long_outlined,
                title: 'My Orders',
                onTap: () {
                  context.push('/my-orders');
                },
              ),

// ----------------------------------------------------------
// MY REVIEWS
// ----------------------------------------------------------

              MilestoneApp6ProfileMenuItem(
                icon: Icons.rate_review_outlined,
                title: 'My Reviews',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MilestoneApp6MyReviewsScreen(),
                    ),
                  );
                },
              ),

// ----------------------------------------------------------
// PAYMENT METHODS
// ----------------------------------------------------------

              MilestoneApp6ProfileActionItem(
                icon: Icons.credit_card_outlined,
                title: 'Payment Methods',
                message: 'Payment Methods coming soon.',
              ),

// ----------------------------------------------------------
// THEME
// ----------------------------------------------------------

              MilestoneApp6ProfileThemeSwitch(
                state: state,
              ),

// ----------------------------------------------------------
// SETTINGS
// ----------------------------------------------------------

              MilestoneApp6ProfileActionItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                message: 'Settings coming soon.',
              ),

// ----------------------------------------------------------
// LOGOUT
// ----------------------------------------------------------

              MilestoneApp6ProfileMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () async {
                  final shouldLogout = await MilestoneApp6LogoutDialog.show(
                    context,
                  );

                  if (shouldLogout) {
                    await _logout(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    final authController = context.read<AuthController>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const MilestoneApp6ProfileLogoutLoading();
      },
    );

    try {
      // Call logout API
      await authController.logout();

      if (!context.mounted) return;

      // Close loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      // Navigate to login and remove previous navigation history
      context.go('/login');
    } catch (e) {
      if (!context.mounted) return;

      // Close loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
        ),
      );
    }
  }
}
