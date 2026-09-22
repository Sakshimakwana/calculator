import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/milestone_app_6_address_data.dart';
import '../data/milestone_app_6_cart_item.dart';
import '../state/milestone_app_6_state.dart';
import '../widgets/milestone_app_6_button.dart';
import '../widgets/milestone_app_6_image.dart';

class MilestoneApp6CartScreen
    extends StatefulWidget {
  final MilestoneApp6State state;

  const MilestoneApp6CartScreen({
    super.key,
    required this.state,
  });

  @override
  State<MilestoneApp6CartScreen>
  createState() =>
      _MilestoneApp6CartScreenState();
}

class _MilestoneApp6CartScreenState
    extends State<MilestoneApp6CartScreen> {
  late final TextEditingController
  _promoController;

  MilestoneApp6State get state =>
      widget.state;

  @override
  void initState() {
    super.initState();

    _promoController =
        TextEditingController(
          text:
          state.appliedPromoCode ?? '',
        );
  }

  @override
  void dispose() {
    _promoController.dispose();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return AnimatedBuilder(
      animation: state,
      builder: (
          context,
          child,
          ) {
        final items =
        state.cart.values.toList();

        return Scaffold(
          appBar:
          _appBar(context),
          body: items.isEmpty
              ? _emptyCart(context)
              : SafeArea(
            child: Column(
              children: [
                Expanded(
                  child:
                  ListView(
                    padding:
                    const EdgeInsets
                        .fromLTRB(
                      16,
                      12,
                      16,
                      20,
                    ),
                    children: [
                      _deliveryAddress(
                        context,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        children: [
                          const Expanded(
                            child:
                            Text(
                              'Your Items',
                              style:
                              TextStyle(
                                fontSize:
                                19,
                                fontWeight:
                                FontWeight
                                    .w800,
                              ),
                            ),
                          ),
                          Text(
                            '${state.cartCount} item${state.cartCount == 1 ? '' : 's'}',
                            style:
                            TextStyle(
                              fontSize:
                              13,
                              color:
                              Theme.of(
                                context,
                              ).hintColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      ...items.map(
                            (
                            item,
                            ) =>
                            _cartItem(
                              context,
                              item,
                            ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      _promoSection(
                        context,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      _summary(
                        context,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      _paymentInfo(
                        context,
                      ),
                    ],
                  ),
                ),

                _bottomCheckoutBar(
                  context,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================================================================
  // APP BAR
  // ================================================================

  PreferredSizeWidget _appBar(
      BuildContext context,
      ) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          context.go('/home');
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
        ),
      ),
      title: const Text(
        'My Cart',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        if (state.cartCount > 0)
          IconButton(
            tooltip: 'Clear cart',
            onPressed: () {
              _showClearCartDialog(
                context,
              );
            },
            icon: const Icon(
              Icons
                  .delete_sweep_outlined,
            ),
          ),
      ],
    );
  }

  // ================================================================
  // DELIVERY ADDRESS
  // ================================================================

  Widget _deliveryAddress(BuildContext context) {
    final theme = Theme.of(context);
    final address = state.selectedAddress;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(.25),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary
                      .withOpacity(.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Where should we deliver your order?',
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              TextButton(
                onPressed: () {
                  context.push(
                    '/profile/address',
                    extra: state,
                  );
                },
                child: Text(
                  address == null ? 'Add' : 'Change',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),

          if (address != null) ...[
            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary
                    .withOpacity(.05),
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    _addressIcon(address.label),
                    size: 19,
                    color:
                    theme.colorScheme.primary,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.label,
                          style: const TextStyle(
                            fontWeight:
                            FontWeight.w800,
                          ),
                        ),

                        if (address.name
                            .trim()
                            .isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            address.name,
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ],

                        const SizedBox(height: 5),

                        Text(
                          address.fullAddress,
                          style: TextStyle(
                            color:
                            theme.hintColor,
                            fontSize: 12,
                          ),
                        ),

                        if (address.phone
                            .trim()
                            .isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            address.phone,
                            style: TextStyle(
                              color:
                              theme.hintColor,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================================================================
  // ADDRESS ICON
  // ================================================================

  IconData _addressIcon(
      String label,
      ) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;

      case 'work':
        return Icons.business_outlined;

      default:
        return Icons
            .location_on_outlined;
    }
  }


  // ================================================================
  // CART ITEM
  // ================================================================

  Widget _cartItem(
      BuildContext context,
      MilestoneApp6CartItem item,
      ) {
    final theme =
    Theme.of(context);

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 12,
      ),
      padding:
      const EdgeInsets.all(11),
      decoration:
      BoxDecoration(
        color:
        theme.colorScheme.surface,
        borderRadius:
        BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: theme.dividerColor
              .withOpacity(0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // IMAGE
          MilestoneApp6Image(
            url: item.food.image,
            width: 88,
            height: 88,
            borderRadius:
            BorderRadius.circular(
              15,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          // DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Expanded(
                      child: Text(
                        item.food.name,
                        maxLines: 2,
                        overflow:
                        TextOverflow
                            .ellipsis,
                        style:
                        const TextStyle(
                          fontSize: 14,
                          fontWeight:
                          FontWeight
                              .w800,
                        ),
                      ),
                    ),

                    IconButton(
                      padding:
                      EdgeInsets.zero,
                      constraints:
                      const BoxConstraints(),
                      onPressed: () {
                        _showDeleteDialog(
                          context,
                          item,
                        );
                      },
                      icon: Icon(
                        Icons
                            .delete_outline_rounded,
                        size: 20,
                        color: Colors.red
                            .withOpacity(
                          0.85,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  'Size: ${item.size}',
                  style: TextStyle(
                    color: theme
                        .colorScheme
                        .primary,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  '\$${item.unitPrice.toStringAsFixed(2)} each',
                  style: TextStyle(
                    color:
                    theme.hintColor,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(
                  height: 9,
                ),

                Row(
                  children: [
                    _counter(
                      context,
                      Icons.remove,
                          () {
                        state
                            .removeFromCart(
                          item.food,
                          size:
                          item.size,
                        );
                      },
                    ),

                    Padding(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 13,
                      ),
                      child: Text(
                        '${item.quantity}',
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight
                              .w800,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    _counter(
                      context,
                      Icons.add,
                          () {
                        state.addToCart(
                          item.food,
                          size:
                          item.size,
                          unitPrice:
                          item.unitPrice,
                        );
                      },
                    ),

                    const Spacer(),

                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style:
                      const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight
                            .w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // DELETE DIALOG
  // ================================================================

  void _showDeleteDialog(
      BuildContext context,
      MilestoneApp6CartItem item,
      ) {
    showDialog(
      context: context,
      builder: (
          dialogContext,
          ) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              20,
            ),
          ),
          title: const Text(
            'Remove item?',
            style: TextStyle(
              fontWeight:
              FontWeight.w800,
            ),
          ),
          content: Text(
            'Remove ${item.food.name} (${item.size}) from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
              const Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                state.deleteFromCart(
                  item.food,
                  size: item.size,
                );

                Navigator.pop(
                  dialogContext,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${item.food.name} removed from cart.',
                    ),
                    action:
                    SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        state.addToCart(
                          item.food,
                          size:
                          item.size,
                          unitPrice:
                          item.unitPrice,
                          quantity:
                          item.quantity,
                        );
                      },
                    ),
                  ),
                );
              },
              child: const Text(
                'Remove',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // CLEAR CART DIALOG
  // ================================================================

  void _showClearCartDialog(
      BuildContext context,
      ) {
    showDialog(
      context: context,
      builder: (
          dialogContext,
          ) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              20,
            ),
          ),
          title: const Text(
            'Clear Cart?',
            style: TextStyle(
              fontWeight:
              FontWeight.w800,
            ),
          ),
          content: const Text(
            'Are you sure you want to remove all items from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
              const Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                state.clearCart();

                Navigator.pop(
                  dialogContext,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Cart cleared successfully.',
                    ),
                  ),
                );
              },
              child: const Text(
                'Clear Cart',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // COUNTER
  // ================================================================

  Widget _counter(
      BuildContext context,
      IconData icon,
      VoidCallback onTap,
      ) {
    final theme =
    Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(9),
        child: Container(
          width: 30,
          height: 30,
          decoration:
          BoxDecoration(
            color: theme
                .colorScheme
                .primary
                .withOpacity(0.10),
            borderRadius:
            BorderRadius.circular(
              9,
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: theme
                .colorScheme
                .primary,
          ),
        ),
      ),
    );
  }

  // ================================================================
  // PROMO
  // ================================================================

  Widget _promoSection(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    return Container(
      padding:
      const EdgeInsets.all(15),
      decoration:
      BoxDecoration(
        color:
        theme.colorScheme.surface,
        borderRadius:
        BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: theme.dividerColor
              .withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Apply Coupon',
            style: TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller:
                  _promoController,
                  textCapitalization:
                  TextCapitalization
                      .characters,
                  decoration:
                  InputDecoration(
                    hintText:
                    'Enter promo code',
                    isDense: true,
                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        12,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              SizedBox(
                height: 48,
                child:
                FilledButton(
                  onPressed: () {
                    final code =
                    _promoController
                        .text
                        .trim();

                    if (code.isEmpty) {
                      ScaffoldMessenger
                          .of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter a promo code.',
                          ),
                        ),
                      );

                      return;
                    }

                    final success =
                    state.applyPromoCode(
                      code,
                    );

                    ScaffoldMessenger
                        .of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Promo code applied successfully!'
                              : 'Invalid promo code.',
                        ),
                      ),
                    );
                  },
                  child:
                  const Text(
                    'Apply',
                  ),
                ),
              ),
            ],
          ),

          if (state.appliedPromoCode !=
              null) ...[
            const SizedBox(
              height: 10,
            ),

            Row(
              children: [
                const Icon(
                  Icons
                      .check_circle_rounded,
                  color: Colors.green,
                  size: 18,
                ),

                const SizedBox(
                  width: 6,
                ),

                Expanded(
                  child: Text(
                    '${state.appliedPromoCode} applied • 10% OFF',
                    style:
                    const TextStyle(
                      color:
                      Colors.green,
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    state.clearPromo();

                    _promoController
                        .clear();
                  },
                  child:
                  const Text(
                    'Remove',
                    style:
                    TextStyle(
                      color:
                      Colors.red,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ================================================================
  // SUMMARY
  // ================================================================

  Widget _summary(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    return Container(
      padding:
      const EdgeInsets.all(17),
      decoration:
      BoxDecoration(
        color:
        theme.colorScheme.surface,
        borderRadius:
        BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: theme.dividerColor
              .withOpacity(0.25),
        ),
      ),
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

          const SizedBox(
            height: 17,
          ),

          _summaryRow(
            context,
            'Item Total',
            '\$${state.cartSubtotal.toStringAsFixed(2)}',
          ),

          const SizedBox(
            height: 10,
          ),

          _summaryRow(
            context,
            'Delivery Fee',
            state.deliveryCharge == 0
                ? 'FREE'
                : '\$${state.deliveryCharge.toStringAsFixed(2)}',
            valueColor:
            state.deliveryCharge ==
                0
                ? Colors.green
                : null,
          ),

          if (state.discountAmount >
              0) ...[
            const SizedBox(
              height: 10,
            ),
            _summaryRow(
              context,
              'Coupon Discount',
              '-\$${state.discountAmount.toStringAsFixed(2)}',
              valueColor:
              Colors.green,
            ),
          ],

          const Padding(
            padding:
            EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Divider(),
          ),

          _summaryRow(
            context,
            'Grand Total',
            '\$${state.finalTotal.toStringAsFixed(2)}',
            bold: true,
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SUMMARY ROW
  // ================================================================

  Widget _summaryRow(
      BuildContext context,
      String title,
      String value, {
        bool bold = false,
        Color? valueColor,
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
            fontSize:
            bold ? 16 : 13,
            color: valueColor,
            fontWeight: bold
                ? FontWeight.w900
                : FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ================================================================
  // PAYMENT INFO
  // ================================================================

  Widget _paymentInfo(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    return Container(
      padding:
      const EdgeInsets.all(14),
      decoration:
      BoxDecoration(
        color: theme
            .colorScheme
            .primary
            .withOpacity(0.07),
        borderRadius:
        BorderRadius.circular(
          15,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 19,
            color: theme
                .colorScheme
                .primary,
          ),

          const SizedBox(
            width: 9,
          ),

          Expanded(
            child: Text(
              'Your payment information is secure and protected.',
              style: TextStyle(
                fontSize: 11,
                color:
                theme.hintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // CHECKOUT BAR
  // ================================================================

  Widget _bottomCheckoutBar(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    return Container(
      padding:
      const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12,
      ),
      decoration:
      BoxDecoration(
        color:
        theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor
                .withOpacity(0.25),
          ),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color:
                  theme.hintColor,
                  fontSize: 11,
                ),
              ),

              const SizedBox(
                height: 2,
              ),

              Text(
                '\$${state.finalTotal.toStringAsFixed(2)}',
                style:
                const TextStyle(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(
            width: 18,
          ),

          Expanded(
            child: MilestoneApp6Button(
              label: 'Proceed to Checkout',
              onPressed: () {
                if (state.selectedAddress == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please add a delivery address first.',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );

                  return;
                }

                if (state.cart.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Your cart is empty.',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );

                  return;
                }

                context.push(
                  '/checkout',
                  extra: state,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // CHECKOUT DIALOG
  // ================================================================

  void _showCheckoutDialog(
      BuildContext context,
      ) {
    showDialog(
      context: context,
      builder: (
          dialogContext,
          ) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              20,
            ),
          ),
          title: const Text(
            'Place Order?',
            style: TextStyle(
              fontWeight:
              FontWeight.w800,
            ),
          ),
          content: Text(
            'Your order total is \$${state.finalTotal.toStringAsFixed(2)}.\n\nDo you want to place this order?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
              const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                state.clearCart();

                ScaffoldMessenger
                    .of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Order placed successfully!',
                    ),
                  ),
                );

                context.go('/home');
              },
              child:
              const Text(
                'Place Order',
              ),
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // EMPTY CART
  // ================================================================

  Widget _emptyCart(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration:
              BoxDecoration(
                color: theme
                    .colorScheme
                    .primary
                    .withOpacity(0.08),
                shape:
                BoxShape.circle,
              ),
              child: Icon(
                Icons
                    .shopping_cart_outlined,
                size: 52,
                color: theme
                    .colorScheme
                    .primary,
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 21,
                fontWeight:
                FontWeight.w800,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Looks like you haven\'t added anything to your cart yet.',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                color:
                theme.hintColor,
                fontSize: 13,
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            SizedBox(
              width: 180,
              child:
              MilestoneApp6Button(
                label: 'Browse Food',
                onPressed: () {
                  context.go(
                    '/home',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
