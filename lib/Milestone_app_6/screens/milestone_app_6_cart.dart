import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_matic_tech_flutter_app/controllers/cart_controller.dart';
import 'package:app_matic_tech_flutter_app/models/cart/cart_response_model.dart';
import 'package:app_matic_tech_flutter_app/core/storage/address_storage.dart';
import 'package:app_matic_tech_flutter_app/core/storage/auth_storage.dart';
import 'package:app_matic_tech_flutter_app/services/milestone_app_6_address_api.dart';
import 'package:app_matic_tech_flutter_app/models/address/milestone_app_6_address_model.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/state/milestone_app_6_state.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/widgets/milestone_app_6_button.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/widgets/milestone_app_6_image.dart';

class MilestoneApp6CartScreen extends StatefulWidget {
  final MilestoneApp6State state;

  const MilestoneApp6CartScreen({
    super.key,
    required this.state,
  });

  @override
  State<MilestoneApp6CartScreen> createState() =>
      _MilestoneApp6CartScreenState();
}

class _MilestoneApp6CartScreenState
    extends State<MilestoneApp6CartScreen> {
  late final TextEditingController _promoController;

  MilestoneApp6State get state => widget.state;

  // ================================================================
  // ADDRESS API
  // ================================================================

  final MilestoneApp6AddressApi _addressApi =
  MilestoneApp6AddressApi();

  List<MilestoneApp6Address> _addresses = [];
  MilestoneApp6Address? _selectedApiAddress;
  bool _isLoadingAddress = true;

  @override
  void initState() {
    super.initState();

    _promoController = TextEditingController(
      text: state.appliedPromoCode ?? '',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await context.read<CartController>().fetchCart();
      await _loadAddressFromApi();
    });
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  double get _itemTotal {
    final controller = context.read<CartController>();

    return controller.cartItems.fold<double>(
      0,
          (total, item) =>
      total + (item.menuItem.price * item.quantity),
    );
  }

  double get _deliveryFee =>
      context.read<CartController>().cartItems.isEmpty ? 0 : 2.00;

  double get _discount {
    final subtotal = _itemTotal;
    return state.appliedPromoCode == null ? 0 : subtotal * 0.10;
  }

  double get _grandTotal {
    final total = _itemTotal + _deliveryFee - _discount;
    return total < 0 ? 0 : total;
  }

  // ================================================================
  // LOAD ADDRESS FROM API
  // ================================================================

  Future<void> _loadAddressFromApi() async {
    if (!mounted) return;

    setState(() {
      _isLoadingAddress = true;
    });

    try {
      final token = AuthStorage.token;

      if (token == null || token.isEmpty) {
        if (!mounted) return;
        setState(() {
          _isLoadingAddress = false;
          _addresses = [];
          _selectedApiAddress = null;
        });
        context.go('/login');
        return;
      }

      final addresses = await _addressApi.fetchAddresses(
        token: token,
      );

      final selectedAddressId =
          AddressStorage.selectedAddressId;

      MilestoneApp6Address? selectedAddress;

      if (selectedAddressId != null && selectedAddressId > 0) {
        for (final address in addresses) {
          if (address.id == selectedAddressId) {
            selectedAddress = address;
            break;
          }
        }
      }

      if (selectedAddress == null && addresses.isNotEmpty) {
        selectedAddress = addresses.first;
        await AddressStorage.saveSelectedAddressId(
          selectedAddress.id,
        );
      }

      if (selectedAddress != null) {
        state.setAddress(selectedAddress);
      }

      if (!mounted) return;

      setState(() {
        _addresses = addresses;
        _selectedApiAddress = selectedAddress;
        _isLoadingAddress = false;
      });
    } catch (e) {
      debugPrint('CART ADDRESS API ERROR: $e');

      if (!mounted) return;

      setState(() {
        _addresses = [];
        _selectedApiAddress = null;
        _isLoadingAddress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, controller, _) {
        final items = controller.cartItems;

        return Scaffold(
          appBar: _appBar(context, items.isNotEmpty),
          body: controller.isLoading && items.isEmpty
              ? _cartShimmer(context)
              : controller.errorMessage != null && items.isEmpty
              ? _errorState(context, controller.errorMessage!)
              : items.isEmpty
              ? _emptyCart(context)
              : SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.fetchCart,
                    child: ListView(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        12,
                        16,
                        20,
                      ),
                      children: [
                        _deliveryAddress(context),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Your Items',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              '${items.length} item${items.length == 1 ? '' : 's'}',
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...items.map(
                              (item) => _cartItem(context, item),
                        ),
                        const SizedBox(height: 8),
                        _promoSection(context),
                        const SizedBox(height: 20),
                        _summary(context),
                        const SizedBox(height: 20),
                        _paymentInfo(context),
                      ],
                    ),
                  ),
                ),
                _bottomCheckoutBar(context),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar(
      BuildContext context,
      bool hasItems,
      ) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.go('/home'),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      title: const Text(
        'My Cart',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        if (hasItems)
          TextButton(
            onPressed: context.read<CartController>().isDeletingCart
                ? null
                : () => _confirmClearCart(context),
            child: const Text(
              'Clear',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _deliveryAddress(BuildContext context) {
    final theme = Theme.of(context);
    final address = _selectedApiAddress;

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
                  color: theme.colorScheme.primary.withOpacity(.10),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  await context.push(
                    '/profile/address',
                    extra: state,
                  );

                  if (!mounted) return;
                  await _loadAddressFromApi();
                },
                child: Text(
                  _isLoadingAddress
                      ? '...'
                      : address == null
                      ? 'Add'
                      : 'Change',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          if (_isLoadingAddress) ...[
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fetching address...',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.hintColor,
                ),
              ),
            ),
          ],
          if (!_isLoadingAddress && address != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _addressIcon(address.label),
                    size: 19,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.label.isEmpty
                              ? 'Address'
                              : address.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          address.fullAddress.trim().isEmpty
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
          if (!_isLoadingAddress && address == null) ...[
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'No delivery address selected.',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.hintColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

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

  Widget _cartItem(
      BuildContext context,
      CartItemModel item,
      ) {
    final theme = Theme.of(context);
    final quantity = item.quantity;
    final lineTotal = item.menuItem.price * quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withOpacity(.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MilestoneApp6Image(
            url: item.menuItem.imageUrl,
            width: 88,
            height: 88,
            borderRadius: BorderRadius.circular(15),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.menuItem.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      tooltip: 'Remove item',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      onPressed: () {
                        _confirmDeleteCartItem(
                          context,
                          item,
                        );
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                Text(
                  item.restaurant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.hintColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '₹${item.menuItem.price.toStringAsFixed(2)} each',
                  style: TextStyle(
                    color: theme.hintColor,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    _counter(
                      context,
                      Icons.remove,
                      quantity > 1
                          ? () => _updateQuantity(
                        context,
                        item,
                        quantity - 1,
                      )
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                      ),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    _counter(
                      context,
                      Icons.add,
                          () => _updateQuantity(
                        context,
                        item,
                        quantity + 1,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹${lineTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
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

  Future<void> _confirmDeleteCartItem(
      BuildContext context,
      CartItemModel item,
      ) async {
    final bool? shouldDelete =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Remove item?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this ${item.menuItem.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldDelete != true) {
      return;
    }

    final controller =
    context.read<CartController>();

    final bool deleted =
    await controller.deleteCart(
      cartId: item.id,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            deleted
                ? '${item.menuItem.name} removed from cart'
                : controller.errorMessage ??
                'Failed to remove item',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ================================================================
  // CLEAR ALL CART ITEMS
  // DELETE /cart
  // ================================================================

  Future<void> _confirmClearCart(BuildContext context) async {
    final bool? shouldClear =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Clear cart?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Are you sure you want to remove all items from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Clear Cart'),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldClear != true) {
      return;
    }

    final controller = context.read<CartController>();

    final bool cleared = await controller.clearCart();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            cleared
                ? 'Cart cleared successfully'
                : controller.errorMessage ??
                'Failed to clear cart',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _updateQuantity(
      BuildContext context,
      CartItemModel item,
      int quantity,
      ) async {
    if (quantity < 1) return;

    await context
        .read<CartController>()
        .updateCartQuantity(
      cartId: item.id,
      quantity: quantity,
    );
  }

  Widget _counter(
      BuildContext context,
      IconData icon,
      VoidCallback? onTap,
      ) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: onTap == null
                ? theme.dividerColor.withOpacity(.08)
                : theme.colorScheme.primary.withOpacity(.10),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            size: 16,
            color: onTap == null
                ? theme.hintColor
                : theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _promoSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withOpacity(.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Apply Coupon',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promoController,
                  textCapitalization:
                  TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    final code =
                    _promoController.text.trim();

                    if (code.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter a promo code.',
                          ),
                        ),
                      );
                      return;
                    }

                    final success =
                    state.applyPromoCode(code);

                    if (!mounted) return;

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Promo code applied successfully!'
                              : 'Invalid promo code.',
                        ),
                      ),
                    );

                    setState(() {});
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
          if (state.appliedPromoCode != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${state.appliedPromoCode} applied • 10% OFF',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    state.clearPromo();
                    _promoController.clear();
                    setState(() {});
                  },
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                      color: Colors.red,
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

  Widget _summary(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bill Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 17),
          _summaryRow(
            context,
            'Item Total',
            '₹${_itemTotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _summaryRow(
            context,
            'Delivery Fee',
            _deliveryFee == 0
                ? 'FREE'
                : '₹${_deliveryFee.toStringAsFixed(2)}',
            valueColor:
            _deliveryFee == 0 ? Colors.green : null,
          ),
          if (_discount > 0) ...[
            const SizedBox(height: 10),
            _summaryRow(
              context,
              'Coupon Discount',
              '-₹${_discount.toStringAsFixed(2)}',
              valueColor: Colors.green,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
          ),
          _summaryRow(
            context,
            'Grand Total',
            '₹${_grandTotal.toStringAsFixed(2)}',
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
      BuildContext context,
      String title,
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

  Widget _paymentInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
        theme.colorScheme.primary.withOpacity(.07),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 19,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Your payment information is secure and protected.',
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

  Widget _bottomCheckoutBar(
      BuildContext context,
      ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color:
            theme.dividerColor.withOpacity(.25),
          ),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '₹${_grandTotal.toStringAsFixed(2)}',
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
              label: 'Proceed to Checkout',
              onPressed: () {
                debugPrint('========================================');
                debugPrint('PROCEED TO CHECKOUT CLICKED');
                debugPrint('========================================');

                final controller = context.read<CartController>();

                debugPrint(
                  'API CART ITEMS: ${controller.cartItems.length}',
                );

                debugPrint(
                  'SELECTED ADDRESS: $_selectedApiAddress',
                );

                if (_selectedApiAddress == null) {
                  debugPrint('CHECKOUT BLOCKED: ADDRESS IS NULL');

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please add a delivery address first.'),
                    ),
                  );
                  return;
                }

                if (controller.cartItems.isEmpty) {
                  debugPrint('CHECKOUT BLOCKED: CART IS EMPTY');

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Your cart is empty.'),
                    ),
                  );
                  return;
                }

                debugPrint('CHECKOUT VALIDATION PASSED');
                debugPrint('NAVIGATING TO /checkout');

                context.push(
                  '/checkout',
                  extra: state,
                );

                debugPrint('PUSH CALLED');
              },
            )
          ),
        ],
      ),
    );
  }

  Widget _emptyCart(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary
                    .withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 52,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Looks like you haven\'t added anything to your cart yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: 180,
              child: MilestoneApp6Button(
                label: 'Browse Food',
                onPressed: () => context.go('/home'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(
      BuildContext context,
      String message,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
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
              'Unable to load cart',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () =>
                  context.read<CartController>().fetchCart(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartShimmer(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color:
              theme.dividerColor.withOpacity(.20),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 88,
                height: 88,
                margin: const EdgeInsets.only(left: 11),
                decoration: BoxDecoration(
                  color:
                  theme.dividerColor.withOpacity(.15),
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 4,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 14,
                        decoration: BoxDecoration(
                          color: theme.dividerColor
                              .withOpacity(.15),
                          borderRadius:
                          BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 90,
                        height: 12,
                        decoration: BoxDecoration(
                          color: theme.dividerColor
                              .withOpacity(.15),
                          borderRadius:
                          BorderRadius.circular(5),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 110,
                        height: 28,
                        decoration: BoxDecoration(
                          color: theme.dividerColor
                              .withOpacity(.15),
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

