import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/responsive_dashboard_T22_calendar_screen.dart';
import '../screens/responsive_dashboard_T22_profile_screen.dart';
import '../screens/responsive_dashboard_T22_screen.dart';
import '../screens/responsive_dashboard_T22_settings_screen.dart';
import '../screens/responsive_dashboard_T22_tasks_screen.dart';
import '../screens/responsive_dashboard_T22_page.dart';

GoRouter responsiveDashboardT22Router({
  required bool isDarkMode,
  required ValueChanged<bool> onThemeChanged,
}) {
  return GoRouter(
    initialLocation: '/responsive-dashboard',

    routes: [
      // ==========================================================
      // DASHBOARD
      // ==========================================================

      GoRoute(
        path: '/responsive-dashboard',
        builder: (context, state) {
          return const ResponsiveDashboardT22Screen();
        },
      ),

      // ==========================================================
      // TASKS
      // ==========================================================

      GoRoute(
        path: '/responsive-dashboard/tasks',
        builder: (context, state) {
          return const ResponsiveDashboardT22TasksScreen();
        },
      ),

      // ==========================================================
      // CALENDAR
      // ==========================================================

      GoRoute(
        path: '/responsive-dashboard/calendar',
        builder: (context, state) {
          return const ResponsiveDashboardT22CalendarScreen();
        },
      ),

      // ==========================================================
      // PROFILE
      // ==========================================================

      GoRoute(
        path: '/responsive-dashboard/profile',
        builder: (context, state) {
          return const ResponsiveDashboardT22ProfileScreen();
        },
      ),

      // ==========================================================
      // MESSAGES
      // ==========================================================

      GoRoute(
        path: '/responsive-dashboard/messages',
        builder: (context, state) {
          return const ResponsiveDashboardT22Page(
            title: 'Messages',
            icon: Icons.chat_bubble_rounded,
          );
        },
      ),

      // ==========================================================
      // TEAM
      // ==========================================================

      GoRoute(
        path: '/responsive-dashboard/team',
        builder: (context, state) {
          return const ResponsiveDashboardT22Page(
            title: 'Team',
            icon: Icons.group_rounded,
          );
        },
      ),

      // ==========================================================
      // SETTINGS
      // ==========================================================

      GoRoute(
        path: '/responsive-dashboard/settings',
        builder: (context, state) {
          return ResponsiveDashboardT22SettingsScreen(
            isDarkMode: isDarkMode,
            onThemeChanged: onThemeChanged,
          );
        },
      ),
    ],
  );
}