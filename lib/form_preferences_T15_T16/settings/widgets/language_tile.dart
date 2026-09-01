import 'package:flutter/material.dart';

class LanguageTile extends StatelessWidget {
  const LanguageTile({
    super.key,
    required this.language,
    required this.onChanged,
  });

  final String language;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: language,
        icon: const Icon(Icons.keyboard_arrow_down),
        items: const [
          DropdownMenuItem(
            value: 'en',
            child: Text('English'),
          ),
          DropdownMenuItem(
            value: 'hi',
            child: Text('Hindi'),
          ),
          DropdownMenuItem(
            value: 'gu',
            child: Text('Gujarati'),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}