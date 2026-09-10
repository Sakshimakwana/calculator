import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';
import '../theme/responsive_dashboard_T22_typography.dart';

import '../theme_T23/Theme_T23_app_colors.dart';
import '../widgets/responsive_dashboard_T22_back_button.dart';

class ResponsiveDashboardT22TasksScreen
    extends StatelessWidget {
  const ResponsiveDashboardT22TasksScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool isDark =
        theme.brightness == Brightness.dark;

    return Scaffold(
      // ==========================================================
      // BACKGROUND
      // ==========================================================

      backgroundColor:
      theme.scaffoldBackgroundColor,

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        leading:
        const ResponsiveDashboardT22BackButton(),

        title: Text(
          'Tasks',
          style: theme.textTheme.titleLarge,
        ),

        backgroundColor:
        theme.colorScheme.surface,
      ),

      // ==========================================================
      // BODY
      // ==========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              // ==================================================
              // TITLE
              // ==================================================

              Text(
                'Task Overview',
                style: theme.textTheme.headlineSmall,
              ),

              const SizedBox(height: 6),

              Text(
                'Track your tasks and progress',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 20),

              // ==================================================
              // SUMMARY ROW 1
              // ==================================================

              Row(
                children: [
                  Expanded(
                    child: _TaskSummaryCard(
                      title: 'Completed',
                      value: '8',
                      icon:
                      Icons.check_circle_rounded,

                      color:
                      theme.colorScheme.secondary,

                      background: isDark
                          ? ThemeT23AppColors
                          .darkGreenCard
                          : ThemeT23AppColors
                          .lightGreenCard,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _TaskSummaryCard(
                      title: 'In Progress',
                      value: '4',
                      icon:
                      Icons.pending_rounded,

                      color:
                      theme.colorScheme.primary,

                      background: isDark
                          ? ThemeT23AppColors
                          .darkBlueCard
                          : ThemeT23AppColors
                          .lightBlueCard,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ==================================================
              // SUMMARY ROW 2
              // ==================================================

              Row(
                children: [
                  Expanded(
                    child: _TaskSummaryCard(
                      title: 'Pending',
                      value: '3',
                      icon:
                      Icons.schedule_rounded,

                      color:
                      ThemeT23AppColors.orange,

                      background: isDark
                          ? ThemeT23AppColors
                          .darkOrangeCard
                          : ThemeT23AppColors
                          .lightOrangeCard,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _TaskSummaryCard(
                      title: 'Total Tasks',
                      value: '15',
                      icon:
                      Icons.task_alt_rounded,

                      color:
                      ThemeT23AppColors.pink,

                      background: isDark
                          ? ThemeT23AppColors
                          .darkPinkCard
                          : ThemeT23AppColors
                          .lightPinkCard,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ==================================================
              // ALL TASKS TITLE
              // ==================================================

              Text(
                'All Tasks',
                style: theme.textTheme.titleLarge,
              ),

              const SizedBox(height: 12),

              // ==================================================
              // TASK 1
              // ==================================================

              _TaskTile(
                title: 'Complete dashboard UI',
                subtitle: 'Today • 10:00 AM',
                status: 'Completed',
                color:
                theme.colorScheme.secondary,
              ),

              // ==================================================
              // TASK 2
              // ==================================================

              _TaskTile(
                title: 'Review project design',
                subtitle: 'Today • 02:00 PM',
                status: 'In Progress',
                color:
                theme.colorScheme.primary,
              ),

              // ==================================================
              // TASK 3
              // ==================================================

              _TaskTile(
                title: 'Update documentation',
                subtitle: 'Tomorrow • 11:00 AM',
                status: 'Pending',
                color:
                ThemeT23AppColors.orange,
              ),

              // ==================================================
              // TASK 4
              // ==================================================

              _TaskTile(
                title: 'Team discussion',
                subtitle: 'Tomorrow • 04:00 PM',
                status: 'In Progress',
                color:
                theme.colorScheme.primary,
              ),

              // ==================================================
              // TASK 5
              // ==================================================

              _TaskTile(
                title: 'Final project testing',
                subtitle: 'Friday • 03:00 PM',
                status: 'Pending',
                color:
                ThemeT23AppColors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ==================================================================
// TASK SUMMARY CARD
// ==================================================================

class _TaskSummaryCard extends StatelessWidget {
  const _TaskSummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: background,

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color: theme.colorScheme.outline
              .withValues(alpha: 0.35),
        ),
      ),

      child: Row(
        children: [
          // ======================================================
          // ICON
          // ======================================================

          Icon(
            icon,
            color: color,
            size: 25,
          ),

          const SizedBox(width: 10),

          // ======================================================
          // TEXT
          // ======================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  value,
                  style: theme
                      .textTheme
                      .titleLarge,
                ),

                const SizedBox(height: 2),

                Text(
                  title,
                  style: theme
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ==================================================================
// TASK TILE
// ==================================================================

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        // ========================================================
        // THEME-AWARE CARD
        // ========================================================

        color:
        theme.colorScheme.surface,

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color:
          theme.colorScheme.outline,
        ),
      ),

      child: Row(
        children: [
          // ======================================================
          // TASK ICON
          // ======================================================

          Icon(
            Icons.task_alt_rounded,
            color: color,
            size: 25,
          ),

          const SizedBox(width: 12),

          // ======================================================
          // TASK INFORMATION
          // ======================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: theme
                      .textTheme
                      .titleMedium,
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: theme
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),

          // ======================================================
          // STATUS
          // ======================================================

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),

            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.10,
              ),

              borderRadius:
              BorderRadius.circular(20),
            ),

            child: Text(
              status,
              style: TextStyle(
                fontSize: 9,
                fontWeight:
                FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}