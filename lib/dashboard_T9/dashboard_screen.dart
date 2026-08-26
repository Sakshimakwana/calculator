import 'package:app_matic_tech_flutter_app/dashboard_T9/theme/dashboard_colors.dart';
import 'package:app_matic_tech_flutter_app/dashboard_T9/theme/dashboard_typography.dart';
import 'package:app_matic_tech_flutter_app/dashboard_T9/widgets/dashboard_activity.dart';
import 'package:app_matic_tech_flutter_app/dashboard_T9/widgets/dashboard_app_bar.dart';
import 'package:app_matic_tech_flutter_app/dashboard_T9/widgets/dashboard_bottom_bar.dart';
import 'package:app_matic_tech_flutter_app/dashboard_T9/widgets/dashboard_card.dart';
import 'package:app_matic_tech_flutter_app/dashboard_T9/widgets/dashboard_drawer.dart';
import 'package:app_matic_tech_flutter_app/dashboard_T9/widgets/dashboard_fab..dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardColors.background,

      // AppBar
      appBar: DashboardAppBar.build(context),

      // Drawer
      drawer: const DashboardDrawer(),

      // Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Morning, Alex!',
              style: DashboardTypography.greeting,
            ),
            const SizedBox(height: 6),
            const Text(
              "Here's what's happening today.",
              style: DashboardTypography.subtitle,
            ),
            const SizedBox(height: 24),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.95,
              children: const [
                DashboardCard(
                  title: 'Total Sales',
                  value: '\$12,450',
                  percentage: '12.5%',
                  icon: Icons.attach_money,
                  iconBackground: DashboardColors.blueLight,
                ),
                DashboardCard(
                  title: 'Orders',
                  value: '248',
                  percentage: '8.2%',
                  icon: Icons.shopping_bag_outlined,
                  iconBackground: DashboardColors.greenLight,
                ),
                DashboardCard(
                  title: 'Customers',
                  value: '1,240',
                  percentage: '6.5%',
                  icon: Icons.people_outline,
                  iconBackground: DashboardColors.purpleLight,
                ),
                DashboardCard(
                  title: 'Pending Tasks',
                  value: '18',
                  percentage: '4.3%',
                  icon: Icons.access_time,
                  iconBackground: DashboardColors.orangeLight,
                  isNegative: true,
                ),
              ],
            ),

            const SizedBox(height: 20),

            const DashboardActivity(),
          ],
        ),
      ),

      // FloatingActionButton
      floatingActionButton: DashboardFab(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New item added successfully'),
            ),
          );
        },
      ),

      // BottomAppBar
      bottomNavigationBar: DashboardBottomBar(
        selectedIndex: selectedIndex,
        onItemSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}