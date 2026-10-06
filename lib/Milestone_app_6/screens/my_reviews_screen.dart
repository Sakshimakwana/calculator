import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/review_controller.dart';
import '../../models/review/review_model.dart';

class MilestoneApp6MyReviewsScreen
    extends StatefulWidget {
  const MilestoneApp6MyReviewsScreen({
    super.key,
  });

  @override
  State<MilestoneApp6MyReviewsScreen>
  createState() =>
      _MilestoneApp6MyReviewsScreenState();
}

class _MilestoneApp6MyReviewsScreenState
    extends State<
        MilestoneApp6MyReviewsScreen> {
  final ScrollController
  _scrollController =
  ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      context
          .read<ReviewController>()
          .fetchReviews();
    });

    _scrollController.addListener(
      _onScroll,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position =
        _scrollController.position;

    if (position.pixels >=
        position.maxScrollExtent - 300) {
      context
          .read<ReviewController>()
          .loadMoreReviews();
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refresh() async {
    await context
        .read<ReviewController>()
        .fetchReviews(
      refresh: true,
    );
  }

  // ============================================================
  // DELETE CONFIRMATION
  // ============================================================

  Future<void> _confirmDelete(
      ReviewModel review,
      ) async {
    final bool? result =
    await showDialog<bool>(
      context: context,
      builder: (
          dialogContext,
          ) {
        return AlertDialog(
          title: const Text(
            'Delete Review',
            style: TextStyle(
              fontWeight:
              FontWeight.w700,
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

    if (result != true ||
        !mounted) {
      return;
    }

    final bool success =
    await context
        .read<ReviewController>()
        .deleteReview(
      review.id,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Review deleted successfully'
              : 'Failed to delete review',
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      backgroundColor:
      Colors.white,

      appBar: AppBar(
        backgroundColor:
        Colors.white,
        elevation: 0,
        surfaceTintColor:
        Colors.white,

        iconTheme:
        const IconThemeData(
          color: Colors.black,
        ),

        title: const Text(
          'My Reviews',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight:
            FontWeight.w700,
          ),
        ),
      ),

      body: Consumer<
          ReviewController>(
        builder: (
            context,
            state,
            child,
            ) {
          // ==================================================
          // INITIAL LOADING
          // ==================================================

          if (state.isLoading &&
              state.reviews.isEmpty) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          // ==================================================
          // ERROR
          // ==================================================

          if (state.errorMessage !=
              null &&
              state.reviews.isEmpty) {
            return _buildError(
              state,
            );
          }

          // ==================================================
          // EMPTY
          // ==================================================

          if (state.reviews.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,

              child: ListView(
                physics:
                const AlwaysScrollableScrollPhysics(),

                children: const [
                  SizedBox(
                    height: 180,
                  ),

                  Icon(
                    Icons
                        .rate_review_outlined,
                    size: 65,
                    color: Colors.grey,
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Center(
                    child: Text(
                      'No Reviews Yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  Padding(
                    padding:
                    EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Text(
                      'Your restaurant reviews will appear here.',
                      textAlign:
                      TextAlign.center,
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

          // ==================================================
          // REVIEWS
          // ==================================================

          return RefreshIndicator(
            onRefresh: _refresh,

            child: ListView(
              controller:
              _scrollController,

              physics:
              const AlwaysScrollableScrollPhysics(),

              padding:
              const EdgeInsets.fromLTRB(
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
                    fontWeight:
                    FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                const Text(
                  'All your restaurant reviews and ratings in one place.',
                  style: TextStyle(
                    fontSize: 15,
                    color:
                    Color(0xff777777),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                ...state.reviews.map(
                      (review) {
                    return Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 18,
                      ),
                      child:
                      _buildReviewCard(
                        review,
                        state,
                      ),
                    );
                  },
                ),

                if (state.isLoadingMore)
                  const Padding(
                    padding:
                    EdgeInsets.all(20),
                    child: Center(
                      child:
                      CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // REVIEW CARD
  // ============================================================

  Widget _buildReviewCard(
      ReviewModel review,
      ReviewController state,
      ) {
    final order =
        review.order;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        20,
      ),

      decoration:
      BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          15,
        ),

        border: Border.all(
          color:
          const Color(
            0xffE5E5E5,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(
              0.03,
            ),
            blurRadius: 8,
            offset:
            const Offset(
              0,
              2,
            ),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // ==================================================
          // ORDER HEADER
          // ==================================================

          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Order #${order.id}',
                      style:
                      const TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        Colors.black,
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    _buildStatusChip(
                      order.status,
                    ),
                  ],
                ),
              ),

              IconButton(
                tooltip:
                'Delete review',

                onPressed:
                state.isDeleting
                    ? null
                    : () =>
                    _confirmDelete(
                      review,
                    ),

                icon:
                const Icon(
                  Icons
                      .delete_outline,
                  size: 22,
                  color:
                  Colors.grey,
                ),
              ),
            ],
          ),

          // ==================================================
          // DATE
          // ==================================================

          Text(
            _formatDate(
              order.createdAt,
            ),
            style:
            const TextStyle(
              fontSize: 14,
              color:
              Color(0xff777777),
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          // ==================================================
          // STARS
          // ==================================================

          Row(
            children: [
              ...List.generate(
                5,
                    (index) {
                  return Icon(
                    index <
                        review.rating
                        ? Icons.star
                        : Icons.star_border,
                    size: 23,
                    color:
                    const Color(
                      0xffE85D6A,
                    ),
                  );
                },
              ),

              const SizedBox(
                width: 12,
              ),

              Text(
                review.rating
                    .toStringAsFixed(
                  1,
                ),
                style:
                const TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          // ==================================================
          // COMMENT
          // ==================================================

          Text(
            review.comment.isEmpty
                ? 'No comment'
                : review.comment,

            style:
            const TextStyle(
              fontSize: 15,
              color:
              Color(0xff555555),
              height: 1.4,
            ),
          ),

          const SizedBox(
            height: 22,
          ),

          // ==================================================
          // ORDER TOTAL
          // ==================================================

          Container(
            width:
            double.infinity,

            padding:
            const EdgeInsets
                .symmetric(
              horizontal: 15,
              vertical: 12,
            ),

            decoration:
            BoxDecoration(
              color:
              const Color(
                0xffF7F7F7,
              ),

              borderRadius:
              BorderRadius.circular(
                10,
              ),
            ),

            child: Row(
              children: [
                const Text(
                  'Order total',
                  style:
                  TextStyle(
                    fontSize: 14,
                    color:
                    Color(
                      0xff666666,
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  '₹${_formatAmount(order.total)}',

                  style:
                  const TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  Widget _buildStatusChip(
      String status,
      ) {
    String displayStatus =
        status;

    if (status.isNotEmpty) {
      displayStatus =
          status[0].toUpperCase() +
              status
                  .substring(1)
                  .toLowerCase();
    }

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration:
      BoxDecoration(
        color:
        const Color(
          0xffF5F5F5,
        ),

        borderRadius:
        BorderRadius.circular(
          20,
        ),
      ),

      child: Text(
        displayStatus,

        style:
        const TextStyle(
          fontSize: 12,
          color:
          Color(0xff777777),
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(
      ReviewController state,
      ) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(
          30,
        ),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.grey,
            ),

            const SizedBox(
              height: 15,
            ),

            const Text(
              'Unable to load reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              state.errorMessage ??
                  'Something went wrong',

              textAlign:
              TextAlign.center,

              style:
              const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: () {
                state.fetchReviews(
                  refresh: true,
                );
              },
              child:
              const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DATE
  // ============================================================

  String _formatDate(
      DateTime? date,
      ) {
    if (date == null) {
      return '';
    }

    return DateFormat(
      'dd MMM yyyy',
    ).format(date);
  }

  // ============================================================
  // AMOUNT
  // ============================================================

  String _formatAmount(
      String amount,
      ) {
    final value =
    double.tryParse(
      amount,
    );

    if (value == null) {
      return amount;
    }

    return value.toStringAsFixed(
      2,
    );
  }
}