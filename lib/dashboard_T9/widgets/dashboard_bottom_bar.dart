import 'package:app_matic_tech_flutter_app/dashboard_T9/widgets/dashboard_drawer_profile.dart';
import 'package:app_matic_tech_flutter_app/dashboard_T9/widgets/dashboard_settings_screen.dart';
import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import 'dashboard_reports_screen.dart';

class DashboardBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const DashboardBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => onItemSelected(0),
            icon: Icon(
              Icons.home,
              color: selectedIndex == 0
                  ? DashboardColors.primary
                  : DashboardColors.textSecondary,
            ),
          ),
          IconButton(
            onPressed: (){  onItemSelected(1);
              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => const ReportsScreen(),
              ),
              );
            },
            icon: Icon(
              Icons.bar_chart,
              color: selectedIndex == 1
                  ? DashboardColors.primary
                  : DashboardColors.textSecondary,
            ),
          ),
          IconButton(
            onPressed: () { onItemSelected(2);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
            },
            icon: Icon(
              Icons.person,
              color: selectedIndex == 2
                  ? DashboardColors.primary
                  : DashboardColors.textSecondary,
            ),
          ),
          IconButton(
            onPressed: (){  onItemSelected(3);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
            },
            icon: Icon(
              Icons.settings,
              color: selectedIndex == 3
                  ? DashboardColors.primary
                  : DashboardColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}