import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/data/cart_controller/cart_controller.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/model/cart_response_model.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/data/address_storage/address_storage.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Login/auth_storage/auth_storage.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/data/service/milestone_app_6_address_api.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/models/milestone_app_6_address_model.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/state/milestone_app_6_state.dart';

class MilestoneApp6CartScreenLogic {
  final BuildContext context;
  final MilestoneApp6State state;

  MilestoneApp6CartScreenLogic({
    required this.context,
    required this.state,
  });

  // ============================================================
  // ADDRESS API
  // ============================================================

  final MilestoneApp6AddressApi addressApi =
  MilestoneApp6AddressApi();

  List<MilestoneApp6Address> addresses = [];

  MilestoneApp6Address? selectedApiAddress;

  bool isLoadingAddress = true;

  // ============================================================
  // CART CALCULATIONS
  // ============================================================

  double get itemTotal {
    final controller = context.read<CartController>();

    return controller.cartItems.fold<double>(
      0,
          (total, item) =>
      total + (item.menuItem.price * item.quantity),
    );
  }

  double get deliveryFee {
    return context.read<CartController>().cartItems.isEmpty
        ? 0
        : 2.00;
  }

  double get discount {
    final subtotal = itemTotal;

    return state.appliedPromoCode == null
        ? 0
        : subtotal * 0.10;
  }

  double get grandTotal {
    final total =
        itemTotal + deliveryFee - discount;

    return total < 0 ? 0 : total;
  }

  // ============================================================
  // LOAD ADDRESS FROM API
  // ============================================================

  Future<void> loadAddressFromApi({
    VoidCallback? onChanged,
  }) async {
    isLoadingAddress = true;
    onChanged?.call();

    try {
      final token = AuthStorage.token;

      if (token == null || token.isEmpty) {
        isLoadingAddress = false;
        addresses = [];
        selectedApiAddress = null;

        onChanged?.call();

        if (context.mounted) {
          context.go('/login');
        }

        return;
      }

      final fetchedAddresses =
      await addressApi.fetchAddresses(
        token: token,
      );

      final selectedAddressId =
          AddressStorage.selectedAddressId;

      MilestoneApp6Address? selectedAddress;

      // ----------------------------------------------------------
      // FIND PREVIOUSLY SELECTED ADDRESS
      // ----------------------------------------------------------

      if (selectedAddressId != null &&
          selectedAddressId > 0) {
        for (final address in fetchedAddresses) {
          if (address.id == selectedAddressId) {
            selectedAddress = address;
            break;
          }
        }
      }

      // ----------------------------------------------------------
      // SELECT FIRST ADDRESS IF NONE SELECTED
      // ----------------------------------------------------------

      if (selectedAddress == null &&
          fetchedAddresses.isNotEmpty) {
        selectedAddress = fetchedAddresses.first;

        await AddressStorage.saveSelectedAddressId(
          selectedAddress.id,
        );
      }

      // ----------------------------------------------------------
      // UPDATE GLOBAL STATE
      // ----------------------------------------------------------

      if (selectedAddress != null) {
        state.setAddress(selectedAddress);
      }

      addresses = fetchedAddresses;
      selectedApiAddress = selectedAddress;
      isLoadingAddress = false;

      onChanged?.call();
    } catch (e) {
      debugPrint(
        'CART ADDRESS API ERROR: $e',
      );

      addresses = [];
      selectedApiAddress = null;
      isLoadingAddress = false;

      onChanged?.call();
    }
  }

  // ============================================================
  // UPDATE CART QUANTITY
  // ============================================================

  Future<void> updateQuantity(
      CartItemModel item,
      int quantity,
      ) async {
    if (quantity < 1) {
      return;
    }

    await context
        .read<CartController>()
        .updateCartQuantity(
      cartId: item.id,
      quantity: quantity,
    );
  }

  // ============================================================
  // DELETE SINGLE CART ITEM
  // ============================================================

  Future<void> confirmDeleteCartItem(
      BuildContext dialogContext,
      CartItemModel item,
      ) async {
    final bool? shouldDelete =
    await showDialog<bool>(
      context: dialogContext,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Remove item?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Are you sure you want to delete '
                'this ${item.menuItem.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!dialogContext.mounted ||
        shouldDelete != true) {
      return;
    }

    final controller =
    dialogContext.read<CartController>();

    final bool deleted =
    await controller.deleteCart(
      cartId: item.id,
    );

    if (!dialogContext.mounted) {
      return;
    }

    ScaffoldMessenger.of(dialogContext)
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

  // ============================================================
  // CLEAR COMPLETE CART
  // ============================================================

  Future<void> confirmClearCart(
      BuildContext dialogContext,
      ) async {
    final bool? shouldClear =
    await showDialog<bool>(
      context: dialogContext,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Clear cart?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Are you sure you want to remove '
                'all items from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Clear Cart'),
            ),
          ],
        );
      },
    );

    if (!dialogContext.mounted ||
        shouldClear != true) {
      return;
    }

    final controller =
    dialogContext.read<CartController>();

    final bool cleared =
    await controller.clearCart();

    if (!dialogContext.mounted) {
      return;
    }

    ScaffoldMessenger.of(dialogContext)
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

  // ============================================================
  // CHECKOUT
  // ============================================================

  void handleCheckout() {
    debugPrint(
      '========================================',
    );

    debugPrint(
      'PROCEED TO CHECKOUT CLICKED',
    );

    debugPrint(
      '========================================',
    );

    final controller =
    context.read<CartController>();

    debugPrint(
      'API CART ITEMS: '
          '${controller.cartItems.length}',
    );

    debugPrint(
      'SELECTED ADDRESS: $selectedApiAddress',
    );

    // ----------------------------------------------------------
    // ADDRESS VALIDATION
    // ----------------------------------------------------------

    if (selectedApiAddress == null) {
      debugPrint(
        'CHECKOUT BLOCKED: ADDRESS IS NULL',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please add a delivery address first.',
          ),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // CART VALIDATION
    // ----------------------------------------------------------

    if (controller.cartItems.isEmpty) {
      debugPrint(
        'CHECKOUT BLOCKED: CART IS EMPTY',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your cart is empty.',
          ),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // NAVIGATE TO CHECKOUT
    // ----------------------------------------------------------

    debugPrint(
      'CHECKOUT VALIDATION PASSED',
    );

    debugPrint(
      'NAVIGATING TO /checkout',
    );

    context.push(
      '/checkout',
      extra: state,
    );

    debugPrint(
      'PUSH CALLED',
    );
  }

  // ============================================================
  // PROMO CODE
  // ============================================================

  bool applyPromoCode(
      String code,
      ) {
    final trimmedCode = code.trim();

    if (trimmedCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a promo code.',
          ),
        ),
      );

      return false;
    }

    final success =
    state.applyPromoCode(trimmedCode);

    if (!context.mounted) {
      return success;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Promo code applied successfully!'
              : 'Invalid promo code.',
        ),
      ),
    );

    return success;
  }

  // ============================================================
  // REMOVE PROMO CODE
  // ============================================================

  void removePromoCode(
      TextEditingController controller,
      ) {
    state.clearPromo();

    controller.clear();
  }
}