import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_matic_tech_flutter_app/Milestone_app_6/order%20details_and_checkout/checkout/methods/checkout_screen_logic.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/order%20details_and_checkout/checkout/widgets/checkout_bill_details.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/order%20details_and_checkout/checkout/widgets/checkout_bottom_pay_bar.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/order%20details_and_checkout/checkout/widgets/checkout_coupon_section.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/order%20details_and_checkout/checkout/widgets/checkout_delivery_address.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/order%20details_and_checkout/checkout/widgets/checkout_order_items.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/order%20details_and_checkout/checkout/widgets/checkout_payment_method.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/order%20details_and_checkout/checkout/widgets/checkout_screen_header.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/order%20details_and_checkout/checkout/widgets/checkout_secure_payment.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/order%20details_and_checkout/checkout/widgets/checkout_steps.dart';

import '../../../cart/data/cart_controller/cart_controller.dart';
import '../../../cart/data/milestone_app_6_cart_item.dart';
import '../../../Home/data/milestone_app_6_food.dart';
import '../../../state/milestone_app_6_state.dart';

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

class MilestoneApp6CheckoutScreen extends StatefulWidget {
  final MilestoneApp6State state;
  final MilestoneApp6Food? buyNowFood;
  final String? buyNowSize;
  final double? buyNowUnitPrice;
  final int? buyNowQuantity;
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

  bool get isBuyNow => buyNowItem != null || buyNowFood != null;

  MilestoneApp6CartItem? get resolvedBuyNowItem {
    if (buyNowItem != null) return buyNowItem;

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

class _MilestoneApp6CheckoutScreenState
    extends State<MilestoneApp6CheckoutScreen> {
  late final CheckoutScreenLogic logic;

  MilestoneApp6State get state => widget.state;

  bool _logicInitialized = false;
  bool _isProcessingOrder = false;

  @override
  void initState() {
    super.initState();

    logic = CheckoutScreenLogic(
      onChanged: () {
        if (mounted) setState(() {});
      },
      isMounted: () => mounted,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final cartController = context.read<CartController>();

      logic.initialize(
        context: context,
        isBuyNow: widget.isBuyNow,
        buyNowItem: widget.resolvedBuyNowItem,
        cartItems: cartController.cartItems,
      );

      if (mounted) {
        setState(() {
          _logicInitialized = true;
        });
      }
    });
  }

  /// Prevents repeated taps while the order/payment API is processing.
  Future<bool> _handlePlaceOrder() async {
    if (_isProcessingOrder || !_logicInitialized) {
      return false;
    }

    setState(() {
      _isProcessingOrder = true;
    });

    try {
      return await logic.completePayment(
        state: state,
        isBuyNow: widget.isBuyNow,
      );
    } catch (error, stackTrace) {
      debugPrint('Checkout error: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        logic.showSnackBar(
          'Unable to place order. Please try again.',
        );
      }

      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingOrder = false;
        });
      }
    }
  }

  @override
  void dispose() {
    logic.dispose();
    super.dispose();
  }

  Widget _emptyCheckout(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CheckoutScreenHeader(),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('GO TO HOME'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_logicInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (logic.orderedItems.isEmpty) {
      return _emptyCheckout(context);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  const CheckoutSteps(),
                  const SizedBox(height: 18),

                  CheckoutDeliveryAddress(state: state),
                  const SizedBox(height: 18),

                  CheckoutOrderItems(
                    items: logic.orderedItems,
                  ),
                  const SizedBox(height: 18),

                  CheckoutCouponSection(
                    controller: logic.couponController,
                    couponApplied: logic.appliedCoupon != null,
                    onApply: logic.applyCoupon,
                    onRemove: logic.removeCoupon,
                  ),
                  const SizedBox(height: 18),

                  CheckoutBillDetails(
                    subtotal: logic.subtotal,
                    shipping: logic.shipping,
                    discount: logic.discount,
                    totalPayment: logic.totalPayment,
                  ),
                  const SizedBox(height: 18),

                  CheckoutPaymentMethod(
                    selectedPaymentMethod: logic.selectedPaymentMethod,
                    onPaymentMethodChanged: (value) {
                      if (_isProcessingOrder) return;

                      setState(() {
                        logic.selectedPaymentMethod = value;
                      });
                    },
                  ),
                  const SizedBox(height: 18),

                  const CheckoutSecurePayment(),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            CheckoutBottomPayBar(
              totalPayment: logic.totalPayment,
              selectedPaymentMethod: logic.selectedPaymentMethod,
              isLoading: _isProcessingOrder,
              onPayPressed: _handlePlaceOrder,
            ),
          ],
        ),
      ),
    );
  }
}