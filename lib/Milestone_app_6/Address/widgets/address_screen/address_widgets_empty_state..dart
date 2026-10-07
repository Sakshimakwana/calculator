import 'package:flutter/material.dart';

class AddressWidgetsEmptyState extends StatelessWidget {
  const AddressWidgetsEmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: 85,
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_searching_rounded,
            size: 62,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 18),

          const Text(
            'No saved addresses',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Add an address to continue.',
            style: TextStyle(
              fontSize: 13,
              color: theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }
}