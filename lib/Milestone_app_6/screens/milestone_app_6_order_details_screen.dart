import 'package:flutter/material.dart';
import '../data/milestone_app_6_address_data.dart';
import '../data/milestone_app_6_cart_item.dart';
import '../data/milestone_app_6_order.dart';
import '../state/milestone_app_6_auth_store.dart';
import '../state/milestone_app_6_state.dart';

class MilestoneApp6OrderDetailsScreen extends StatefulWidget {
  final MilestoneApp6State state;
  final MilestoneApp6AuthStore auth;
  final List<MilestoneApp6CartItem> items;
  final String paymentType;
  final double subtotal;
  final double shipping;
  final double discount;
  final double totalPayment;
  final double minimumPayment;
  final double amountPaidNow;
  final String? orderId;

  const MilestoneApp6OrderDetailsScreen({
    super.key,
    required this.state,
    required this.auth,
    required this.items,
    required this.paymentType,
    required this.subtotal,
    required this.shipping,
    required this.discount,
    required this.totalPayment,
    required this.minimumPayment,
    required this.amountPaidNow,
    this.orderId,
  });

  @override
  State<MilestoneApp6OrderDetailsScreen> createState() =>
      _MilestoneApp6OrderDetailsScreenState();
}

class _MilestoneApp6OrderDetailsScreenState
    extends State<MilestoneApp6OrderDetailsScreen> {
  late final String _orderId;

  @override
  void initState() {
    super.initState();

    if (widget.orderId != null &&
        widget.orderId!.trim().isNotEmpty) {
      _orderId = widget.orderId!;
    } else if (widget.state.orders.isNotEmpty) {
      _orderId = widget.state.orders.first.id;
    } else {
      _orderId =
          DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  // ============================================================
  // CURRENT ORDER
  // ============================================================

  MilestoneApp6Order? get _currentOrder {
    for (final order in widget.state.orders) {
      if (order.id == _orderId) {
        return order;
      }
    }

    return null;
  }

  // ============================================================
  // CUSTOMER
  // ============================================================

  String get _customerName {
    final String name =
    widget.auth.userName.trim();

    if (name.isEmpty) {
      return 'Customer';
    }

    return name;
  }

  // ============================================================
  // ADDRESS
  // ============================================================

  MilestoneApp6Address? get _address {
    return widget.state.selectedAddress;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.state,
      builder: (context, child) {
        final ThemeData theme =
        Theme.of(context);

        return Scaffold(
          backgroundColor:
          const Color(0xFFF8F7F5),

          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor:
            const Color(0xFFF8F7F5),
            foregroundColor: Colors.black,
            centerTitle: true,
            title: const Text(
              'Order Details',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),

          body: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (
                  context,
                  constraints,
                  ) {
                final double horizontalPadding =
                constraints.maxWidth >= 700
                    ? 32.0
                    : 18.0;

                return SingleChildScrollView(
                  physics:
                  const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    4,
                    horizontalPadding,
                    32,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // _backButton(context),

                      const SizedBox(
                        height: 20,
                      ),

                      _orderHeader(context),

                      const SizedBox(
                        height: 18,
                      ),

                      _orderStatusCard(context),

                      const SizedBox(
                        height: 16,
                      ),

                      _timelineCard(context),

                      const SizedBox(
                        height: 16,
                      ),

                      _customerAndAddressCard(
                        context,
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      _orderedItemsCard(context),

                      const SizedBox(
                        height: 16,
                      ),

                      _billCard(context),

                      const SizedBox(
                        height: 16,
                      ),

                      _paymentCard(context),

                      const SizedBox(
                        height: 22,
                      ),

                      _homeButton(
                        context,
                        theme,
                      ),

                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BACK BUTTON
  // ============================================================

  // Widget _backButton(
  //     BuildContext context,
  //     ) {
  //   return InkWell(
  //     borderRadius:
  //     BorderRadius.circular(12),
  //     onTap: () {
  //       Navigator.of(context).pop();
  //     },
  //     child: const Padding(
  //       padding: EdgeInsets.symmetric(
  //         vertical: 6,
  //         horizontal: 2,
  //       ),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(
  //             Icons.arrow_back,
  //             size: 23,
  //             color: Colors.black87,
  //           ),
  //           SizedBox(width: 10),
  //           Text(
  //             'Back to Orders',
  //             style: TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w500,
  //               color: Colors.black87,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // ============================================================
  // ORDER HEADER
  // ============================================================

  Widget _orderHeader(
      BuildContext context,
      ) {
    final MilestoneApp6Order? order =
        _currentOrder;

    final bool isCancelled =
        order?.isCancelled ?? false;

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final bool compact =
            constraints.maxWidth < 370;

        return Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            if (!compact)
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  // Expanded(
                  //   child: _orderTitle(),
                  // ),
                  const SizedBox(
                    width: 12,
                  ),
                  _invoiceButton(context),
                ],
              )
            else
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                 // _orderTitle(),
                  const SizedBox(
                    height: 1,
                  ),
                  _invoiceButton(context),
                ],
              ),

            const SizedBox(
              height: 14,
            ),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment:
              WrapCrossAlignment.center,
              children: [
                Text(
                  'Order ID: #${_shortOrderId(_orderId)}',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                    Colors.grey.shade600,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
                _statusChip(order),
              ],
            ),

            if (!isCancelled &&
                (order?.canCancel ?? true)) ...[
              const SizedBox(
                height: 16,
              ),
              OutlinedButton.icon(
                onPressed: () {
                  _showCancelOrderDialog(
                    context,
                  );
                },
                icon: const Icon(
                  Icons.close,
                  size: 17,
                ),
                label: const Text(
                  'Cancel Order',
                ),
                style:
                OutlinedButton.styleFrom(
                  foregroundColor:
                  const Color(
                    0xFFD62828,
                  ),
                  side: const BorderSide(
                    color: Color(
                      0xFFD62828,
                    ),
                  ),
                  minimumSize:
                  const Size(0, 48),
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 18,
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      13,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  // Widget _orderTitle() {
  //   return const Text(
  //     'Order Details',
  //     maxLines: 1,
  //     overflow:
  //     TextOverflow.ellipsis,
  //     style: TextStyle(
  //       fontSize: 27,
  //       height: 1.15,
  //       fontWeight:
  //       FontWeight.w800,
  //       color: Colors.black,
  //     ),
  //   );
  // }

  // ============================================================
  // INVOICE
  // ============================================================

  Widget _invoiceButton(
      BuildContext context,
      ) {
    return OutlinedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Invoice generated successfully.',
            ),
            behavior:
            SnackBarBehavior.floating,
          ),
        );
      },
      icon: Icon(
        Icons.download_outlined,
        size: 18,
        color: Colors.grey.shade500,
      ),
      label: Text(
        'Generate Invoice',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight:
          FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize:
        const Size(0, 46),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        side: BorderSide(
          color: Colors.grey.shade300,
        ),
        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(
            14,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STATUS CHIP
  // ============================================================

  Widget _statusChip(
      MilestoneApp6Order? order,
      ) {
    if (order == null) {
      return _statusBadge(
        text: 'Placed',
        color:
        const Color(0xFF238B45),
        background:
        const Color(0xFFEAF9EE),
        icon:
        Icons.check_circle_outline,
      );
    }

    if (order.isCancelled) {
      return _statusBadge(
        text: 'Cancelled',
        color:
        const Color(0xFFD62828),
        background:
        const Color(0xFFFFEAEA),
        icon:
        Icons.cancel_outlined,
      );
    }

    if (order.isDelivered) {
      return _statusBadge(
        text: 'Delivered',
        color:
        const Color(0xFF238B45),
        background:
        const Color(0xFFEAF9EE),
        icon:
        Icons.check_circle_outline,
      );
    }

    if (order.isOutForDelivery) {
      return _statusBadge(
        text: 'Out for Delivery',
        color:
        const Color(0xFF2563EB),
        background:
        const Color(0xFFEFF6FF),
        icon:
        Icons.delivery_dining_outlined,
      );
    }

    if (order.isPreparing) {
      return _statusBadge(
        text: 'Preparing',
        color:
        const Color(0xFFE67E22),
        background:
        const Color(0xFFFFF4E8),
        icon:
        Icons.restaurant_outlined,
      );
    }

    return _statusBadge(
      text: 'Placed',
      color:
      const Color(0xFF238B45),
      background:
      const Color(0xFFEAF9EE),
      icon:
      Icons.check_circle_outline,
    );
  }

  Widget _statusBadge({
    required String text,
    required Color color,
    required Color background,
    required IconData icon,
  }) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
        BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 19,
            color: color,
          ),
          const SizedBox(
            width: 7,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ORDER STATUS CARD
  // ============================================================

  Widget _orderStatusCard(
      BuildContext context,
      ) {
    final MilestoneApp6Order? order =
        _currentOrder;

    if (order?.isCancelled == true) {
      return _card(
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration:
              const BoxDecoration(
                color:
                Color(0xFFFFE7E7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cancel,
                color:
                Color(0xFFD62828),
                size: 31,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Text(
                    'Order cancelled',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w800,
                      color:
                      Color(0xFFD62828),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'This order has been cancelled successfully.',
                    style: TextStyle(
                      fontSize: 13,
                      color:
                      Colors.black54,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return _card(
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration:
            const BoxDecoration(
              color:
              Color(0xFFFFE7EA),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color:
              Color(0xFFEF5B6B),
              size: 32,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  'Order placed successfully',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Your restaurant has received your order.',
                  style: TextStyle(
                    fontSize: 13,
                    color:
                    Colors.black54,
                    height: 1.35,
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
  // TIMELINE
  // ============================================================

  Widget _timelineCard(
      BuildContext context,
      ) {
    final MilestoneApp6Order? order =
        _currentOrder;

    if (order?.isCancelled == true) {
      return _card(
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration:
              const BoxDecoration(
                color:
                Color(0xFFFFEAEA),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color:
                Color(0xFFD62828),
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Text(
                    'Order Cancelled',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w800,
                      color:
                      Color(0xFFD62828),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'This order will not be delivered.',
                    style: TextStyle(
                      fontSize: 13,
                      color:
                      Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final bool isPreparing =
        order?.isPreparing ?? false;

    final bool isOutForDelivery =
        order?.isOutForDelivery ?? false;

    final bool isDelivered =
        order?.isDelivered ?? false;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.fromLTRB(
        8,
        22,
        8,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color:
          Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.03,
            ),
            blurRadius: 8,
            offset:
            const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          return Stack(
            children: [
              Positioned(
                left: 40,
                right: 40,
                top: 23,
                child: Container(
                  height: 2,
                  color:
                  const Color(
                    0xFFE5E5E5,
                  ),
                ),
              ),

              Row(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Expanded(
                    child:
                    _timelineStep(
                      title:
                      'Order Placed',
                      subtitle:
                      'Completed',
                      active: true,
                      completed: true,
                    ),
                  ),

                  Expanded(
                    child:
                    _timelineStep(
                      title:
                      'Preparing',
                      subtitle:
                      isPreparing ||
                          isOutForDelivery ||
                          isDelivered
                          ? 'Completed'
                          : 'Pending',
                      active:
                      isPreparing ||
                          isOutForDelivery ||
                          isDelivered,
                      completed:
                      isOutForDelivery ||
                          isDelivered,
                    ),
                  ),

                  Expanded(
                    child:
                    _timelineStep(
                      title:
                      'Out for Delivery',
                      subtitle:
                      isOutForDelivery ||
                          isDelivered
                          ? 'Completed'
                          : 'Pending',
                      active:
                      isOutForDelivery ||
                          isDelivered,
                      completed:
                      isDelivered,
                    ),
                  ),

                  Expanded(
                    child:
                    _timelineStep(
                      title:
                      'Delivered',
                      subtitle:
                      isDelivered
                          ? 'Completed'
                          : 'Pending',
                      active:
                      isDelivered,
                      completed:
                      isDelivered,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _timelineStep({
    required String title,
    required String subtitle,
    required bool active,
    required bool completed,
  }) {
    return Column(
      mainAxisSize:
      MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration:
          BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? const Color(
              0xFFEF6878,
            )
                : Colors.white,
            border: Border.all(
              color: active
                  ? const Color(
                0xFFEF6878,
              )
                  : const Color(
                0xFFE5E5E5,
              ),
              width: 2,
            ),
            boxShadow: active
                ? [
              BoxShadow(
                color:
                const Color(
                  0xFFEF6878,
                ).withOpacity(
                  0.15,
                ),
                blurRadius: 0,
                spreadRadius: 5,
              ),
            ]
                : null,
          ),
          child: active
              ? const Icon(
            Icons.check,
            color: Colors.white,
            size: 25,
          )
              : const Icon(
            Icons.circle,
            color:
            Color(0xFFD5D9DE),
            size: 9,
          ),
        ),

        const SizedBox(
          height: 13,
        ),

        Text(
          title,
          textAlign:
          TextAlign.center,
          maxLines: 2,
          overflow:
          TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            height: 1.2,
            fontWeight: active
                ? FontWeight.w700
                : FontWeight.w500,
            color: active
                ? Colors.black
                : const Color(
              0xFF999999,
            ),
          ),
        ),

        const SizedBox(
          height: 2,
        ),

        Text(
          subtitle,
          textAlign:
          TextAlign.center,
          maxLines: 2,
          overflow:
          TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            height: 1.2,
            fontWeight: active
                ? FontWeight.w500
                : FontWeight.w400,
            color: active
                ? const Color(
              0xFFEF6878,
            )
                : const Color(
              0xFF999999,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CUSTOMER + ADDRESS
  // ============================================================

  Widget _customerAndAddressCard(
      BuildContext context,
      ) {
    final MilestoneApp6Address?
    address = _address;

    return _card(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            icon:
            Icons.location_on_outlined,
            title:
            'Delivery Details',
          ),

          const SizedBox(
            height: 18,
          ),

          Row(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              const Icon(
                Icons.person_outline,
                size: 21,
                color:
                Colors.black54,
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    const Text(
                      'Customer',
                      style:
                      TextStyle(
                        fontSize: 11,
                        color:
                        Colors.black45,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      _customerName,
                      maxLines: 2,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style:
                      const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          Row(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              const Icon(
                Icons.home_outlined,
                size: 21,
                color:
                Colors.black54,
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      address?.label ??
                          'Delivery Address',
                      style:
                      const TextStyle(
                        fontSize: 11,
                        color:
                        Colors.black45,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      address == null
                          ? 'No address selected'
                          : address
                          .fullAddress,
                      style:
                      TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        fontWeight:
                        FontWeight.w600,
                        color: address ==
                            null
                            ? Colors.grey
                            : Colors.black87,
                      ),
                    ),

                    if (address != null &&
                        address.phone
                            .trim()
                            .isNotEmpty) ...[
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        address.phone,
                        style:
                        const TextStyle(
                          fontSize: 13,
                          color:
                          Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ORDERED ITEMS
  // ============================================================

  Widget _orderedItemsCard(
      BuildContext context,
      ) {
    return _card(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            icon:
            Icons.shopping_bag_outlined,
            title:
            'Ordered Items',
            trailing:
            '${widget.items.length} item${widget.items.length == 1 ? '' : 's'}',
          ),

          const SizedBox(
            height: 15,
          ),

          if (widget.items.isEmpty)
            const Padding(
              padding:
              EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Text(
                'No order items found.',
                style: TextStyle(
                  color:
                  Colors.black54,
                ),
              ),
            )
          else
            ...widget.items
                .asMap()
                .entries
                .map(
                  (entry) {
                final int index =
                    entry.key;

                final MilestoneApp6CartItem
                item = entry.value;

                return Padding(
                  padding:
                  EdgeInsets.only(
                    bottom:
                    index ==
                        widget.items
                            .length -
                            1
                        ? 0
                        : 14,
                  ),
                  child:
                  _orderItem(item),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _orderItem(
      MilestoneApp6CartItem item,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:
        const Color(0xFFFAFAFA),
        borderRadius:
        BorderRadius.circular(
          14,
        ),
        border: Border.all(
          color:
          Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
            BorderRadius.circular(
              11,
            ),
            child: Image.network(
              item.food.image,
              width: 68,
              height: 68,
              fit: BoxFit.cover,
              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Container(
                  width: 68,
                  height: 68,
                  color:
                  Colors.grey.shade200,
                  child:
                  const Icon(
                    Icons
                        .fastfood_outlined,
                    color:
                    Colors.grey,
                  ),
                );
              },
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  item.food.name,
                  maxLines: 2,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  'Size: ${item.size}  •  Qty: ${item.quantity}',
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    color:
                    Colors.grey.shade600,
                  ),
                ),

                const SizedBox(
                  height: 7,
                ),

                Text(
                  '\$${item.totalPrice.toStringAsFixed(2)}',
                  style:
                  const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w800,
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
  // BILL
  // ============================================================

  Widget _billCard(
      BuildContext context,
      ) {
    return _card(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            icon:
            Icons.receipt_long_outlined,
            title:
            'Bill Summary',
          ),

          const SizedBox(
            height: 18,
          ),

          _billRow(
            'Item Total',
            '\$${widget.subtotal.toStringAsFixed(2)}',
          ),

          const SizedBox(
            height: 10,
          ),

          _billRow(
            'Delivery Fee',
            '\$${widget.shipping.toStringAsFixed(2)}',
          ),

          if (widget.discount > 0) ...[
            const SizedBox(
              height: 10,
            ),
            _billRow(
              'Discount',
              '-\$${widget.discount.toStringAsFixed(2)}',
              valueColor:
              const Color(
                0xFF238B45,
              ),
            ),
          ],

          const Padding(
            padding:
            EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Divider(
              height: 1,
            ),
          ),

          _billRow(
            'Total',
            '\$${widget.totalPayment.toStringAsFixed(2)}',
            bold: true,
            fontSize: 17,
          ),
        ],
      ),
    );
  }

  Widget _billRow(
      String title,
      String value, {
        bool bold = false,
        double fontSize = 14,
        Color? valueColor,
      }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: bold
                  ? FontWeight.w800
                  : FontWeight.w500,
              color: bold
                  ? Colors.black
                  : Colors.black54,
            ),
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: bold
                ? FontWeight.w900
                : FontWeight.w600,
            color:
            valueColor ??
                Colors.black87,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PAYMENT
  // ============================================================

  Widget _paymentCard(
      BuildContext context,
      ) {
    final MilestoneApp6Order? order =
        _currentOrder;

    final bool isCancelled =
        order?.isCancelled ?? false;

    return _card(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            icon:
            Icons.payment_outlined,
            title:
            'Payment Details',
          ),

          const SizedBox(
            height: 17,
          ),

          Row(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration:
                BoxDecoration(
                  color:
                  const Color(
                    0xFFF1F1F1,
                  ),
                  borderRadius:
                  BorderRadius
                      .circular(
                    11,
                  ),
                ),
                child: const Icon(
                  Icons
                      .credit_card_outlined,
                  size: 21,
                  color:
                  Colors.black54,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    const Text(
                      'Payment Method',
                      style:
                      TextStyle(
                        fontSize: 11,
                        color:
                        Colors.black45,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      widget.paymentType,
                      maxLines: 2,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style:
                      const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.all(
              13,
            ),
            decoration:
            BoxDecoration(
              color:
              isCancelled
                  ? const Color(
                0xFFFFF5F5,
              )
                  : const Color(
                0xFFF7F9F8,
              ),
              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isCancelled
                      ? Icons
                      .info_outline
                      : Icons
                      .check_circle_outline,
                  size: 19,
                  color: isCancelled
                      ? const Color(
                    0xFFD62828,
                  )
                      : const Color(
                    0xFF238B45,
                  ),
                ),

                const SizedBox(
                  width: 9,
                ),

                Expanded(
                  child: Text(
                    isCancelled
                        ? 'Payment details are retained for this cancelled order.'
                        : widget.paymentType ==
                        'Minimum Payment'
                        ? 'Minimum payment received: \$${widget.amountPaidNow.toStringAsFixed(2)}'
                        : 'Payment received: \$${widget.amountPaidNow.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isCancelled
                          ? const Color(
                        0xFFD62828,
                      )
                          : const Color(
                        0xFF238B45,
                      ),
                      fontWeight:
                      FontWeight.w600,
                    ),
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
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle({
    required IconData icon,
    required String title,
    String? trailing,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 21,
          color: Colors.black87,
        ),

        const SizedBox(
          width: 9,
        ),

        Expanded(
          child: Text(
            title,
            style:
            const TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w800,
            ),
          ),
        ),

        if (trailing != null)
          Text(
            trailing,
            style: TextStyle(
              fontSize: 12,
              color:
              Colors.grey.shade500,
              fontWeight:
              FontWeight.w500,
            ),
          ),
      ],
    );
  }

  // ============================================================
  // COMMON CARD
  // ============================================================

  Widget _card({
    required Widget child,
    EdgeInsetsGeometry padding =
    const EdgeInsets.all(17),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(
          19,
        ),
        border: Border.all(
          color:
          Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.035,
            ),
            blurRadius: 10,
            offset:
            const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // HOME BUTTON
  // ============================================================

  Widget _homeButton(
      BuildContext context,
      ThemeData theme,
      ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context)
              .popUntil(
                (route) =>
            route.isFirst,
          );
        },
        icon: const Icon(
          Icons.home_outlined,
          size: 21,
        ),
        label: const Text(
          'Continue Shopping',
          style: TextStyle(
            fontSize: 15,
            fontWeight:
            FontWeight.w800,
          ),
        ),
        style:
        ElevatedButton.styleFrom(
          backgroundColor:
          const Color(
            0xFFEF5B6B,
          ),
          foregroundColor:
          Colors.white,
          elevation: 0,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              15,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CANCEL ORDER
  // ============================================================

  void _showCancelOrderDialog(
      BuildContext context,
      ) {
    final MilestoneApp6Order? order =
        _currentOrder;

    if (order == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Order information could not be found.',
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!order.canCancel) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'This order can no longer be cancelled.',
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (
          dialogContext,
          ) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              22,
            ),
          ),
          title: const Text(
            'Cancel Order?',
            style: TextStyle(
              fontWeight:
              FontWeight.w800,
            ),
          ),
          content: const Text(
            'Are you sure you want to cancel this order?',
            style: TextStyle(
              height: 1.4,
            ),
          ),
          actionsPadding:
          const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            15,
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
              style:
              FilledButton.styleFrom(
                backgroundColor:
                const Color(
                  0xFFD62828,
                ),
              ),
              onPressed: () {
                final bool cancelled =
                widget.state
                    .cancelOrder(
                  order.id,
                );

                Navigator.of(
                  dialogContext,
                ).pop();

                if (!cancelled) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'This order cannot be cancelled now.',
                      ),
                      behavior:
                      SnackBarBehavior
                          .floating,
                    ),
                  );
                  return;
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Order cancelled successfully.',
                    ),
                    behavior:
                    SnackBarBehavior
                        .floating,
                  ),
                );
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
  // SHORT ORDER ID
  // ============================================================

  String _shortOrderId(
      String id,
      ) {
    if (id.length <= 6) {
      return id;
    }

    return id.substring(
      id.length - 6,
    );
  }
}