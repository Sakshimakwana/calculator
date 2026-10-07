import 'package:flutter/material.dart';

class MilestoneApp6SelectAddressLoadMoreButton
    extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const MilestoneApp6SelectAddressLoadMoreButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    return Center(
      child: TextButton(
        onPressed: onPressed,
        child: const Text(
          'Load more addresses',
        ),
      ),
    );
  }
}