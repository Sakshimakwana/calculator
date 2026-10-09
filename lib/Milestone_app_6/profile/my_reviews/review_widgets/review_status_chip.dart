import 'package:flutter/material.dart';

class MilestoneApp6ReviewStatusChip extends StatelessWidget {
  final String status;

  const MilestoneApp6ReviewStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    String displayStatus = status;

    if (status.isNotEmpty) {
      displayStatus =
          status[0].toUpperCase() +
              status.substring(1).toLowerCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayStatus,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xff777777),
        ),
      ),
    );
  }
}