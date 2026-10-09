import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_reviews/data/review_controller/review_controller.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_reviews/models/review_model.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_reviews/review_widgets/reviews_loading.dart';
import 'package:flutter/material.dart';
import 'review_card.dart';


class MilestoneApp6ReviewsList extends StatelessWidget {
  final ReviewController state;
  final Future<void> Function() onRefresh;
  final VoidCallback Function(ReviewModel review) onDelete;

  const MilestoneApp6ReviewsList({
    super.key,
    required this.state,
    required this.onRefresh,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          28,
          25,
          28,
          30,
        ),
        children: [
          const Text(
            'My Reviews',
            style: TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'All your restaurant reviews and ratings in one place.',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xff777777),
            ),
          ),

          const SizedBox(height: 30),

          ...state.reviews.map(
                (review) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 18,
                ),
                child: MilestoneApp6ReviewCard(
                  review: review,
                  state: state,
                  onDelete: onDelete(review),
                ),
              );
            },
          ),

          if (state.isLoadingMore)
            const MilestoneApp6ReviewsLoading(),
        ],
      ),
    );
  }
}