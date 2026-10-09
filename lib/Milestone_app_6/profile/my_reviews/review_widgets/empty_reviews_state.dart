import 'package:flutter/material.dart';

class MilestoneApp6EmptyReviewsState extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const MilestoneApp6EmptyReviewsState({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 180),

          Icon(
            Icons.rate_review_outlined,
            size: 65,
            color: Colors.grey,
          ),

          SizedBox(height: 15),

          Center(
            child: Text(
              'No Reviews Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          SizedBox(height: 8),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Text(
              'Your restaurant reviews will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}