import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/methods/cart_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/data/cart_controller/cart_controller.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/widgets/cart_app_bar.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/widgets/cart_bottom_checkout_bar.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/widgets/cart_delivery_address.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/widgets/cart_empty_state.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/widgets/cart_error_state.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/widgets/cart_item.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/widgets/cart_payment_info.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/widgets/cart_promo_section.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/widgets/cart_shimmer.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/widgets/cart_summary.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/state/milestone_app_6_state.dart';

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

  late MilestoneApp6CartScreenLogic _logic;

  MilestoneApp6State get state => widget.state;

  @override
  void initState() {
    super.initState();

    _promoController = TextEditingController(
      text: state.appliedPromoCode ?? '',
    );

    _logic = MilestoneApp6CartScreenLogic(
      context: context,
      state: state,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await context.read<CartController>().fetchCart();

      await _logic.loadAddressFromApi(
        onChanged: () {
          if (mounted) {
            setState(() {});
          }
        },
      );

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (
          context,
          controller,
          _,
          ) {
        final items = controller.cartItems;

        return Scaffold(
          // ======================================================
          // APP BAR
          // ======================================================

          appBar: MilestoneApp6CartAppBar(
            hasItems: items.isNotEmpty,
            onClear: () async {
              await _logic.confirmClearCart(context);

              if (mounted) {
                setState(() {});
              }
            },
          ),

          // ======================================================
          // BODY
          // ======================================================

          body: _buildBody(
            context,
            controller,
            items,
          ),
        );
      },
    );
  }

  // ==============================================================
  // BODY
  // ==============================================================

  Widget _buildBody(
      BuildContext context,
      CartController controller,
      List items,
      ) {
    // ------------------------------------------------------------
    // LOADING
    // ------------------------------------------------------------

    if (controller.isLoading && items.isEmpty) {
      return const MilestoneApp6CartShimmer();
    }

    // ------------------------------------------------------------
    // ERROR
    // ------------------------------------------------------------

    if (controller.errorMessage != null &&
        items.isEmpty) {
      return MilestoneApp6CartErrorState(
        message: controller.errorMessage!,
        onRetry: () {
          context.read<CartController>().fetchCart();
        },
      );
    }

    // ------------------------------------------------------------
    // EMPTY CART
    // ------------------------------------------------------------

    if (items.isEmpty) {
      return const MilestoneApp6CartEmptyState();
    }

    // ------------------------------------------------------------
    // CART CONTENT
    // ------------------------------------------------------------

    return SafeArea(
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
                  // =================================================
                  // DELIVERY ADDRESS
                  // =================================================

                  MilestoneApp6CartDeliveryAddress(
                    address: _logic.selectedApiAddress,
                    isLoading: _logic.isLoadingAddress,
                    state: state,
                    onAddressChanged: () async {
                      await _logic.loadAddressFromApi(
                        onChanged: () {
                          if (mounted) {
                            setState(() {});
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // ITEMS HEADER
                  // =================================================

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

                  // =================================================
                  // CART ITEMS
                  // =================================================

                  ...items.map(
                        (item) {
                      return MilestoneApp6CartItem(
                        item: item,
                        onUpdateQuantity: (
                            context,
                            item,
                            quantity,
                            ) async {
                          await _logic.updateQuantity(
                            item,
                            quantity,
                          );

                          if (mounted) {
                            setState(() {});
                          }
                        },
                        onDelete: (
                            context,
                            item,
                            ) async {
                          await _logic
                              .confirmDeleteCartItem(
                            context,
                            item,
                          );

                          if (mounted) {
                            setState(() {});
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  // =================================================
                  // PROMO
                  // =================================================

                  MilestoneApp6CartPromoSection(
                    state: state,
                    promoController: _promoController,
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // BILL SUMMARY
                  // =================================================

                  MilestoneApp6CartSummary(
                    itemTotal: _logic.itemTotal,
                    deliveryFee: _logic.deliveryFee,
                    discount: _logic.discount,
                    grandTotal: _logic.grandTotal,
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // PAYMENT INFORMATION
                  // =================================================

                  const MilestoneApp6CartPaymentInfo(),
                ],
              ),
            ),
          ),

          // ========================================================
          // CHECKOUT BAR
          // ========================================================

          MilestoneApp6CartBottomCheckoutBar(
            grandTotal: _logic.grandTotal,
            onCheckout: () {
              _logic.handleCheckout();
            },
          ),
        ],
      ),
    );
  }
}