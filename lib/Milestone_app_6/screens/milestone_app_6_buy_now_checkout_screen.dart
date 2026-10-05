import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/order_controller.dart';
import '../../models/cart/cart_response_model.dart';
import '../data/milestone_app_6_cart_item.dart';
import '../data/milestone_app_6_food.dart';
import '../state/milestone_app_6_state.dart';
import '../widgets/milestone_app_6_button.dart';
import '../widgets/milestone_app_6_image.dart';

/// ================================================================
/// CHECKOUT ARGUMENTS
/// ================================================================

class MilestoneApp6CheckoutArgs {
  final MilestoneApp6State state;
  final MilestoneApp6CartItem? buyNowItem;
  final VoidCallback? onPressed;



  const MilestoneApp6CheckoutArgs({
    required this.state,
    this.buyNowItem,
    required this.onPressed,
  });
}

/// ================================================================
/// CHECKOUT SCREEN
/// ================================================================

class MilestoneApp6CheckoutScreen extends StatefulWidget {
  final MilestoneApp6State state;

  /// Optional Buy Now food.
  final MilestoneApp6Food? buyNowFood;

  /// Optional Buy Now size.
  final String? buyNowSize;

  /// Optional Buy Now unit price.
  final double? buyNowUnitPrice;

  /// Optional Buy Now quantity.
  final int? buyNowQuantity;

  /// Recommended Buy Now item.
  final MilestoneApp6CartItem? buyNowItem;

  const MilestoneApp6CheckoutScreen({
    super.key,
    required this.state,
    this.buyNowFood,
    this.buyNowSize,
    this.buyNowUnitPrice,
    this.buyNowQuantity,
    this.buyNowItem,
  });

  /// ==============================================================
  /// IS BUY NOW
  /// ==============================================================

  bool get isBuyNow {
    return buyNowItem != null || buyNowFood != null;
  }

  /// ==============================================================
  /// CREATE BUY NOW ITEM
  /// ==============================================================

  MilestoneApp6CartItem? get resolvedBuyNowItem {
    if (buyNowItem != null) {
      return buyNowItem;
    }

    if (buyNowFood != null) {
      return MilestoneApp6CartItem(
        food: buyNowFood!,
        size: buyNowSize ?? 'Small',
        unitPrice: buyNowUnitPrice ?? buyNowFood!.price,
        quantity: buyNowQuantity ?? 1,
      );
    }

    return null;
  }

  @override
  State<MilestoneApp6CheckoutScreen> createState() =>
      _MilestoneApp6CheckoutScreenState();
}

/// ================================================================
/// CHECKOUT STATE
/// ================================================================

class _MilestoneApp6CheckoutScreenState
    extends State<MilestoneApp6CheckoutScreen> {
  /// ==============================================================
  /// STATE
  /// ==============================================================

  MilestoneApp6State get state => widget.state;

  /// ==============================================================
  /// CONTROLLER
  /// ==============================================================

  final TextEditingController _couponController =
  TextEditingController();

  final TextEditingController _deliveryInstructionsController =
  TextEditingController();

  /// ==============================================================
  /// COUPON
  /// ==============================================================

  String? _appliedCoupon;

  /// ==============================================================
  /// PAYMENT
  /// ==============================================================

  String? _selectedPaymentMethod;

  /// ==============================================================
  /// ORDER ITEMS
  /// ==============================================================

  late List<MilestoneApp6CartItem> _orderedItems;

  /// ==============================================================
  /// INIT
  /// ==============================================================

  @override
  void initState() {
    super.initState();

    _createOrderItems();
  }

  MilestoneApp6CartItem _convertApiCartItem(CartItemModel item) {
    return MilestoneApp6CartItem(
      food: MilestoneApp6Food(
        id: item.menuItem.id.toString(),
        name: item.menuItem.name,
        category: '',
        restaurant: item.restaurant.name,
        image: item.menuItem.imageUrl,
        price: item.menuItem.price,
        description: '',
      ),
      size: '',
      unitPrice: item.menuItem.price,
      quantity: item.quantity,
    );
  }

  /// ==============================================================
  /// CREATE ORDER ITEMS
  /// ==============================================================

  void _createOrderItems() {
    if (widget.isBuyNow) {
      final buyNowItem = widget.resolvedBuyNowItem;

      if (buyNowItem == null) {
        _orderedItems = [];
        return;
      }

      _orderedItems = [
        _copyCartItem(buyNowItem),
      ];

      return;
    }

    final cartController = context.read<CartController>();

    _orderedItems = cartController.cartItems
        .map((item) => _convertApiCartItem(item))
        .toList();
  }

  /// ==============================================================
  /// COPY CART ITEM
  /// ==============================================================

  MilestoneApp6CartItem _copyCartItem(MilestoneApp6CartItem item) {
    return MilestoneApp6CartItem(
      food: item.food,
      size: item.size,
      unitPrice: item.unitPrice,
      quantity: item.quantity,
    );
  }

  /// ==============================================================
  /// DISPOSE
  /// ==============================================================

  @override
  void dispose() {
    _couponController.dispose();
    _deliveryInstructionsController.dispose();
    super.dispose();
  }

  /// ==============================================================
  /// TOTAL ITEM COUNT
  /// ==============================================================

  int get totalItemCount {
    return _orderedItems.fold<int>(
      0,
          (total, item) => total + item.quantity,
    );
  }

  /// ==============================================================
  /// SUBTOTAL
  /// ==============================================================

  double get subtotal {
    return _orderedItems.fold<double>(
      0.0,
          (total, item) => total + item.totalPrice,
    );
  }

  /// ==============================================================
  /// SHIPPING
  /// ==============================================================

  double get shipping {
    if (_orderedItems.isEmpty) {
      return 0.0;
    }

    return 2.00;
  }

  /// ==============================================================
  /// DISCOUNT
  /// ==============================================================

  double get discount {
    if (_appliedCoupon == 'FOOD10') {
      return subtotal * 0.10;
    }

    return 0.0;
  }

  /// ==============================================================
  /// TOTAL
  /// ==============================================================

  double get totalPayment {
    final double value = subtotal + shipping - discount;

    if (value < 0) {
      return 0.0;
    }

    return value;
  }

  /// ==============================================================
  /// MINIMUM PAYMENT
  /// ==============================================================

  double get minimumPayment {
    if (totalPayment <= 0) {
      return 0.0;
    }

    final double onePercent = totalPayment * 0.01;

    if (onePercent < 1.0) {
      return 1.0;
    }

    return onePercent;
  }

  /// ==============================================================
  /// AMOUNT TO PAY NOW
  /// ==============================================================

  double get amountPaidNow {
    if (_selectedPaymentMethod == 'cod') {
      return 0.0;
    }

    return totalPayment;
  }

  /// ==============================================================
  /// APPLY COUPON
  /// ==============================================================

  void _applyCoupon() {
    final String code =
    _couponController.text.trim().toUpperCase();

    if (code.isEmpty) {
      _showSnackBar('Please enter a coupon code.');
      return;
    }

    if (code == 'FOOD10') {
      setState(() {
        _appliedCoupon = 'FOOD10';
      });

      _showSnackBar('Coupon applied successfully!');
      return;
    }

    setState(() {
      _appliedCoupon = null;
    });

    _showSnackBar('Invalid coupon code.');
  }

  /// ==============================================================
  /// REMOVE COUPON
  /// ==============================================================

  void _removeCoupon() {
    setState(() {
      _appliedCoupon = null;
      _couponController.clear();
    });

    _showSnackBar('Coupon removed.');
  }

  /// ==============================================================
  /// SNACKBAR
  /// ==============================================================

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  Widget _emptyCheckout(BuildContext context) {
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
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 18),
              const Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add some delicious items before checking out.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.hintColor,
                ),
              ),
              const SizedBox(height: 24),
              MilestoneApp6Button(
                label: 'GO TO HOME',
                onPressed: () {
                  context.go('/');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ==============================================================
  /// BUILD
  /// ==============================================================

  @override
  Widget build(BuildContext context) {
    if (_orderedItems.isEmpty) {
      return _emptyCheckout(context);
    }

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
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  24,
                ),
                children: [
                  _checkoutSteps(context),
                  const SizedBox(height: 18),
                  _deliveryAddress(context),
                  const SizedBox(height: 18),
                  _orderItems(context),
                  const SizedBox(height: 18),
                  _couponSection(context),
                  const SizedBox(height: 18),
                  _billDetails(context),
                  const SizedBox(height: 18),
                  _paymentMethod(context),
                  const SizedBox(height: 18),
                  _securePayment(context),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            _bottomPayBar(context),
          ],
        ),
      ),
    );
  }

  /// ==============================================================
  /// CHECKOUT STEPS
  /// ==============================================================

  Widget _checkoutSteps(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _step(
            context,
            '1',
            'Address',
            true,
          ),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              color: theme.colorScheme.primary.withOpacity(0.25),
            ),
          ),
          _step(
            context,
            '2',
            'Payment',
            true,
          ),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              color: theme.dividerColor.withOpacity(0.4),
            ),
          ),
          _step(
            context,
            '3',
            'Done',
            false,
          ),
        ],
      ),
    );
  }

  /// ==============================================================
  /// STEP
  /// ==============================================================

  Widget _step(BuildContext context,
      String number,
      String title,
      bool active,) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? theme.colorScheme.primary
                : theme.dividerColor.withOpacity(0.35),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: TextStyle(
              color: active ? Colors.white : theme.hintColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight:
            active ? FontWeight.w800 : FontWeight.w500,
            color: active
                ? theme.colorScheme.primary
                : theme.hintColor,
          ),
        ),
      ],
    );
  }

  /// ==============================================================
  /// DELIVERY ADDRESS
  /// ==============================================================

  Widget _deliveryAddress(BuildContext context) {
    final theme = Theme.of(context);
    final address = state.selectedAddress;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.25),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (address == null)
            _noAddress(context)
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _addressIcon(address.label),
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          address.fullAddress.isEmpty
                              ? 'Address details not available'
                              : address.fullAddress,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.hintColor,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// ==============================================================
  /// NO ADDRESS
  /// ==============================================================

  Widget _noAddress(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        context.push(
          '/profile/address',
          extra: state,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.add_location_alt_outlined,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Add a delivery address',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
            ),
          ],
        ),
      ),
    );
  }

  /// ==============================================================
  /// ADDRESS ICON
  /// ==============================================================

  IconData _addressIcon(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;

      case 'work':
      case 'office':
        return Icons.business_outlined;

      default:
        return Icons.location_on_outlined;
    }
  }

  /// ==============================================================
  /// ORDER ITEMS
  /// ==============================================================

  Widget _orderItems(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Order Items',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '$totalItemCount item${totalItemCount == 1 ? '' : 's'}',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._orderedItems.map(
                (item) =>
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: _checkoutItem(
                    context,
                    item,
                  ),
                ),
          ),
        ],
      ),
    );
  }

  /// ==============================================================
  /// CHECKOUT ITEM
  /// ==============================================================

  Widget _checkoutItem(BuildContext context,
      MilestoneApp6CartItem item,) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MilestoneApp6Image(
          url: item.food.image,
          width: 68,
          height: 68,
          borderRadius: BorderRadius.circular(13),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.food.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Size: ${item.size}',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Qty: ${item.quantity}',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '\$${item.totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  /// ==============================================================
  /// COUPON SECTION
  /// ==============================================================

  Widget _couponSection(BuildContext context) {
    final theme = Theme.of(context);
    final bool couponApplied = _appliedCoupon != null;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Apply Coupon',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  enabled: !couponApplied,
                  textCapitalization:
                  TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (couponApplied)
                OutlinedButton(
                  onPressed: _removeCoupon,
                  child: const Text('Remove'),
                )
              else
                FilledButton(
                  onPressed: _applyCoupon,
                  child: const Text('Apply'),
                ),
            ],
          ),
          if (couponApplied)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: Colors.green,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'FOOD10 applied • 10% OFF',
                    style: TextStyle(
                      color: Colors.green,
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

  /// ==============================================================
  /// BILL DETAILS
  /// ==============================================================

  Widget _billDetails(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.25),
        ),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Bill Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _summaryRow(
            'Item Total',
            '\$${subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _summaryRow(
            'Delivery Fee',
            '\$${shipping.toStringAsFixed(2)}',
          ),
          if (discount > 0) ...[
            const SizedBox(height: 10),
            _summaryRow(
              'Coupon Discount',
              '-\$${discount.toStringAsFixed(2)}',
              valueColor: Colors.green,
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Divider(
              color: theme.dividerColor,
            ),
          ),
          _summaryRow(
            'Grand Total',
            '\$${totalPayment.toStringAsFixed(2)}',
            bold: true,
          ),
        ],
      ),
    );
  }

  /// ==============================================================
  /// SUMMARY ROW
  /// ==============================================================

  Widget _summaryRow(String title,
      String value, {
        bool bold = false,
        Color? valueColor,
      }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: bold ? 15 : 13,
              fontWeight:
              bold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 16 : 13,
            color: valueColor,
            fontWeight:
            bold ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }

  /// ==============================================================
  /// PAYMENT METHOD
  /// ==============================================================

  Widget _paymentMethod(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _paymentOption(
            context,
            title: 'Online Payment',
            value: 'online',
            subtitle: 'Pay securely online using Razorpay',
            icon: Icons.account_balance_wallet_outlined,
          ),
          const SizedBox(height: 10),
          _paymentOption(
            context,
            title: 'Cash on Delivery',
            value: 'cod',
            subtitle: 'Pay when your order is delivered',
            icon: Icons.payments_outlined,
          ),
        ],
      ),
    );
  }

  /// ==============================================================
  /// PAYMENT OPTION
  /// ==============================================================

  Widget _paymentOption(BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final bool selected = _selectedPaymentMethod == value;

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withOpacity(0.08)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.dividerColor.withOpacity(0.30),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.iconTheme.color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ==============================================================
  /// SECURE PAYMENT
  /// ==============================================================

  Widget _securePayment(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              _selectedPaymentMethod == 'cod'
                  ? 'You will pay cash when your order is delivered.'
                  : 'Your online payment information is secure and protected.',
              style: TextStyle(
                fontSize: 11,
                color: theme.hintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ==============================================================
  /// BOTTOM PAY BAR
  /// ==============================================================

  Widget _bottomPayBar(BuildContext context) {
    final theme = Theme.of(context);
    final orderController = context.watch<OrderController>();

    final bool isProcessing =
        orderController.isLoading ||
            orderController.isProcessingPayment;

    final bool isCashOnDelivery =
        _selectedPaymentMethod == 'cod';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withOpacity(0.25),
          ),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCashOnDelivery ? 'Pay on Delivery' : 'Pay Now',
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '\$${totalPayment.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: MilestoneApp6Button(
              label: isProcessing
                  ? 'Processing...'
                  : isCashOnDelivery
                  ? 'PLACE ORDER'
                  : 'PAY NOW',
              onPressed: () {
                if (isProcessing) {
                  return;
                }
                _payNow(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ==============================================================
  /// PAY NOW VALIDATION
  /// ==============================================================

  /// ==============================================================
  /// PAY NOW VALIDATION
  /// ==============================================================

  Future<void> _payNow(BuildContext context) async {
    final orderController = context.read<OrderController>();

    // Prevent duplicate order/payment requests.
    if (orderController.isLoading ||
        orderController.isProcessingPayment) {
      return;
    }

    // --------------------------------------------------------------
    // CHECK ADDRESS
    // --------------------------------------------------------------

    if (state.selectedAddress == null) {
      _showSnackBar(
        'Please add a delivery address first.',
      );
      return;
    }

    // --------------------------------------------------------------
    // CHECK PAYMENT METHOD
    // --------------------------------------------------------------

    if (_selectedPaymentMethod == null) {
      _showSnackBar(
        'Please select a payment method.',
      );
      return;
    }

    // --------------------------------------------------------------
    // CHECK ITEMS
    // --------------------------------------------------------------

    if (_orderedItems.isEmpty) {
      _showSnackBar(
        'There are no items to checkout.',
      );
      return;
    }

    // --------------------------------------------------------------
    // SHOW CONFIRMATION
    // --------------------------------------------------------------

    final bool success =
    await _showPaymentConfirmation(context);

    if (!success || !mounted) {
      return;
    }

    // --------------------------------------------------------------
    // GET CREATED ORDER ID
    // --------------------------------------------------------------

    final int? orderId =
        context.read<OrderController>().orderId;

    if (orderId == null) {
      _showSnackBar(
        'Order ID was not received.',
      );
      return;
    }

    debugPrint(
      'NAVIGATING TO ORDER DETAILS: $orderId',
    );

    // --------------------------------------------------------------
    // GO TO ORDER DETAILS
    // --------------------------------------------------------------

    context.go(
      '/order-details/$orderId',
    );
  }

  /// ==============================================================
  /// PAYMENT CONFIRMATION
  /// ==============================================================

  Future<bool> _showPaymentConfirmation(
      BuildContext context,
      ) async {
    final bool isCOD =
        _selectedPaymentMethod == 'cod';

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(context);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            isCOD
                ? 'Confirm Order'
                : 'Confirm Payment',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                isCOD
                    ? 'Amount to pay on delivery'
                    : 'Amount to pay now',
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                '\$${amountPaidNow.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary
                      .withOpacity(0.07),
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Text(
                  isCOD
                      ? 'Cash on Delivery'
                      : 'Online Payment',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Order total: '
                    '\$${totalPayment.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.hintColor,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                isCOD
                    ? 'Are you sure you want to place '
                    'this order with Cash on Delivery?'
                    : 'Are you sure you want to continue '
                    'with this online payment?',
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(false);
              },
              child: const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(true);
              },
              child: Text(
                isCOD
                    ? 'Confirm Order'
                    : 'Confirm Pay',
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return false;
    }

    return _completePayment();
  }

  /// ==============================================================
  /// COMPLETE PAYMENT
  /// ==============================================================

  Future<bool> _completePayment() async {
    final orderController =
    context.read<OrderController>();

    final cartController =
    context.read<CartController>();

    // ============================================================
    // 1. CHECK ADDRESS
    // ============================================================

    final selectedAddress =
        state.selectedAddress;

    if (selectedAddress == null) {
      _showSnackBar(
        'Please select a delivery address.',
      );
      return false;
    }

    final addressId = int.tryParse(
      selectedAddress.id.toString(),
    );

    if (addressId == null) {
      _showSnackBar(
        'Invalid delivery address.',
      );
      return false;
    }

    // ============================================================
    // 2. CHECK PAYMENT METHOD
    // ============================================================

    final paymentMethod =
        _selectedPaymentMethod;

    if (paymentMethod == null) {
      _showSnackBar(
        'Please select a payment method.',
      );
      return false;
    }

    // ============================================================
    // 3. PLACE ORDER
    // ============================================================

    debugPrint(
      '========== PLACE ORDER =========',
    );

    final orderPlaced =
    await orderController.placeOrder(
      addressId: addressId,
      deliveryInstructions:
      _deliveryInstructionsController.text.trim(),
    );

    if (!orderPlaced) {
      _showSnackBar(
        orderController.errorMessage ??
            'Unable to place order.',
      );
      return false;
    }

    // ============================================================
    // 4. GET NEW ORDER ID
    // ============================================================

    final newOrderId =
        orderController.orderId;

    if (newOrderId == null) {
      _showSnackBar(
        'Order ID was not received.',
      );
      return false;
    }

    debugPrint(
      'NEW ORDER CREATED: $newOrderId',
    );

    // ============================================================
    // 5. PAYMENT API
    // POST /orders/{orderId}/payment
    // ============================================================

    final paymentSuccess =
    await orderController.makePayment(
      orderId: newOrderId,
      paymentRequest: {
        'payment_method': paymentMethod,
      },
    );

    if (!paymentSuccess) {
      _showSnackBar(
        orderController.paymentErrorMessage ??
            'Payment failed.',
      );
      return false;
    }

    debugPrint(
      'PAYMENT SUCCESS FOR ORDER: $newOrderId',
    );

    // ============================================================
    // 6. FETCH COMPLETE ORDER
    // ============================================================

    final orderInfoLoaded =
    await orderController.fetchOrderInfo(
      newOrderId,
    );

    if (!orderInfoLoaded) {
      // Payment already succeeded.
      // Do not report the complete order as failed.
      debugPrint(
        'WARNING: Order info could not be '
            'refreshed after payment.',
      );
    }

    // ============================================================
    // 7. CLEAR CART ONLY AFTER PAYMENT SUCCESS
    // ============================================================

    if (!widget.isBuyNow) {
      await cartController.clearCart();
    }

    debugPrint(
      '========== ORDER COMPLETED ==========',
    );

    return true;
  }
}