import 'package:flutter/material.dart';
import 'contact_placeholder.dart';

class ContactAvatar extends StatelessWidget {
  final String imageUrl;

  const ContactAvatar({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const ContactPlaceholder();
          },
        ),
      ),
    );
  }
}