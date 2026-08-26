import 'package:flutter/material.dart';

class ReusableCardGalleryImagePlaceholder extends StatelessWidget {
  final IconData icon;

  const ReusableCardGalleryImagePlaceholder({
    super.key,
    this.icon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,),
      child: Container(
        color: const Color(0xFFE8E0FF),
        child: Center(
          child: Icon(
            icon,
            size: 40,
            color: const Color(0xFF6C3CE9),
          ),
        ),
      ),
    );
  }
}