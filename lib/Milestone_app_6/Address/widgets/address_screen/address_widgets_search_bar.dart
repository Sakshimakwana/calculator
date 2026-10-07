import 'package:flutter/material.dart';

class AddressWidgetsSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onClear;

  const AddressWidgetsSearchBar({
    super.key,
    required this.controller,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark =
        theme.brightness == Brightness.dark;

    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF302F35)
            : Colors.white,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: theme.dividerColor
              .withOpacity(0.20),
        ),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText:
          'Search saved addresses...',
          hintStyle: TextStyle(
            fontSize: 15,
            color: theme.hintColor,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 27,
            color:
            theme.colorScheme.primary,
          ),
          suffixIcon:
          controller.text.isNotEmpty
              ? IconButton(
            onPressed: onClear,
            icon: const Icon(
              Icons.close_rounded,
            ),
          )
              : null,
          contentPadding:
          const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
      ),
    );
  }
}