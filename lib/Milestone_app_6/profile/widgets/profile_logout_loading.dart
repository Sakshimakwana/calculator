import 'package:flutter/material.dart';

class MilestoneApp6ProfileLogoutLoading extends StatelessWidget {
  const MilestoneApp6ProfileLogoutLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                'Logging out...',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
