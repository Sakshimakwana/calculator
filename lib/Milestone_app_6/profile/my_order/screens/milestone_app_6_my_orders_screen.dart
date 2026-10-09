import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_order/my_order_widgets/my_order_card.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_order/my_order_widgets/my_orders_empty_state.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_order/my_order_widgets/my_orders_error_state.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_order/my_order_widgets/my_orders_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app_matic_tech_flutter_app/controllers/order_controller.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/profile/my_reviews/data/review_controller/review_controller.dart';
import 'package:app_matic_tech_flutter_app/models/order/order_info_model.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/state/milestone_app_6_state.dart';

class MilestoneApp6MyOrdersScreen extends StatefulWidget {
  final MilestoneApp6State state;

  const MilestoneApp6MyOrdersScreen({
    super.key,
    required this.state,
  });

  @override
  State<MilestoneApp6MyOrdersScreen> createState() =>
      _MilestoneApp6MyOrdersScreenState();
}

class _MilestoneApp6MyOrdersScreenState
    extends State<MilestoneApp6MyOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  final Set<String> _submittedReviews = {};
  String _searchText = '';

  String _ratingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Tap to rate';
    }
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderController>().fetchMyOrders(
            refresh: true,
          );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showReviewDialog(
    BuildContext context,
    OrderInfoModel order,
  ) async {
    int selectedRating = 0;
    String reviewText = '';

    final bool? submitted = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            final bool canSubmit =
                selectedRating > 0 && reviewText.trim().isNotEmpty;

            return Dialog(
              backgroundColor: Theme.of(context).cardColor,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 625,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    30,
                    24,
                    30,
                    20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Write a Review',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : const Color(
                                        0xFF10131A,
                                      ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(
                                dialogContext,
                                false,
                              );
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),

                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade500,
                          ),
                          children: [
                            const TextSpan(
                              text: 'How was your experience with ',
                            ),
                            TextSpan(
                              text: order.restaurant.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: '?',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            5,
                            (index) {
                              final int rating = index + 1;

                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  setDialogState(() {
                                    selectedRating = rating;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: Icon(
                                    rating <= selectedRating
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    size: 38,
                                    color: rating <= selectedRating
                                        ? const Color(
                                            0xFFFFC107,
                                          )
                                        : Colors.grey.shade300,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Center(
                        child: Text(
                          selectedRating == 0
                              ? 'Tap to rate'
                              : _ratingText(
                                  selectedRating,
                                ),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Text(
                            'Your Review',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${reviewText.length} / 500',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Container(
                        height: 145,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.10)
                                    : const Color(
                                        0xFFE2E2E2,
                                      ),
                          ),
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: TextField(
                          maxLength: 500,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          onChanged: (value) {
                            setDialogState(() {
                              reviewText = value;
                            });
                          },
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                            hintText: 'Tell us about your experience...',
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 42,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(
                                  dialogContext,
                                  false,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),

                          const SizedBox(width: 12),
                          SizedBox(
                            height: 42,
                            child: ElevatedButton(
                              onPressed: canSubmit
                                  ? () {
                                      Navigator.pop(
                                        dialogContext,
                                        true,
                                      );
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                disabledBackgroundColor: const Color(
                                  0xFFE5E5E5,
                                ),
                                foregroundColor: Colors.white,
                                disabledForegroundColor: const Color(
                                  0xFF999999,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Submit Review',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (submitted == true && mounted) {
      final reviewController = context.read<ReviewController>();

      final success = await reviewController.createReview(
        orderId: order.id,
        rating: selectedRating,
        comment: reviewText.trim(),
      );

      if (!mounted) {
        return;
      }

      if (success) {
        setState(() {
          _submittedReviews.add(
            order.id.toString(),
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Review submitted successfully.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              reviewController.errorMessage ?? 'Failed to submit review.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  List<OrderInfoModel> _filteredOrders(
    List<OrderInfoModel> orders,
  ) {
    if (_searchText.isEmpty) {
      return orders;
    }

    return orders.where((order) {
      final restaurant = order.restaurant.name.toLowerCase();

      final status = order.status.toLowerCase();

      final orderId = order.id.toString();

      final itemNames = order.orderItems
          .map(
            (item) => item.menuItem.name.toLowerCase(),
          )
          .join(' ');

      return restaurant.contains(_searchText) ||
          status.contains(_searchText) ||
          orderId.contains(_searchText) ||
          itemNames.contains(_searchText);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(
      builder: (
        context,
        orderController,
        child,
      ) {
        final orders = _filteredOrders(
          orderController.myOrders,
        );

        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor:
              isDark ? const Color(0xFF0D0D0D) : const Color(0xFFFAFAFA),
          appBar: AppBar(
            backgroundColor:
                isDark ? const Color(0xFF0D0D0D) : const Color(0xFFFAFAFA),
            foregroundColor: isDark ? Colors.white : const Color(0xFF171717),
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: const Text(
              'My Orders',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () {
              return context.read<OrderController>().fetchMyOrders(
                    refresh: true,
                  );
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 300) {
                    context.read<OrderController>().loadMoreMyOrders();
                  }
                }

                return false;
              },
              child: LayoutBuilder(
                builder: (
                  context,
                  constraints,
                ) {
                  final horizontalPadding =
                      constraints.maxWidth >= 700 ? 32.0 : 16.0;
                  if (orderController.isLoadingMyOrders &&
                      orderController.myOrders.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (orderController.myOrdersErrorMessage != null &&
                      orderController.myOrders.isEmpty) {
                    return MyOrdersErrorState(
                      message: orderController.myOrdersErrorMessage!,
                      onRetry: () {
                        context.read<OrderController>().fetchMyOrders(
                              refresh: true,
                            );
                      },
                    );
                  }
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 1100,
                      ),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          12,
                          horizontalPadding,
                          30,
                        ),
                        children: [
                          MyOrdersSearchBar(
                            controller: _searchController,
                            searchText: _searchText,
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          if (orders.isEmpty)
                            const MyOrdersEmptyState()
                          else
                            ...orders.map(
                              (order) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 18,
                                ),
                                child: MyOrderCard(
                                  order: order,
                                  alreadySubmitted: _submittedReviews.contains(
                                    order.id.toString(),
                                  ),
                                  onTap: () {
                                    _openOrderDetails(context, order);
                                  },
                                  onWriteReview: () {
                                    _showReviewDialog(context, order);
                                  },
                                ),
                              ),
                            ),
                          if (orderController.isLoadingMoreMyOrders)
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
  void _openOrderDetails(
    BuildContext context,
    OrderInfoModel order,
  ) {
    context.push(
      '/order-details/${order.id}',
    );
  }
}