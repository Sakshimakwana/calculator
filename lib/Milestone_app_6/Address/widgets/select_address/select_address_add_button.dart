import 'package:flutter/material.dart';

class MilestoneApp6SelectAddressAddButton
    extends StatelessWidget {
  final VoidCallback onPressed;

  const MilestoneApp6SelectAddressAddButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add New Address',
        ),
      ),
    );
  }
}