import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/shoppingflow_T20_state.dart';

class ShoppingFlowT20ProfileScreen
    extends StatelessWidget {
  const ShoppingFlowT20ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shoppingFlowT20State,
      builder: (context, child) {

        final user =
            shoppingFlowT20State.currentUser;

        if (user == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'No user data found',
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                const CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 55,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                _profileItem(
                  Icons.person_outline,
                  'Name',
                  user.name,
                ),

                _profileItem(
                  Icons.email_outlined,
                  'Email',
                  user.email,
                ),

                _profileItem(
                  Icons.phone_outlined,
                  'Phone',
                  user.phone,
                ),

                _profileItem(
                  Icons.location_on_outlined,
                  'Address',
                  user.address,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      context.go(
                        '/edit-profile',
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                    label: const Text(
                      'Edit Profile',
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showLogoutDialog(
                        context,
                      );
                    },
                    icon: const Icon(
                      Icons.logout,
                    ),
                    label:
                    const Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _profileItem(
      IconData icon,
      String title,
      String value,
      ) {
    return Card(
      margin:
      const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  void _showLogoutDialog(
      BuildContext context,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
              const Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                shoppingFlowT20State
                    .logout();

                Navigator.pop(context);

                context.go('/login');
              },
              child:
              const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}