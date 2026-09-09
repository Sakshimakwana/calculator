import 'package:flutter/material.dart';

import '../data/responsive_dashboard_T22_data.dart';
import '../theme/responsive_dashboard_T22_colors.dart';
import '../widgets/responsive_dashboard_T22_app_bar.dart';
import '../widgets/responsive_dashboard_T22_bottom_navigation.dart';
import '../widgets/responsive_dashboard_T22_progress_card.dart';
import '../widgets/responsive_dashboard_T22_quick_action_button.dart';
import '../widgets/responsive_dashboard_T22_recent_activity_tile.dart';
import '../widgets/responsive_dashboard_T22_responsive_layout.dart';
import '../widgets/responsive_dashboard_T22_section_card.dart';
import '../widgets/responsive_dashboard_T22_side_navigation.dart';
import '../widgets/responsive_dashboard_T22_stat_card.dart';
import '../widgets/responsive_dashboard_T22_tasks_overview.dart';
import '../widgets/responsive_dashboard_T22_welcome_banner.dart';

class ResponsiveDashboardT22Screen
    extends StatelessWidget {
  const ResponsiveDashboardT22Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        child:
        ResponsiveDashboardT22ResponsiveLayout(
          phone: _PhoneLayout(
            bottomInset: bottomInset,
          ),
          tablet: _TabletLayout(
            bottomInset: bottomInset,
          ),
        ),
      ),
    );
  }
}

class _PhoneLayout extends StatelessWidget {
  const _PhoneLayout({
    required this.bottomInset,
  });

  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final landscape =
            orientation == Orientation.landscape;

        return AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.only(
            bottom: bottomInset,
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (landscape)
                      const SizedBox(
                        width: 76,
                        child:
                        ResponsiveDashboardT22SideNavigation(
                          compact: true,
                        ),
                      ),

                    Expanded(
                      child: _DashboardContent(
                        compact: !landscape,
                        landscape: landscape,
                      ),
                    ),
                  ],
                ),
              ),

              if (!landscape)
                const ResponsiveDashboardT22BottomNavigation(),
            ],
          ),
        );
      },
    );
  }
}
class _TabletLayout
    extends StatelessWidget {
  const _TabletLayout({
    required this.bottomInset,
  });

  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration:
      const Duration(milliseconds: 180),
      padding: EdgeInsets.only(
        bottom: bottomInset,
      ),
      child: Row(
        children: [
          const ResponsiveDashboardT22SideNavigation(),
          Expanded(
            child: _DashboardContent(
              compact: false,
              landscape: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardContent
    extends StatelessWidget {
  const _DashboardContent({
    required this.compact,
    required this.landscape,
  });

  final bool compact;
  final bool landscape;

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.sizeOf(context).width;

    final contentPadding =
    width < 700 ? 16.0 : 28.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= 900;

        final statCount = compact
            ? 2
            : (wide ? 4 : 2);

        return SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior
              .onDrag,
          padding:
          EdgeInsets.all(contentPadding),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              ResponsiveDashboardT22AppBar(
                showMenu: compact,
              ),

              SizedBox(
                height: compact ? 18 : 22,
              ),

              const ResponsiveDashboardT22WelcomeBanner(),

              const SizedBox(height: 14),

              GridView.builder(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount:
                ResponsiveDashboardT22Data
                    .stats
                    .length,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: statCount,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 70,
                ),
                itemBuilder:
                    (context, index) {
                  final item =
                  ResponsiveDashboardT22Data
                      .stats[index];

                  return ResponsiveDashboardT22StatCard(
                    value: item['value']!,
                    label: item['label']!,
                    type: item['type']!,
                  );
                },
              ),

              const SizedBox(height: 14),

              if (wide)
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _ActivityCard(),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _QuickActionsCard(),
                    ),
                  ],
                )
              else
                _ActivityCard(),

              const SizedBox(height: 14),

              if (wide)
                const Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child:
                      ResponsiveDashboardT22ProgressCard(),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child:
                      ResponsiveDashboardT22TasksOverview(),
                    ),
                  ],
                )
              else ...[
                _QuickActionsCard(),

                const SizedBox(height: 14),

                const ResponsiveDashboardT22ProgressCard(),

                const SizedBox(height: 14),

                const ResponsiveDashboardT22TasksOverview(),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ActivityCard
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveDashboardT22SectionCard(
      title: 'Recent Activity',
      action: 'See All',
      child: Column(
        children:
        ResponsiveDashboardT22Data.activities
            .map(
              (item) =>
              ResponsiveDashboardT22RecentActivityTile(
                title: item['title']!,
                time: item['time']!,
                type: item['type']!,
              ),
        )
            .toList(),
      ),
    );
  }
}

class _QuickActionsCard
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveDashboardT22SectionCard(
      title: 'Quick Actions',
      child: GridView.count(
        shrinkWrap: true,
        physics:
        const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.1,
        children: const [
          ResponsiveDashboardT22QuickActionButton(
            icon:
            Icons.create_new_folder_rounded,
            label: 'Create Project',
            color:
            ResponsiveDashboardT22Colors
                .primary,
          ),
          ResponsiveDashboardT22QuickActionButton(
            icon: Icons.add_task_rounded,
            label: 'Add Task',
            color:
            ResponsiveDashboardT22Colors
                .green,
          ),
          ResponsiveDashboardT22QuickActionButton(
            icon: Icons.event_rounded,
            label: 'Schedule Meeting',
            color:
            ResponsiveDashboardT22Colors
                .pink,
          ),
          ResponsiveDashboardT22QuickActionButton(
            icon:
            Icons.person_add_alt_1_rounded,
            label: 'Invite Team',
            color:
            ResponsiveDashboardT22Colors
                .primary,
          ),
        ],
      ),
    );
  }
}