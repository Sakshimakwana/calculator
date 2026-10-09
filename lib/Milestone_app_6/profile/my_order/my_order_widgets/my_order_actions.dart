import 'package:flutter/material.dart';
import 'my_order_action_button.dart';
import 'my_order_cancelled_label.dart';
import 'my_order_review_submitted_label.dart';

class MyOrderActions extends StatelessWidget {
  final String status;
  final bool alreadySubmitted;
  final VoidCallback onWriteReview;

  const MyOrderActions({
    super.key,
    required this.status,
    required this.alreadySubmitted,
    required this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status.toLowerCase();

    if (normalizedStatus == 'delivered') {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          14,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: alreadySubmitted
              ? const MyOrderReviewSubmittedLabel()
              : MyOrderActionButton(
                  label: 'Write a Review',
                  filled: true,
                  onTap: onWriteReview,
                ),
        ),
      );
    }

    if (normalizedStatus == 'cancelled') {
      return const Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          14,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: MyOrderCancelledLabel(),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
