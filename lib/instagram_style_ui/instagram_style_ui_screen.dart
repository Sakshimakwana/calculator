import 'package:flutter/material.dart';

import 'widgets/instagram_style_ui_app_bar.dart';
import 'widgets/instagram_style_ui_bottom_nav.dart';
import 'widgets/instagram_style_ui_profile_action_buttons.dart';
import 'widgets/instagram_style_ui_profile_bio.dart';
import 'widgets/instagram_style_ui_profile_header.dart';
import 'widgets/instagram_style_ui_profile_highlights.dart';
import 'widgets/instagram_style_ui_profile_post_grid.dart';
import 'widgets/instagram_style_ui_profile_stats.dart';
import 'widgets/instagram_style_ui_profile_tab_bar.dart';

class InstagramStyleUiScreen extends StatelessWidget {
  const InstagramStyleUiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: const InstagramStyleUiAppBar(),

      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  InstagramStyleUiProfileHeader(),

                  SizedBox(width: 18),

                  Expanded(
                    child: InstagramStyleUiProfileStats(),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14),

            // Profile Bio
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: InstagramStyleUiProfileBio(),
            ),

            SizedBox(height: 14),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: InstagramStyleUiProfileActionButtons(),
            ),

            SizedBox(height: 20),
            InstagramStyleUiProfileHighlights(),
            SizedBox(height: 18),
            InstagramStyleUiProfileTabBar(),
            InstagramStyleUiProfilePostGrid(),
            SizedBox(height: 20),
          ],
        ),
      ),
           //bottomNavigationBar: const InstagramStyleUiBottomNav(),
    );
  }
}