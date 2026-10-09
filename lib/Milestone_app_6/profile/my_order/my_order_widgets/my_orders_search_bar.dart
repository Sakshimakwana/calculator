import 'package:flutter/material.dart';

class MyOrdersSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchText;

  const MyOrdersSearchBar({
    super.key,
    required this.controller,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white12
              : const Color(0xFFE3E3E3),
        ),
      ),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF8D8D8D),
          ),
          suffixIcon: searchText.isNotEmpty
              ? IconButton(
                  onPressed: controller.clear,
                  icon: const Icon(Icons.close),
                )
              : null,
          hintText: 'Search restaurant or ordered items...',
          hintStyle: const TextStyle(
            color: Color(0xFFA5A5A5),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 17,
          ),
        ),
      ),
    );
  }
}
