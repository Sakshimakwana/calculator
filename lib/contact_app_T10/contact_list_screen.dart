import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/contact_app_T10/theme/contact_typography.dart';
import 'package:app_matic_tech_flutter_app/contact_app_T10/widgets/contact_data.dart';
import 'package:app_matic_tech_flutter_app/contact_app_T10/widgets/contact_tile.dart';
import 'package:app_matic_tech_flutter_app/contact_app_T10/theme/contact_colors.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text(
          'Contacts',
          style: AppTypography.title,
        ),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 24),
          Icon(Icons.more_vert),
          SizedBox(width: 16),
        ],
      ),

      body: Column(
        children: [
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 8,
              itemBuilder: (context, index) {
                final names = [
                  'All',
                  'Family',
                  'Friends',
                  'Work',
                  'College',
                  'Clients',
                  'Emergency',
                  'Other',
                ];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(
                    child: Chip(
                      label: Text(names[index]),
                    ),
                  ),
                );
              },
            ),
          ),

          // Scrollbar + ListView.separated
          Expanded(
            child: Scrollbar(
              child: ListView.separated(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return ContactTile(
                    contact: contacts[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                    color: AppColors.divider,
                  );
                },
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}