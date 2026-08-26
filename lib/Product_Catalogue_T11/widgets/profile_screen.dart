import 'package:flutter/material.dart';

import '../theme/product_catalogue_colors.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors1.background,

      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors1.primary,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors1.primaryLight,
              child: Icon(
                Icons.person,
                size: 55,
                color: AppColors1.primary,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Sakshi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'sakshi@example.com',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            _ProfileItem(
              icon: Icons.person_outline,
              title: 'My Account',
            ),

            _ProfileItem(
              icon: Icons.shopping_bag_outlined,
              title: 'My Orders',
            ),

            _ProfileItem(
              icon: Icons.favorite_border,
              title: 'Favorites',
            ),

            _ProfileItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
            ),

            _ProfileItem(
              icon: Icons.logout,
              title: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ProfileItem({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors1.primary,
      ),

      title: Text(title),

      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),

      onTap: () {},
    );
  }
}