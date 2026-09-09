import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/responsive_dashboard_T22_calendar_screen.dart';
import '../screens/responsive_dashboard_T22_profile_screen.dart';
import '../screens/responsive_dashboard_T22_screen.dart';
import '../screens/responsive_dashboard_T22_tasks_screen.dart';
import '../screens/responsive_dashboard_T22_page.dart';

final responsiveDashboardT22Router = GoRouter(
  initialLocation: '/responsive-dashboard',

  routes: [
    GoRoute(
      path: '/responsive-dashboard',
      builder: (context, state) {
        return const ResponsiveDashboardT22Screen();
      },
    ),

    GoRoute(
      path: '/responsive-dashboard/tasks',
      builder: (context, state) {
        return const ResponsiveDashboardT22TasksScreen();
      },
    ),

    GoRoute(
      path: '/responsive-dashboard/calendar',
      builder: (context, state) {
        return const ResponsiveDashboardT22CalendarScreen();
      },
    ),

    GoRoute(
      path: '/responsive-dashboard/profile',
      builder: (context, state) {
        return const ResponsiveDashboardT22ProfileScreen();
      },
    ),

    GoRoute(
      path: '/responsive-dashboard/messages',
      builder: (context, state) {
        return const ResponsiveDashboardT22Page(
          title: 'Messages',
          icon: Icons.chat_bubble_rounded,
        );
      },
    ),

    GoRoute(
      path: '/responsive-dashboard/team',
      builder: (context, state) {
        return const ResponsiveDashboardT22Page(
          title: 'Team',
          icon: Icons.group_rounded,
        );
      },
    ),

    GoRoute(
      path: '/responsive-dashboard/settings',
      builder: (context, state) {
        return const ResponsiveDashboardT22Page(
          title: 'Settings',
          icon: Icons.settings_rounded,
        );
      },
    ),
  ],
);