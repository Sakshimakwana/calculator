import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app_matic_tech_flutter_app/controllers/cart_controller.dart';
import 'package:app_matic_tech_flutter_app/models/cart_response_model.dart';
import 'package:app_matic_tech_flutter_app/core/storage/address_storage.dart';
import 'package:app_matic_tech_flutter_app/core/storage/auth_storage.dart';
import 'package:app_matic_tech_flutter_app/services/milestone_app_6_address_api.dart';
import 'package:app_matic_tech_flutter_app/models/milestone_app_6_address_model.dart';
import '../state/milestone_app_6_state.dart';
import '../widgets/milestone_app_6_button.dart';
import '../widgets/milestone_app_6_image.dart';

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

class _MilestoneApp6CartScreenState extends State<MilestoneApp6CartScreen> {
  late final TextEditingController _promoController;

  MilestoneApp6State get state => widget.state;

  // ================================================================
  // ADDRESS API
  // ================================================================

  final MilestoneApp6AddressApi _addressApi = MilestoneApp6AddressApi();

  List<MilestoneApp6Address> _addresses = [];

  MilestoneApp6Address? _selectedApiAddress;

  bool _isLoadingAddress = true;

  // ================================================================
  // INIT
  // ================================================================

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

  // ================================================================
  // DISPOSE
  // ================================================================

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
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

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('        CART ADDRESS API');
      debugPrint('==========================================');
      debugPrint('Fetching addresses...');

      // ------------------------------------------------------------
      // GET ALL ADDRESSES
      // ------------------------------------------------------------

      final addresses = await _addressApi.fetchAddresses(
        token: token,
      );

      debugPrint(
        'ADDRESS COUNT: ${addresses.length}',
      );

      // ------------------------------------------------------------
      // GET SELECTED ADDRESS ID
      // ------------------------------------------------------------

      final selectedAddressId = AddressStorage.selectedAddressId;

      debugPrint(
        'SELECTED ADDRESS ID: $selectedAddressId',
      );

      MilestoneApp6Address? selectedAddress;

      // ------------------------------------------------------------
      // FIND SELECTED ADDRESS FROM API RESPONSE
      // ------------------------------------------------------------

      if (selectedAddressId != null && selectedAddressId > 0) {
        for (final address in addresses) {
          if (address.id == selectedAddressId) {
            selectedAddress = address;
            break;
          }
        }
      }

      // ------------------------------------------------------------
      // FALLBACK
      // ------------------------------------------------------------
      // If there is no selected ID but API has addresses,
      // use the first address.

      if (selectedAddress == null && addresses.isNotEmpty) {
        selectedAddress = addresses.first;

        await AddressStorage.saveSelectedAddressId(
          selectedAddress.id,
        );

        debugPrint(
          'No selected address found.',
        );

        debugPrint(
          'Using first address ID: '
          '${selectedAddress.id}',
        );
      }

      // ------------------------------------------------------------
      // UPDATE APP STATE
      // ------------------------------------------------------------

      if (selectedAddress != null) {
        state.setAddress(selectedAddress);
      }

      if (!mounted) return;

      setState(() {
        _addresses = addresses;
        _selectedApiAddress = selectedAddress;
        _isLoadingAddress = false;
      });

      debugPrint(
        'SELECTED ADDRESS: '
        '${selectedAddress?.fullAddress ?? 'NONE'}',
      );

      debugPrint('==========================================');
    } catch (e) {
      debugPrint('');
      debugPrint('==========================================');
      debugPrint('CART ADDRESS API ERROR');
      debugPrint('$e');
      debugPrint('==========================================');

      if (!mounted) return;

      setState(() {
        _isLoadingAddress = false;
        _addresses = [];
        _selectedApiAddress = null;
      });
    }
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cartController, child) {
        final items = cartController.cartItems;

        return Scaffold(
          appBar: _appBar(context),
          body: cartController.isLoading && items.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : items.isEmpty
                  ? _emptyCart(context)
                  : SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
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
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ...items.map(
                                  (item) => _apiCartItem(
                                    context,
                                    item,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _promoSection(context),
                                const SizedBox(height: 20),
                                _apiSummary(
                                  context,
                                  items,
                                ),
                                const SizedBox(height: 20),
                                _paymentInfo(context),
                              ],
                            ),
                          ),
                          _apiBottomCheckoutBar(
                            context,
                            items,
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
    );
  }

  // ================================================================
  // DELIVERY ADDRESS
  // ================================================================

  Widget _deliveryAddress(
    BuildContext context,
  ) {
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
                      style: TextStyle(
                        fontSize: 11,
                      ),
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

                  // ------------------------------------------------
                  // IMPORTANT:
                  // Fetch address API again after returning.
                  // ------------------------------------------------

                  await _loadAddressFromApi();

                  if (!mounted) return;

                  setState(() {});
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

          // ----------------------------------------------------------
          // LOADING ADDRESS
          // ----------------------------------------------------------

          if (_isLoadingAddress) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Fetching address...',
                    style: TextStyle(
                      color: theme.hintColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ----------------------------------------------------------
          // SELECTED API ADDRESS
          // ----------------------------------------------------------

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
                          address.label.isEmpty ? 'Address' : address.label,
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
                        if (address.city.trim().isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            address.city,
                            style: TextStyle(
                              color: theme.hintColor,
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

          // ----------------------------------------------------------
          // NO ADDRESS
          // ----------------------------------------------------------

          if (!_isLoadingAddress && address == null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_off_outlined,
                    size: 19,
                    color: theme.hintColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'No delivery address selected.',
                      style: TextStyle(
                        color: theme.hintColor,
                        fontSize: 12,
                      ),
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
  // API CART ITEM
  // ================================================================

  Widget _apiCartItem(
    BuildContext context,
    CartItemModel item,
  ) {
    final theme = Theme.of(context);

    final double totalPrice = item.menuItem.price * item.quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------------
          // IMAGE
          // ----------------------------------------------------------

          MilestoneApp6Image(
            url: item.menuItem.imageUrl,
            width: 88,
            height: 88,
            borderRadius: BorderRadius.circular(15),
          ),

          const SizedBox(width: 12),

          // ----------------------------------------------------------
          // DETAILS
          // ----------------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItem.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
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
                const SizedBox(height: 4),
                if (item.restaurant.name.trim().isNotEmpty)
                  Text(
                    item.restaurant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.hintColor,
                      fontSize: 11,
                    ),
                  ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    // ------------------------------------------------
                    // DECREASE
                    // ------------------------------------------------

                    _counter(
                      context,
                      Icons.remove,
                      () async {
                        if (item.quantity <= 1) {
                          return;
                        }

                        await context.read<CartController>().updateCartQuantity(
                              cartId: item.id,
                              quantity: item.quantity - 1,
                            );
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                      ),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // ------------------------------------------------
                    // INCREASE
                    // ------------------------------------------------

                    _counter(
                      context,
                      Icons.add,
                      () async {
                        await context.read<CartController>().updateCartQuantity(
                              cartId: item.id,
                              quantity: item.quantity + 1,
                            );
                      },
                    ),

                    const Spacer(),

                    Text(
                      '₹${totalPrice.toStringAsFixed(2)}',
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

  // ================================================================
  // BILL SUMMARY
  // ================================================================

  Widget _apiSummary(
    BuildContext context,
    List<CartItemModel> items,
  ) {
    final theme = Theme.of(context);

    double itemTotal = 0;

    for (final item in items) {
      itemTotal += item.menuItem.price * item.quantity;
    }

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
            '₹${itemTotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _summaryRow(
            context,
            'Delivery Fee',
            'FREE',
            valueColor: Colors.green,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Divider(),
          ),
          _summaryRow(
            context,
            'Grand Total',
            '₹${itemTotal.toStringAsFixed(2)}',
            bold: true,
          ),
        ],
      ),
    );
  }

  // ================================================================
  // BOTTOM CHECKOUT BAR
  // ================================================================

  Widget _apiBottomCheckoutBar(
    BuildContext context,
    List<CartItemModel> items,
  ) {
    final theme = Theme.of(context);

    double total = 0;

    for (final item in items) {
      total += item.menuItem.price * item.quantity;
    }

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
                'Total',
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '₹${total.toStringAsFixed(2)}',
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
                // ----------------------------------------------------
                // ADDRESS MUST COME FROM API
                // ----------------------------------------------------

                if (_selectedApiAddress == null) {
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

                // ----------------------------------------------------
                // CART EMPTY CHECK
                // ----------------------------------------------------

                if (items.isEmpty) {
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

                // ----------------------------------------------------
                // CHECKOUT
                // ----------------------------------------------------

                context.push(
                  '/checkout',
                  extra: widget.state,
                );
              },
            ),
          ),
        ],
      ),
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
            color: theme.colorScheme.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  // ================================================================
  // PROMO SECTION
  // ================================================================

  Widget _promoSection(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

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
                  textCapitalization: TextCapitalization.characters,
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
                    final code = _promoController.text.trim();

                    if (code.isEmpty) {
                      ScaffoldMessenger.of(
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

                    final success = state.applyPromoCode(
                      code,
                    );

                    if (!mounted) return;

                    ScaffoldMessenger.of(
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
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: bold ? 15 : 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 16 : 13,
            color: valueColor,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
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
      case 'office':
        return Icons.business_outlined;

      default:
        return Icons.location_on_outlined;
    }
  }

  // ================================================================
  // EMPTY CART
  // ================================================================

  Widget _emptyCart(
    BuildContext context,
  ) {
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
                color: theme.colorScheme.primary.withOpacity(0.08),
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
                onPressed: () {
                  context.go('/home');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
