import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Produuctfiltert18ProfileScreen extends StatefulWidget {
  const Produuctfiltert18ProfileScreen({
    super.key,
  });

  @override
  State<Produuctfiltert18ProfileScreen> createState() =>
      _Produuctfiltert18ProfileScreenState();
}

class _Produuctfiltert18ProfileScreenState
    extends State<Produuctfiltert18ProfileScreen> {

  String name = 'User';
  String email = 'Not available';
  String phone = 'Not available';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('user_name') ?? 'User';
      email = prefs.getString('user_email') ?? 'Not available';
      phone = prefs.getString('user_phone') ?? 'Not available';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(height: 20),

            // Profile image
            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 55,
              ),
            ),

            const SizedBox(height: 25),

            // User name
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // Name
            _ProfileItem(
              icon: Icons.person_outline,
              title: 'Name',
              value: name,
            ),

            // Email
            _ProfileItem(
              icon: Icons.email_outlined,
              title: 'Email',
              value: email,
            ),

            // Phone
            _ProfileItem(
              icon: Icons.phone_outlined,
              title: 'Phone',
              value: phone,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: [

          Icon(icon),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
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