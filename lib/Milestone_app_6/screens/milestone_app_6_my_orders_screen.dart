import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/milestone_app_6_cart_item.dart';
import '../data/milestone_app_6_order.dart';
import '../state/milestone_app_6_state.dart';
import 'package:provider/provider.dart';
import 'package:app_matic_tech_flutter_app/controllers/order_controller.dart';
import 'package:app_matic_tech_flutter_app/models/order/order_info_model.dart';

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
  final TextEditingController _searchController =
  TextEditingController();

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
        _searchText =
            _searchController.text.trim().toLowerCase();
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
  // ============================================================
// REVIEW DIALOG
// ============================================================

// ============================================================
// REVIEW DIALOG
// ============================================================

  // ============================================================
// REVIEW DIALOG
// ============================================================

  Future<void> _showReviewDialog(
      BuildContext context,
      MilestoneApp6Order order,
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
            // ========================================================
            // SUBMIT VALIDATION
            // ========================================================

            final bool canSubmit =
                selectedRating > 0 &&
                    reviewText.trim().isNotEmpty;

            return Dialog(
              backgroundColor:
              Theme.of(context).cardColor,
              insetPadding:
              const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: ConstrainedBox(
                constraints:
                const BoxConstraints(
                  maxWidth: 625,
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.fromLTRB(
                    30,
                    24,
                    30,
                    20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      // ==================================================
                      // TITLE
                      // ==================================================

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Write a Review',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight:
                                FontWeight.w800,
                                color:
                                Theme.of(context)
                                    .brightness ==
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
                              color:
                              Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),

                      // ==================================================
                      // SUBTITLE
                      // ==================================================

                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                            color:
                            Colors.grey.shade500,
                          ),
                          children: [
                            const TextSpan(
                              text:
                              'How was your experience with ',
                            ),
                            TextSpan(
                              text:
                              order.restaurantName,
                              style: TextStyle(
                                fontWeight:
                                FontWeight.w600,
                                color:
                                Theme.of(context)
                                    .brightness ==
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

                      // ==================================================
                      // STAR RATING
                      // ==================================================

                      Center(
                        child: Row(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: List.generate(
                            5,
                                (index) {
                              final int rating =
                                  index + 1;

                              return GestureDetector(
                                behavior:
                                HitTestBehavior
                                    .opaque,
                                onTap: () {
                                  setDialogState(() {
                                    selectedRating =
                                        rating;
                                  });
                                },
                                child: Padding(
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    horizontal: 4,
                                  ),
                                  child: Icon(
                                    rating <=
                                        selectedRating
                                        ? Icons.star_rounded
                                        : Icons
                                        .star_border_rounded,
                                    size: 38,
                                    color: rating <=
                                        selectedRating
                                        ? const Color(
                                      0xFFFFC107,
                                    )
                                        : Colors
                                        .grey
                                        .shade300,
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
                            color:
                            Colors.grey.shade500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ==================================================
                      // YOUR REVIEW
                      // ==================================================

                      Row(
                        children: [
                          Text(
                            'Your Review',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                              FontWeight.w700,
                              color:
                              Theme.of(context)
                                  .brightness ==
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
                              color:
                              Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // ==================================================
                      // REVIEW TEXT FIELD
                      // ==================================================

                      Container(
                        height: 145,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                            Theme.of(context)
                                .brightness ==
                                Brightness.dark
                                ? Colors.white
                                .withOpacity(0.10)
                                : const Color(
                              0xFFE2E2E2,
                            ),
                          ),
                          borderRadius:
                          BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: TextField(
                          maxLength: 500,
                          maxLines: null,
                          expands: true,
                          textAlignVertical:
                          TextAlignVertical.top,
                          onChanged: (value) {
                            setDialogState(() {
                              reviewText = value;
                            });
                          },
                          decoration:
                          const InputDecoration(
                            counterText: '',
                            border:
                            InputBorder.none,
                            contentPadding:
                            EdgeInsets.all(10),
                            hintText:
                            'Tell us about your experience...',
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ==================================================
                      // BUTTONS
                      // ==================================================

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.end,
                        children: [

                          // CANCEL
                          SizedBox(
                            height: 42,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(
                                  dialogContext,
                                  false,
                                );
                              },
                              style:
                              OutlinedButton
                                  .styleFrom(
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(12),
                                ),
                              ),
                              child:
                              const Text('Cancel'),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // SUBMIT
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
                              style:
                              ElevatedButton
                                  .styleFrom(
                                elevation: 0,
                                backgroundColor:
                                Theme.of(context)
                                    .colorScheme
                                    .primary,
                                disabledBackgroundColor:
                                const Color(
                                  0xFFE5E5E5,
                                ),
                                foregroundColor:
                                Colors.white,
                                disabledForegroundColor:
                                const Color(
                                  0xFF999999,
                                ),
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 20,
                                ),
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(12),
                                ),
                              ),
                              child: const Text(
                                'Submit Review',
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.w700,
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

    // ============================================================
    // SAVE REVIEW AFTER DIALOG IS COMPLETELY CLOSED
    // ============================================================

    if (submitted == true && mounted) {
      setState(() {
        _submittedReviews.add(order.id);
      });
    }
  }

  List<OrderInfoModel> _filteredOrders(
      List<OrderInfoModel> orders,
      ) {
    if (_searchText.isEmpty) {
      return orders;
    }

    return orders.where((order) {
      final restaurant =
      order.restaurant.name.toLowerCase();

      final status =
      order.status.toLowerCase();

      final orderId =
      order.id.toString();

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
        final isDark =
            theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF0D0D0D)
              : const Color(0xFFFAFAFA),

          appBar: AppBar(
            backgroundColor: isDark
                ? const Color(0xFF0D0D0D)
                : const Color(0xFFFAFAFA),
            foregroundColor: isDark
                ? Colors.white
                : const Color(0xFF171717),
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
              return context
                  .read<OrderController>()
                  .fetchMyOrders(
                refresh: true,
              );
            },

            child: NotificationListener<
                ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent -
                          300) {
                    context
                        .read<OrderController>()
                        .loadMoreMyOrders();
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
                  constraints.maxWidth >= 700
                      ? 32.0
                      : 16.0;

                  // ==================================================
                  // INITIAL LOADING
                  // ==================================================

                  if (orderController
                      .isLoadingMyOrders &&
                      orderController.myOrders.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // ==================================================
                  // ERROR
                  // ==================================================

                  if (orderController
                      .myOrdersErrorMessage !=
                      null &&
                      orderController.myOrders.isEmpty) {
                    return _errorOrders(
                      context,
                      orderController
                          .myOrdersErrorMessage!,
                    );
                  }

                  // ==================================================
                  // CONTENT
                  // ==================================================

                  return Center(
                    child: ConstrainedBox(
                      constraints:
                      const BoxConstraints(
                        maxWidth: 1100,
                      ),
                      child: ListView(
                        physics:
                        const AlwaysScrollableScrollPhysics(),

                        padding:
                        EdgeInsets.fromLTRB(
                          horizontalPadding,
                          12,
                          horizontalPadding,
                          30,
                        ),

                        children: [
                          _searchBar(),

                          const SizedBox(
                            height: 22,
                          ),

                          if (orders.isEmpty)
                            _emptyOrders()
                          else
                            ...orders.map(
                                  (order) => Padding(
                                padding:
                                const EdgeInsets.only(
                                  bottom: 18,
                                ),
                                child: _orderCard(
                                  context,
                                  order,
                                ),
                              ),
                            ),

                          if (orderController
                              .isLoadingMoreMyOrders)
                            const Padding(
                              padding:
                              EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              child: Center(
                                child:
                                CircularProgressIndicator(),
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
  Widget _errorOrders(
      BuildContext context,
      String message,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 55,
              color: Colors.red,
            ),

            const SizedBox(height: 14),

            const Text(
              'Unable to load orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 18),

            FilledButton(
              onPressed: () {
                context
                    .read<OrderController>()
                    .fetchMyOrders(
                  refresh: true,
                );
              },
              child: const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _searchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFE3E3E3),
        ),
      ),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF8D8D8D),
          ),
          suffixIcon: _searchText.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();
            },
            icon: const Icon(
              Icons.close,
            ),
          )
              : null,
          hintText:
          'Search restaurant or ordered items...',
          hintStyle: const TextStyle(
            color: Color(0xFFA5A5A5),
            fontSize: 14,
          ),
          contentPadding:
          const EdgeInsets.symmetric(
            vertical: 17,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ORDER CARD
  // ============================================================
  Widget _orderCard(
      BuildContext context,
      OrderInfoModel order,
      ) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    final cardColor = isDark
        ? const Color(0xFF111111)
        : Colors.white;

    final borderColor = isDark
        ? Colors.white.withOpacity(0.08)
        : const Color(0xFFE8E8E8);

    return GestureDetector(
      onTap: () {
        context.push(
          '/order-details',
          extra: {
            'state': widget.state,
            'orderId': order.id,
          },
        );
      },

      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          color: cardColor,
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                isDark ? 0.28 : 0.05,
              ),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        clipBehavior: Clip.antiAlias,

        child: Column(
          children: [
            _restaurantHeader(
              context,
              order,
            ),

            _allOrderItems(
              order,
            ),

            _orderInformation(
              order,
            ),

            _orderActions(
              context,
              order,
            ),
          ],
        ),
      ),
    );
  }
  // ============================================================
  // RESTAURANT HEADER
  // ============================================================
  Widget _restaurantHeader(
      BuildContext context,
      OrderInfoModel order,
      ) {
    final theme = Theme.of(context);

    final isDark =
        theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        14,
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white
                    .withOpacity(0.08)
                    : Colors.grey.shade200,
              ),
            ),

            clipBehavior: Clip.antiAlias,

            child: Image.network(
              order.restaurant.imageUrl,

              fit: BoxFit.cover,

              errorBuilder:
                  (context, error, stackTrace) {
                return Container(
                  color: isDark
                      ? const Color(0xFF242424)
                      : const Color(0xFFF3F3F3),

                  child: Icon(
                    Icons.restaurant_rounded,
                    size: 28,
                    color: Colors.grey.shade500,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        order.restaurant.name,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                          FontWeight.w800,
                          color: isDark
                              ? Colors.white
                              : const Color(
                            0xFF171717,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      '#${order.id}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w700,
                        color: isDark
                            ? Colors.grey.shade500
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: isDark
                          ? Colors.grey.shade500
                          : Colors.grey.shade600,
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        order.restaurant.address,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey.shade500
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 9),

                _apiStatusBadge(
                  context,
                  order.status,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _apiStatusBadge(
      BuildContext context,
      String status,
      ) {
    final color = _apiStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.20),
        ),
      ),

      child: Text(
        _formatStatus(status),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  Color _apiStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'placed':
        return const Color(0xFFE67E22);

      case 'preparing':
        return const Color(0xFFE67E22);

      case 'out_for_delivery':
        return const Color(0xFF3B82F6);

      case 'delivered':
        return const Color(0xFF16A34A);

      case 'cancelled':
        return const Color(0xFFD62828);

      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    if (status.isEmpty) {
      return 'Unknown';
    }

    return status
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
          ? word
          : '${word[0].toUpperCase()}'
          '${word.substring(1).toLowerCase()}',
    )
        .join(' ');
  }
  // ============================================================
  // PRODUCT
  // ============================================================
  Widget _allOrderItems(
      OrderInfoModel order,
      ) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF161616)
            : const Color(0xFFFCFCFC),
      ),

      child: Column(
        children: [
          for (
          int index = 0;
          index < order.orderItems.length;
          index++
          ) ...[
            _productRow(
              order.orderItems[index],
            ),

            if (
            index !=
                order.orderItems.length - 1)
              Divider(
                height: 1,
                color: isDark
                    ? Colors.white
                    .withOpacity(0.07)
                    : Colors.grey.shade200,
              ),
          ],
        ],
      ),
    );
  }
  Widget _productRow(
      OrderItemModel item,
      ) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(10),
              color: isDark
                  ? const Color(0xFF252525)
                  : const Color(0xFFF3F3F3),
            ),

            clipBehavior:
            Clip.antiAlias,

            child: Image.network(
              item.menuItem.imageUrl,

              fit: BoxFit.cover,

              errorBuilder:
                  (context, error, stackTrace) {
                return Icon(
                  Icons.fastfood_outlined,
                  size: 25,
                  color: isDark
                      ? Colors.grey.shade600
                      : Colors.grey.shade400,
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  item.menuItem.name,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w800,
                    color: isDark
                        ? Colors.white
                        : const Color(
                      0xFF171717,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '₹${item.priceAtPurchase.toStringAsFixed(2)} × ${item.quantity}',

                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? Colors.grey.shade500
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            '₹${item.totalPrice.toStringAsFixed(2)}',

            style: TextStyle(
              fontSize: 13,
              fontWeight:
              FontWeight.w900,
              color: isDark
                  ? Colors.white
                  : const Color(
                0xFF171717,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _miniInfo(
      String text,
      bool isDark,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 1,
        vertical: 3,
      ),

      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isDark
              ? Colors.grey.shade400
              : Colors.grey.shade700,
        ),
      ),
    );
  }

  // ============================================================
  // ORDER INFORMATION
  // ============================================================
  Widget _orderInformation(
      OrderInfoModel order,
      ) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final statusColor =
    _apiStatusColor(order.status);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Placed',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? Colors.grey.shade500
                        : Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _formatApiDate(
                    order.createdAt,
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w600,
                    color: isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Status',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? Colors.grey.shade500
                        : Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration:
                      BoxDecoration(
                        color: statusColor,
                        shape:
                        BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Flexible(
                      child: Text(
                        _formatStatus(
                          order.status,
                        ),
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w600,
                          color:
                          statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? Colors.grey.shade500
                        : Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '₹${order.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w800,
                    color: isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  String _formatApiDate(
      String? value,
      ) {
    if (value == null ||
        value.trim().isEmpty) {
      return '--';
    }

    final date = DateTime.tryParse(value);

    if (date == null) {
      return value;
    }

    final hour = date.hour % 12 == 0
        ? 12
        : date.hour % 12;

    final minute =
    date.minute.toString().padLeft(2, '0');

    final period =
    date.hour >= 12 ? 'pm' : 'am';

    return '${date.day} '
        '${_month(date.month)} '
        '${date.year}, '
        '$hour:$minute $period';
  }

  Widget _infoItem(
      String title,
      String value, {
        Color? valueColor,
        bool showDot = false,
        bool bold = false,
        bool large = false,
        bool alignRight = false,
      }) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(
          height: 6,
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDot) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: valueColor,
                ),
              ),
              const SizedBox(
                width: 6,
              ),
            ],

            Flexible(
              child: Text(
                value,
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
                textAlign: alignRight
                    ? TextAlign.right
                    : TextAlign.left,
                style: TextStyle(
                  fontSize: large ? 17 : 14,
                  fontWeight: bold
                      ? FontWeight.w900
                      : FontWeight.w500,
                  color:
                  valueColor ?? Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // ACTIONS
  // ============================================================

  // ============================================================
// ORDER ACTIONS
// ============================================================

// ============================================================
// ORDER ACTIONS
// ============================================================

  Widget _orderActions(
      BuildContext context,
      OrderInfoModel order,
      ) {
    final status =
    order.status.toLowerCase();

    final bool isCancelled =
        status == 'cancelled';

    final bool isDelivered =
        status == 'delivered';

    if (isDelivered) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          14,
        ),
        child: Align(
          alignment:
          Alignment.centerRight,
          child: _actionButton(
            label: 'Write a Review',
            filled: true,
            onTap: () {
              // Keep your existing review dialog
              // after converting it to OrderInfoModel.
            },
          ),
        ),
      );
    }

    if (isCancelled) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          14,
        ),
        child: Align(
          alignment:
          Alignment.centerRight,
          child: _cancelledLabel(),
        ),
      );
    }

    return const SizedBox.shrink();
  }
  // ============================================================
// REVIEW SUBMITTED
// ============================================================

// ============================================================
// REVIEW SUBMITTED
// ============================================================

  Widget _reviewSubmittedLabel() {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 38,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF12351F)
              : const Color(0xFFEFFFF4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.check_rounded,
              size: 16,
              color: Color(0xFF00A651),
            ),
            SizedBox(width: 5),
            Text(
              'Review Submitted',
              style: TextStyle(
                color: Color(0xFF00A651),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BUTTON
  // ============================================================
  // ============================================================
// REVIEW BUTTON
// ============================================================

  Widget _actionButton({
    required String label,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    final Color accent =
        theme.colorScheme.primary;

    return SizedBox(
      height: 38,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor:
          filled ? accent : Colors.transparent,
          foregroundColor:
          filled
              ? Colors.white
              : isDark
              ? Colors.white
              : Colors.black87,
          side: BorderSide(
            color: filled
                ? accent
                : isDark
                ? Colors.white.withOpacity(0.15)
                : Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10),
          ),
          padding:
          const EdgeInsets.symmetric(
            horizontal: 16,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  // ============================================================
// CANCELLED LABEL
// ============================================================

  Widget _cancelledLabel() {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Container(
      height: 34,
      width: 117,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF3A1717)
            : const Color(0xFFFFEAEA),
        borderRadius:
        BorderRadius.circular(9),
      ),
      child: const Text(
        'Order Cancelled',
        style: TextStyle(
          color: Color(0xFFD62828),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // CANCEL
  // ============================================================

  void _confirmCancel(
      BuildContext context,
      MilestoneApp6Order order,
      ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: const Text(
            'Cancel Order?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Are you sure you want to cancel '
                '${order.food.name} from '
                '${order.restaurantName}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child: const Text(
                'Keep Order',
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                const Color(0xFFD62828),
              ),
              onPressed: () {
                final cancelled =
                widget.state.cancelOrder(
                  order.id,
                );

                Navigator.of(
                  dialogContext,
                ).pop();

                if (cancelled) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Order cancelled successfully.',
                      ),
                      behavior:
                      SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text(
                'Cancel Order',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ORDER DETAILS
  // ============================================================

  void _openOrderDetails(
      BuildContext context,
      MilestoneApp6Order order,
      ) {
    context.push(
      '/order-details',
      extra: {
        'state': widget.state,
        'items': [
          MilestoneApp6CartItemForOrder(
            order: order,
          ).item,
        ],
        'paymentType': order.paymentType,
        'subtotal': order.totalPrice,
        'shipping': 0.0,
        'discount': 0.0,
        'totalPayment': order.totalPrice,
        'minimumPayment': order.totalPrice,
        'amountPaidNow': order.totalPrice,
      },
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _emptyOrders() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 70,
        horizontal: 25,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 65,
            color: Colors.grey.shade400,
          ),

          const SizedBox(
            height: 15,
          ),

          const Text(
            'No orders yet',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 7,
          ),

          Text(
            'Your confirmed orders will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS COLOR
  // ============================================================

  Color _statusColor(
      MilestoneApp6OrderStatus status,
      ) {
    switch (status) {
      case MilestoneApp6OrderStatus.placed:
        return const Color(0xFFE67E22);

      case MilestoneApp6OrderStatus.preparing:
        return const Color(0xFFE67E22);

      case MilestoneApp6OrderStatus.outForDelivery:
        return const Color(0xFF3B82F6);

      case MilestoneApp6OrderStatus.delivered:
        return const Color(0xFF16A34A);

      case MilestoneApp6OrderStatus.cancelled:
        return const Color(0xFFD62828);
    }
  }

  // ============================================================
  // DATE
  // ============================================================

  String _formatDate(DateTime date) {
    final hour = date.hour % 12 == 0
        ? 12
        : date.hour % 12;

    final minute =
    date.minute.toString().padLeft(2, '0');

    final period =
    date.hour >= 12 ? 'pm' : 'am';

    return '${date.day} ${_month(date.month)} '
        '${date.year}, '
        '$hour:$minute $period';
  }

  String _month(int month) {
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

  String _shortOrderId(String id) {
    if (id.length <= 6) {
      return id;
    }

    return id.substring(
      id.length - 6,
    );
  }
}

// ============================================================
// CART ITEM ADAPTER
// ============================================================

class MilestoneApp6CartItemForOrder {
  final MilestoneApp6Order order;

  const MilestoneApp6CartItemForOrder({
    required this.order,
  });

  dynamic get item {
    return MilestoneApp6CartItem(
      food: order.food,
      size: order.size,
      unitPrice: order.unitPrice,
      quantity: order.quantity,
    );
  }
}