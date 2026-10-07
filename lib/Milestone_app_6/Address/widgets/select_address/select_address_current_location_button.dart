import 'package:flutter/material.dart';

class MilestoneApp6SelectAddressLocationButton
    extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const MilestoneApp6SelectAddressLocationButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        )
            : const Icon(Icons.my_location),
        label: Text(
          isLoading
              ? 'Getting location...'
              : 'Use current location',
        ),
      ),
    );
  }
}