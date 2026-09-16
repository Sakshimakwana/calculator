import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/milestone_app_6_food.dart';
import '../state/milestone_app_6_state.dart';
import '../widgets/milestone_app_6_image.dart';

class MilestoneApp6CheckoutScreen extends StatefulWidget {
  final MilestoneApp6Food food;
  final MilestoneApp6State state;
  final String size;
  final double unitPrice;
  final int quantity;

  const MilestoneApp6CheckoutScreen({
    super.key,
    required this.food,
    required this.state,
    required this.size,
    required this.unitPrice,
    required this.quantity,
  });

  @override
  State<MilestoneApp6CheckoutScreen> createState() =>
      _MilestoneApp6CheckoutScreenState();
}

class _MilestoneApp6CheckoutScreenState
    extends State<MilestoneApp6CheckoutScreen> {
  final TextEditingController _couponController =
  TextEditingController();

  String? _appliedCoupon;

  String? _selectedPaymentType;

  double get subtotal {
    return widget.unitPrice * widget.quantity;
  }

  double get shipping {
    return 94.0;
  }

  double get discount {
    if (_appliedCoupon == 'FOOD10') {
      return subtotal * 0.10;
    }

    return 0.0;
  }

  double get totalPayment {
    final total = subtotal + shipping - discount;

    return total < 0 ? 0 : total;
  }

  double get minimumPayment {
    final amount = totalPayment * 0.01;

    return amount < 1 ? 1 : amount;
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  // ================================================================
  // APPLY COUPON
  // ================================================================

  void _applyCoupon() {
    final code =
    _couponController.text.trim().toUpperCase();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a coupon code.'),
        ),
      );

      return;
    }

    if (code == 'FOOD10') {
      setState(() {
        _appliedCoupon = 'FOOD10';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Coupon applied successfully!',
          ),
        ),
      );
    } else {
      setState(() {
        _appliedCoupon = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid coupon code.'),
        ),
      );
    }
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              widget.state.toggleSaved(
                widget.food.id,
              );
            },
            icon: AnimatedBuilder(
              animation: widget.state,
              builder: (context, child) {
                final isSaved =
                widget.state.saved.contains(
                  widget.food.id,
                );

                return Icon(
                  isSaved
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isSaved
                      ? Colors.red
                      : null,
                );
              },
            ),
          ),
        ],
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  20,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // ADDRESS
                    // ==================================================

                    if (widget.state.selectedAddress != null)
                      _addressCard(context),

                    if (widget.state.selectedAddress != null)
                      const SizedBox(height: 18),

                    // ==================================================
                    // PRODUCT
                    // ==================================================

                    _productCard(context),

                    const SizedBox(height: 22),

                    // ==================================================
                    // COUPON
                    // ==================================================

                    const Text(
                      'Apply Coupon',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _couponController,
                            textCapitalization:
                            TextCapitalization.characters,
                            decoration: InputDecoration(
                              hintText: 'Apply coupon',
                              contentPadding:
                              const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 17,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        SizedBox(
                          height: 56,
                          width: 120,
                          child: FilledButton(
                            onPressed: _applyCoupon,
                            child: const Text(
                              'Apply',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (_appliedCoupon != null) ...[
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                            size: 18,
                          ),

                          const SizedBox(width: 6),

                          const Expanded(
                            child: Text(
                              'FOOD10 applied • 10% OFF',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              setState(() {
                                _appliedCoupon = null;
                                _couponController.clear();
                              });
                            },
                            child: const Text(
                              'Remove',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 22),

                    // ==================================================
                    // PRICE SUMMARY
                    // ==================================================

                    _priceSummary(context),

                    const SizedBox(height: 28),


                    const Text(
                      'Payment Type',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    _paymentOption(
                      context: context,
                      selected: _selectedPaymentType == 'minimum',
                      title: 'Minimum Payment (1%)',
                      subtitle:
                      'Pay \$${minimumPayment.toStringAsFixed(0)} now, rest on delivery',
                      amount: minimumPayment,
                      onTap: () {
                        setState(() {
                          _selectedPaymentType = 'minimum';
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    _paymentOption(
                      context: context,
                      selected: _selectedPaymentType == 'full',
                      title: 'Full payment',
                      subtitle:
                      'Pay \$${totalPayment.toStringAsFixed(0)} now.',
                      amount: totalPayment,
                      onTap: () {
                        setState(() {
                          _selectedPaymentType = 'full';
                        });
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ==========================================================
            // PAY BUTTON
            // ==========================================================

            _bottomPayBar(context),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // ADDRESS CARD
  // ================================================================

  Widget _addressCard(BuildContext context) {
    final theme = Theme.of(context);
    final address = widget.state.selectedAddress!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  address.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  context.push('/cart');
                },
                child: const Text('Change'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            address.name,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            address.fullAddress,
            style: TextStyle(
              color: theme.hintColor,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            address.phone,
            style: TextStyle(
              color: theme.hintColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // PRODUCT CARD
  // ================================================================

  Widget _productCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // IMAGE

          MilestoneApp6Image(
            url: widget.food.image,
            width: 130,
            height: 130,
            borderRadius: BorderRadius.circular(14),
          ),

          const SizedBox(width: 14),

          // DETAILS

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  widget.food.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  widget.food.restaurant,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.hintColor,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      '\$${widget.unitPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      'Size: ${widget.size}',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  '${widget.quantity} × \$${widget.unitPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: theme.hintColor,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Qty: ${widget.quantity}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // PRICE SUMMARY
  // ================================================================

  Widget _priceSummary(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 18),

          _summaryRow(
            'Subtotal',
            '\$${subtotal.toStringAsFixed(0)}',
          ),

          const SizedBox(height: 12),

          _summaryRow(
            'Shipping',
            '\$${shipping.toStringAsFixed(0)}',
          ),

          if (discount > 0) ...[
            const SizedBox(height: 12),

            _summaryRow(
              'Coupon Discount',
              '-\$${discount.toStringAsFixed(0)}',
              valueColor: Colors.green,
            ),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Divider(),
          ),

          _summaryRow(
            'Total Payment',
            '\$${totalPayment.toStringAsFixed(0)}',
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
            fontSize: bold ? 17 : 14,
            fontWeight:
            bold ? FontWeight.w800 : FontWeight.w500,
          ),
        ),

        const Spacer(),

        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 18 : 14,
            fontWeight:
            bold ? FontWeight.w900 : FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // ================================================================
  // PAYMENT OPTION
  // ================================================================

  Widget _paymentOption({
    required BuildContext context,
    required bool selected,
    required String title,
    required String subtitle,
    required double amount,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.dividerColor.withOpacity(0.3),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 27,
              color: selected
                  ? theme.colorScheme.primary
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.hintColor,
                    ),
                  ),

                  if (title.startsWith('Minimum')) ...[
                    const SizedBox(height: 5),
                    Text(
                      'No refund if order is not accepted at delivery',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),

            Text(
              '\$${amount.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // BOTTOM PAY BAR
  // ================================================================

  // ================================================================
// BOTTOM PAY BAR
// ================================================================

  Widget _bottomPayBar(BuildContext context) {
    final theme = Theme.of(context);

    final bool paymentSelected =
        _selectedPaymentType != null;

    final double amount =
    _selectedPaymentType == 'minimum'
        ? minimumPayment
        : totalPayment;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        14,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withOpacity(0.25),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton(
          onPressed: _selectedPaymentType != null
              ? _placeOrder
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pay \$${amount.toStringAsFixed(0)} Now',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.arrow_forward_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // PLACE ORDER
  // ================================================================

// ================================================================
// PLACE ORDER
// ================================================================

  Future<void> _placeOrder() async {
    if (_selectedPaymentType == null) {
      return;
    }

    final paymentType =
    _selectedPaymentType == 'minimum'
        ? 'Minimum Payment'
        : 'Full Payment';

    // ================================================================
    // SAVE ORDER
    // ================================================================

    widget.state.addOrder(
      food: widget.food,
      size: widget.size,
      unitPrice: widget.unitPrice,
      quantity: widget.quantity,
      paymentType: paymentType,
    );

    if (!mounted) {
      return;
    }

    // ================================================================
    // CONFIRMATION DIALOG
    // ================================================================

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Order Confirmed!',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            '${widget.food.name} has been ordered successfully.',
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Confirmed',
              ),
            ),
          ],
        );
      },
    );

    // ================================================================
    // SNACKBAR
    // ================================================================

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your order confirmed successfully!',
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
  }
}