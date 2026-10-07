import 'package:flutter/material.dart';

class AddressWidgetsDeleteConfirmation extends StatelessWidget {
  final String addressLabel;

  const AddressWidgetsDeleteConfirmation({
    super.key,
    required this.addressLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete address?',
      ),
      content: Text(
        'Are you sure you want to delete '
            '$addressLabel address?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              false,
            );
          },
          child: const Text(
            'Cancel',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              true,
            );
          },
          child: const Text(
            'Delete',
          ),
        ),
      ],
    );
  }
}