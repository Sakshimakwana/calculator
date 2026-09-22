import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/milestone_app_6_cart_item.dart';
import '../state/milestone_app_6_state.dart';
import '../widgets/milestone_app_6_button.dart';
import '../widgets/milestone_app_6_image.dart';

class MilestoneApp6OrderDetailsScreen
    extends StatelessWidget {
  final MilestoneApp6State state;

  final List<MilestoneApp6CartItem>
  items;

  final String paymentType;

  final double subtotal;

  final double shipping;

  final double discount;

  final double totalPayment;

  final double minimumPayment;

  final double amountPaidNow;

  const MilestoneApp6OrderDetailsScreen({
    super.key,
    required this.state,
    required this.items,
    required this.paymentType,
    required this.subtotal,
    required this.shipping,
    required this.discount,
    required this.totalPayment,
    required this.minimumPayment,
    required this.amountPaidNow,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
        false,
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight:
            FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding:
          const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            30,
          ),
          children: [
            _successCard(context),

            const SizedBox(
              height: 18,
            ),

            _orderInformation(
              context,
            ),

            const SizedBox(
              height: 18,
            ),

            _itemsSection(context),

            const SizedBox(
              height: 18,
            ),

            _addressSection(context),

            const SizedBox(
              height: 18,
            ),

            _billSection(context),

            const SizedBox(
              height: 18,
            ),

            _paymentSection(context),

            const SizedBox(
              height: 24,
            ),

            MilestoneApp6Button(
              label: 'Continue Shopping',
              onPressed: () {
                context.go('/home');
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // SUCCESS CARD
  // ================================================================

  Widget _successCard(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    return Container(
      padding:
      const EdgeInsets.all(22),
      decoration:
      BoxDecoration(
        color: theme
            .colorScheme
            .primary
            .withOpacity(.08),
        borderRadius:
        BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration:
            const BoxDecoration(
              color: Colors.green,
              shape:
              BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 42,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Order Confirmed!',
            style: TextStyle(
              fontSize: 24,
              fontWeight:
              FontWeight.w900,
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            'Your order has been placed successfully.',
            textAlign:
            TextAlign.center,
            style: TextStyle(
              color:
              theme.hintColor,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ORDER INFORMATION
  // ================================================================

  Widget _orderInformation(
      BuildContext context,
      ) {
    final orderId =
    DateTime.now()
        .millisecondsSinceEpoch
        .toString();

    return _card(
      context,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          _infoRow(
            'Order ID',
            '#${orderId.substring(orderId.length - 8)}',
          ),
          const SizedBox(height: 9),
          _infoRow(
            'Items',
            '${items.length}',
          ),
          const SizedBox(height: 9),
          _infoRow(
            'Payment',
            paymentType,
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ITEMS
  // ================================================================

  Widget _itemsSection(
      BuildContext context,
      ) {
    return _card(
      context,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Ordered Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          ...items.map(
                (item) => Padding(
              padding:
              const EdgeInsets.only(
                bottom: 14,
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  MilestoneApp6Image(
                    url:
                    item.food.image,
                    width: 62,
                    height: 62,
                    borderRadius:
                    BorderRadius
                        .circular(
                      12,
                    ),
                  ),
                  const SizedBox(
                    width: 11,
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
                            fontWeight:
                            FontWeight
                                .w800,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Size: ${item.size}',
                          style:
                          TextStyle(
                            fontSize: 11,
                            color: Theme.of(
                              context,
                            )
                                .colorScheme
                                .primary,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Qty: ${item.quantity}',
                          style:
                          TextStyle(
                            fontSize: 11,
                            color:
                            Theme.of(
                              context,
                            ).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style:
                    const TextStyle(
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ADDRESS
  // ================================================================

  Widget _addressSection(
      BuildContext context,
      ) {
    final address =
        state.selectedAddress;

    return _card(
      context,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Address',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (address == null)
            const Text(
              'No address available.',
            )
          else
            Row(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Icon(
                  Icons
                      .location_on_outlined,
                  color: Theme.of(
                    context,
                  )
                      .colorScheme
                      .primary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        address.label,
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight
                              .w800,
                        ),
                      ),
                      if (address.name
                          .trim()
                          .isNotEmpty) ...[
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          address.name,
                        ),
                      ],
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        address.fullAddress,
                        style: TextStyle(
                          color:
                          Theme.of(
                            context,
                          ).hintColor,
                          fontSize: 12,
                        ),
                      ),
                      if (address.phone
                          .trim()
                          .isNotEmpty) ...[
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          address.phone,
                          style:
                          TextStyle(
                            color:
                            Theme.of(
                              context,
                            ).hintColor,
                            fontSize: 11,
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

  // ================================================================
  // BILL
  // ================================================================

  Widget _billSection(
      BuildContext context,
      ) {
    return _card(
      context,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Bill Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),
          _billRow(
            'Item Total',
            '\$${subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _billRow(
            'Delivery Fee',
            '\$${shipping.toStringAsFixed(2)}',
          ),
          if (discount > 0) ...[
            const SizedBox(height: 10),
            _billRow(
              'Discount',
              '-\$${discount.toStringAsFixed(2)}',
              color: Colors.green,
            ),
          ],
          const Padding(
            padding:
            EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Divider(),
          ),
          _billRow(
            'Total',
            '\$${totalPayment.toStringAsFixed(2)}',
            bold: true,
          ),
        ],
      ),
    );
  }

  // ================================================================
  // PAYMENT
  // ================================================================

  Widget _paymentSection(
      BuildContext context,
      ) {
    return _card(
      context,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          _infoRow(
            'Payment Type',
            paymentType,
          ),
          const SizedBox(height: 10),
          _infoRow(
            'Paid Now',
            '\$${amountPaidNow.toStringAsFixed(2)}',
          ),
          if (paymentType ==
              'Minimum Payment') ...[
            const SizedBox(height: 10),
            _infoRow(
              'Remaining Amount',
              '\$${(totalPayment - amountPaidNow).toStringAsFixed(2)}',
            ),
          ],
        ],
      ),
    );
  }

  // ================================================================
  // CARD
  // ================================================================

  Widget _card(
      BuildContext context, {
        required Widget child,
      }) {
    final theme =
    Theme.of(context);

    return Container(
      padding:
      const EdgeInsets.all(16),
      decoration:
      BoxDecoration(
        color:
        theme.colorScheme.surface,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor
              .withOpacity(.25),
        ),
      ),
      child: child,
    );
  }

  Widget _infoRow(
      String title,
      String value,
      ) {
    return Row(
      children: [
        Text(
          title,
          style:
          const TextStyle(
            fontSize: 12,
            fontWeight:
            FontWeight.w600,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign:
            TextAlign.right,
            style:
            const TextStyle(
              fontSize: 12,
              fontWeight:
              FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _billRow(
      String title,
      String value, {
        bool bold = false,
        Color? color,
      }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize:
            bold ? 15 : 13,
            fontWeight: bold
                ? FontWeight.w800
                : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize:
            bold ? 16 : 13,
            fontWeight: bold
                ? FontWeight.w900
                : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}