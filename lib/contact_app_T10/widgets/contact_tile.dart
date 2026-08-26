import 'package:flutter/material.dart';
import '../theme/contact_typography.dart';
import 'contact_avatar.dart';
import 'contact_model.dart';

class ContactTile extends StatelessWidget {
  final ContactModel contact;

  const ContactTile({
    super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      leading: ContactAvatar(
        imageUrl: contact.imageUrl,
      ),
      title: Text(
        contact.name,
        style: AppTypography.contactName,
      ),
      subtitle: Text(
        contact.phone,
        style: AppTypography.phone,
      ),
      trailing: const Icon(
        Icons.phone,
        color: Colors.blue,
        size: 30,
      ),
    );
  }
}