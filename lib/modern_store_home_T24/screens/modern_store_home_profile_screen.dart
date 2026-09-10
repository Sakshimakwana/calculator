import 'package:flutter/material.dart';

import '../theme/modern_store_home_colors.dart';
import '../widgets/modern_store_home_bottom_nav.dart';

class ModernStoreHomeProfileScreen extends StatelessWidget {
  const ModernStoreHomeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 15),
          const CircleAvatar(
            radius: 48,
            backgroundColor:
            ModernStoreHomeColors.green,
            child: Icon(
              Icons.person,
              size: 55,
              color: ModernStoreHomeColors.primary,
            ),
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Sakshi Darji',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Center(
            child: Text(
              'sakshi@example.com',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 30),
          _ProfileTile(
            icon: Icons.person_outline,
            title: 'Personal Information',
            onTap: () {},
          ),
          _ProfileTile(
            icon: Icons.shopping_bag_outlined,
            title: 'My Orders',
            onTap: () {},
          ),
          _ProfileTile(
            icon: Icons.location_on_outlined,
            title: 'Addresses',
            onTap: () {},
          ),
          _ProfileTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            onTap: () {},
          ),
          _ProfileTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {},
          ),
          _ProfileTile(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {},
          ),
        ],
      ),
      bottomNavigationBar:
      const ModernStoreHomeBottomNav(currentIndex: 4),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}