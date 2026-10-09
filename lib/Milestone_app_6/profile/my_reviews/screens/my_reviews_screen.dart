import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_reviews/data/review_controller/review_controller.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_reviews/models/review_model.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_reviews/review_widgets/empty_reviews_state.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_reviews/review_widgets/review_card.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_reviews/review_widgets/review_error_state.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_reviews/review_widgets/reviews_header.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_reviews/review_widgets/reviews_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MilestoneApp6MyReviewsScreen extends StatefulWidget {
  const MilestoneApp6MyReviewsScreen({
    super.key,
  });

  @override
  State<MilestoneApp6MyReviewsScreen> createState() =>
      _MilestoneApp6MyReviewsScreenState();
}

class _MilestoneApp6MyReviewsScreenState
    extends State<MilestoneApp6MyReviewsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<ReviewController>().fetchReviews();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<ReviewController>().loadMoreReviews();
    }
  }

  Future<void> _refresh() async {
    await context.read<ReviewController>().fetchReviews(
      refresh: true,
    );
  }

  Future<void> _confirmDelete(
      ReviewModel review,
      ) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Review',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this review?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
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
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (result != true || !mounted) {
      return;
    }

    final bool success =
    await context.read<ReviewController>().deleteReview(
      review.id,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Review deleted successfully'
              : 'Failed to delete review',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'My Reviews',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<ReviewController>(
        builder: (
            context,
            state,
            child,
            ) {
          // Initial loading
          if (state.isLoading && state.reviews.isEmpty) {
            return const MilestoneApp6ReviewsLoading();
          }

          // Error state
          if (state.errorMessage != null &&
              state.reviews.isEmpty) {
            return MilestoneApp6ReviewErrorState(
              state: state,
              onRetry: () {
                state.fetchReviews(
                  refresh: true,
                );
              },
            );
          }

          // Empty state
          if (state.reviews.isEmpty) {
            return MilestoneApp6EmptyReviewsState(
              onRefresh: _refresh,
            );
          }

          // Reviews list
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                28,
                25,
                28,
                30,
              ),
              children: [
                const MilestoneApp6ReviewsHeader(),

                ...state.reviews.map(
                      (review) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 18,
                      ),
                      child: MilestoneApp6ReviewCard(
                        review: review,
                        state: state,
                        onDelete: () => _confirmDelete(review),
                      ),
                    );
                  },
                ),
                if (state.isLoadingMore)
                  const MilestoneApp6ReviewsLoading(),
              ],
            ),
          );
        },
      ),
    );
  }
}