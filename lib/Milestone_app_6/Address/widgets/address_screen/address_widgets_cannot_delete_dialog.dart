import 'package:flutter/material.dart';

class AddressWidgetsCannotDeleteDialog
    extends StatelessWidget {
  const AddressWidgetsCannotDeleteDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Cannot delete address',
      ),
      content: const Text(
        'You must keep at least one '
            'saved address.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'OK',
          ),
        ),
      ],
    );
  }
}