import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/milestone_app_6_cart_item.dart';
import '../data/milestone_app_6_order.dart';
import '../state/milestone_app_6_state.dart';

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

  String _searchText = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MilestoneApp6Order> _filteredOrders(
      List<MilestoneApp6Order> orders,
      ) {
    if (_searchText.isEmpty) {
      return orders;
    }

    return orders.where((order) {
      final foodName = order.food.name.toLowerCase();
      final restaurant = order.food.restaurant.toLowerCase();
      final status = order.statusText.toLowerCase();

      return foodName.contains(_searchText) ||
          restaurant.contains(_searchText) ||
          status.contains(_searchText);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.state,
      builder: (context, child) {
        final orders = _filteredOrders(
          widget.state.orders,
        );

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),

          appBar: AppBar(
            backgroundColor: const Color(0xFFFAFAFA),
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

          body: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding =
              constraints.maxWidth >= 700
                  ? 32.0
                  : 16.0;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1100,
                  ),
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
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
                            padding: const EdgeInsets.only(
                              bottom: 18,
                            ),
                            child: _orderCard(
                              context,
                              order,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
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
        borderRadius: BorderRadius.circular(15),
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
      MilestoneApp6Order order,
      ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE4E4E4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _restaurantHeader(
            context,
            order,
          ),

          const Divider(
            height: 1,
          ),

          _allOrderItems(order),

          const Divider(
            height: 1,
          ),

          _orderInformation(order),

          const Divider(
            height: 1,
          ),

          _orderActions(
            context,
            order,
          ),
        ],
      ),
    );
  }
  // ============================================================
  // RESTAURANT HEADER
  // ============================================================
  Widget _restaurantHeader(
      BuildContext context,
      MilestoneApp6Order order,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        30,
        28,
        30,
        28,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.network(
              order.restaurantImage,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Container(
                  width: 100,
                  height: 100,
                  color: const Color(0xFFF0F0F0),
                  child: const Icon(
                    Icons.restaurant,
                    size: 35,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),

          const SizedBox(
            width: 25,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.restaurantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 22,
                      color: Colors.grey.shade600,
                    ),

                    const SizedBox(
                      width: 7,
                    ),

                    Expanded(
                      child: Text(
                        order.restaurantAddress.isNotEmpty
                            ? order.restaurantAddress
                            : 'Ahmedabad',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 15,
          ),

          Text(
            '#${_shortOrderId(order.id)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  // ============================================================
  // PRODUCT
  // ============================================================
  Widget _allOrderItems(MilestoneApp6Order order) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        30,
        20,
        30,
        20,
      ),
      child: Column(
        children: [
          for (int index = 0; index < order.items.length; index++) ...[
            _productRow(order.items[index]),

            if (index != order.items.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(
                  height: 1,
                ),
              ),
          ],
        ],
      ),
    );
  }
  Widget _productRow(MilestoneApp6CartItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            item.food.image,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: (
                context,
                error,
                stackTrace,
                ) {
              return Container(
                width: 72,
                height: 72,
                color: const Color(0xFFF0F0F0),
                child: const Icon(
                  Icons.fastfood_outlined,
                  color: Colors.grey,
                  size: 30,
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.food.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Size: ${item.size}  •  Qty: ${item.quantity}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                '\$${item.unitPrice.toStringAsFixed(2)} × ${item.quantity}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Text(
          '\$${item.totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ORDER INFORMATION
  // ============================================================

  Widget _orderInformation(
      MilestoneApp6Order order,
      ) {
    final statusColor =
    _statusColor(order.status);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        18,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 550) {
            return Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _infoItem(
                  'Order Placed',
                  _formatDate(order.orderDate),
                ),

                const SizedBox(
                  height: 15,
                ),

                _infoItem(
                  'Delivery Status',
                  order.statusText,
                  valueColor: statusColor,
                  showDot: true,
                ),

                const SizedBox(
                  height: 15,
                ),

                _infoItem(
                  'Total',
                  '₹${order.totalPrice.toStringAsFixed(2)}',
                  bold: true,
                  large: true,
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _infoItem(
                  'Order Placed',
                  _formatDate(order.orderDate),
                ),
              ),

              Expanded(
                flex: 2,
                child: _infoItem(
                  'Delivery Status',
                  order.statusText,
                  valueColor: statusColor,
                  showDot: true,
                ),
              ),

              Expanded(
                child: Align(
                  alignment:
                  Alignment.centerRight,
                  child: _infoItem(
                    'Total',
                    '₹${order.totalPrice.toStringAsFixed(2)}',
                    bold: true,
                    large: true,
                    alignRight: true,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
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

  Widget _orderActions(
      BuildContext context,
      MilestoneApp6Order order,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        14,
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.end,
        children: [
          if (order.isDelivered)
            _actionButton(
              label: 'Write a Review',
              filled: true,
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Review feature coming soon.',
                    ),
                    behavior:
                    SnackBarBehavior.floating,
                  ),
                );
              },
            ),

          if (order.isCancelled)
            _cancelledLabel(),

          if (order.canCancel)
            _actionButton(
              label: 'Cancel Order',
              filled: false,
              danger: true,
              onTap: () {
                _confirmCancel(
                  context,
                  order,
                );
              },
            ),

          const SizedBox(
            width: 10,
          ),

          _actionButton(
            label: 'View Details',
            filled: false,
            onTap: () {
              _openOrderDetails(
                context,
                order,
              );
            },
          ),

          const SizedBox(
            width: 4,
          ),

          if (!order.isCancelled)
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_horiz,
              ),
              onSelected: (value) {
                if (value == 'preparing') {
                  widget.state.updateOrderStatus(
                    order.id,
                    MilestoneApp6OrderStatus.preparing,
                  );
                }

                if (value == 'out') {
                  widget.state.updateOrderStatus(
                    order.id,
                    MilestoneApp6OrderStatus.outForDelivery,
                  );
                }

                if (value == 'delivered') {
                  widget.state.markOrderDelivered(
                    order.id,
                  );
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 'preparing',
                    child: Text(
                      'Mark Preparing',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'out',
                    child: Text(
                      'Mark Out for Delivery',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delivered',
                    child: Text(
                      'Mark Delivered',
                    ),
                  ),
                ];
              },
            ),
        ],
      ),
    );
  }

  // ============================================================
  // BUTTON
  // ============================================================

  Widget _actionButton({
    required String label,
    required VoidCallback onTap,
    bool filled = false,
    bool danger = false,
  }) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: filled
              ? const Color(0xFFE45B6B)
              : Colors.white,
          foregroundColor: danger
              ? const Color(0xFFD62828)
              : filled
              ? Colors.white
              : Colors.black87,
          side: BorderSide(
            color: danger
                ? const Color(0xFFD62828)
                : filled
                ? const Color(0xFFE45B6B)
                : Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
          padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _cancelledLabel() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFEAEA),
        borderRadius:
        BorderRadius.circular(10),
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