import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_reviews/data/review_controller/review_controller.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_reviews/models/review_model.dart';
import 'package:flutter/material.dart';


class MilestoneApp6ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final ReviewController state;
  final VoidCallback onDelete;

  const MilestoneApp6ReviewCard({
    super.key,
    required this.review,
    required this.state,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final order = review.order;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xffE5E5E5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(width: 10),

                    _buildStatusChip(order.status),
                  ],
                ),
              ),

              IconButton(
                tooltip: 'Delete review',
                onPressed: state.isDeleting ? null : onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  size: 22,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          Text(
            _formatDate(order.createdAt),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff777777),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              ...List.generate(
                5,
                    (index) {
                  return Icon(
                    index < review.rating
                        ? Icons.star
                        : Icons.star_border,
                    size: 23,
                    color: const Color(0xffE85D6A),
                  );
                },
              ),

              const SizedBox(width: 12),

              Text(
                review.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            review.comment.isEmpty
                ? 'No comment'
                : review.comment,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xff555555),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 22),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffF7F7F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Text(
                  'Order total',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff666666),
                  ),
                ),

                const Spacer(),

                Text(
                  '₹${_formatAmount(order.total)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
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

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)} '
        '${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  String _formatAmount(String amount) {
    final value = double.tryParse(amount);

    if (value == null) {
      return amount;
    }

    return value.toStringAsFixed(2);
  }
}