import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/milestone_app_6_state.dart';
import '../theme/milestone_app_6_colors.dart';

class MilestoneApp6ProfileScreen
    extends StatelessWidget {
  final MilestoneApp6State state;

  const MilestoneApp6ProfileScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final dark =
        state.themeMode ==
            ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go('/home');
          },

          icon:
          const Icon(
            Icons.arrow_back,
          ),
        ),

        title:
        const Text('Profile'),
      ),

      body: ListView(
        padding:
        const EdgeInsets.fromLTRB(
          20,
          18,
          20,
          30,
        ),

        children: [
          const CircleAvatar(
            radius: 44,

            backgroundColor:
            Color(0xFFFFE1D7),

            child: Icon(
              Icons.person,
              size: 54,
              color:
              MilestoneApp6Colors
                  .orange,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          const Text(
            'Sakshi Darji',

            textAlign:
            TextAlign.center,

            style:
            TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 3,
          ),

          Text(
            'sakshi@example.com',

            textAlign:
            TextAlign.center,

            style: TextStyle(
              color: Theme.of(
                context,
              ).hintColor,

              fontSize: 12,
            ),
          ),

          const SizedBox(
            height: 28,
          ),

          _item(
            context,
            Icons.receipt_long_outlined,
            'My Orders',
          ),

          _item(
            context,
            Icons.favorite_border,
            'Saved Restaurants',
          ),

          _item(
            context,
            Icons.credit_card_outlined,
            'Payment Methods',
          ),

          SwitchListTile(
            contentPadding:
            EdgeInsets.zero,

            secondary:
            const Icon(
              Icons.dark_mode_outlined,
            ),

            title:
            const Text('Theme'),

            subtitle:
            Text(
              dark ? 'Dark' : 'Light',
            ),

            value: dark,

            onChanged:
            state.setDarkMode,
          ),

          _item(
            context,
            Icons.settings_outlined,
            'Settings',
          ),

          _item(
            context,
            Icons.logout,
            'Logout',
          ),
        ],
      ),
    );
  }

  Widget _item(
      BuildContext context,
      IconData icon,
      String title,
      ) {
    return ListTile(
      contentPadding:
      EdgeInsets.zero,

      leading: Icon(
        icon,
        color:
        MilestoneApp6Colors
            .orange,
      ),

      title: Text(
        title,

        style:
        const TextStyle(
          fontSize: 13,
          fontWeight:
          FontWeight.w500,
        ),
      ),

      trailing:
      const Icon(
        Icons.chevron_right,
        size: 20,
      ),

      onTap: () {},
    );
  }
}