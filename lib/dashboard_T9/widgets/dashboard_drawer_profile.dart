import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../theme/dashboard_typography.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardColors.background,

      appBar: AppBar(
        backgroundColor: DashboardColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: DashboardTypography.appBarTitle,
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Image
            CircleAvatar(
              radius: 55,
              backgroundColor: DashboardColors.blueLight,
              child: ClipOval(
                child: Image.network(
                  'https://i.pravatar.cc/300',
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,

                  // Placeholder while loading
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const Icon(
                      Icons.person,
                      size: 60,
                      color: DashboardColors.primary,
                    );
                  },

                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 60,
                      color: DashboardColors.primary,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Name
            const Text(
              'Alex Johnson',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            // Email
            const Text(
              'alex.johnson@example.com',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // Profile Information
            _ProfileInfoTile(
              icon: Icons.person_outline,
              title: 'Full Name',
              value: 'Alex Johnson',
            ),

            const SizedBox(height: 12),

            _ProfileInfoTile(
              icon: Icons.email_outlined,
              title: 'Email',
              value: 'alex.johnson@example.com',
            ),

            const SizedBox(height: 12),

            _ProfileInfoTile(
              icon: Icons.phone_outlined,
              title: 'Phone',
              value: '+91 98765 43210',
            ),

            const SizedBox(height: 12),

            _ProfileInfoTile(
              icon: Icons.location_on_outlined,
              title: 'Location',
              value: 'Ahmedabad, India',
            ),

            const SizedBox(height: 30),

            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit Profile clicked'),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DashboardColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: DashboardColors.blueLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: DashboardColors.primary,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}