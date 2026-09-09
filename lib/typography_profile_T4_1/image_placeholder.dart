import 'package:flutter/material.dart';

class ImagePlaceholder {
  static Widget background() {
    return Container(
      color: const Color(0xFFE4E1E8),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: Color(0xFF625F68),
          size: 40,
        ),
      ),
    );
  }
  static Widget profile() {
    return const CircleAvatar(
      radius: 70,
      backgroundColor: Color(0xFFE4E1E8),
      child: Icon(
        Icons.person,
        color: Color(0xFF625F68),
        size: 55,
      ),
    );
  }
}