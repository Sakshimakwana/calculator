import 'package:flutter/material.dart';

class MilestoneApp6SelectAddressSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isSearching;

  const MilestoneApp6SelectAddressSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.isSearching = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search address',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: isSearching
            ? const Padding(
          padding: EdgeInsets.all(12),
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        )
            : (controller.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            controller.clear();
            onChanged('');
          },
        )
            : null),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}