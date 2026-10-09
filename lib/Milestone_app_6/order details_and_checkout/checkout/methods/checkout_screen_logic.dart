import 'package:app_matic_tech_flutter_app/Milestone_app_6/Home/data/milestone_app_6_food.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/data/cart_controller/cart_controller.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/data/milestone_app_6_cart_item.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/model/cart_response_model.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/state/milestone_app_6_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../order_details/data/controllers/order_controller.dart';

const String razorpayKeyId = 'rzp_test_TZROdQUkcaHWjq';

/// Holds checkout state and all checkout/payment business logic.
/// The screen keeps only lifecycle and UI-building code.
class CheckoutScreenLogic {
  CheckoutScreenLogic({
    required this.onChanged,
    required this.isMounted,
  });

  final VoidCallback onChanged;
  final bool Function() isMounted;

  BuildContext? _context;
  late Razorpay _razorpay;

  int? _pendingBackendOrderId;
  String? _pendingRazorpayOrderId;

  final TextEditingController couponController = TextEditingController();
  final TextEditingController deliveryInstructionsController =
      TextEditingController();

  String? appliedCoupon;
  String? selectedPaymentMethod;
  List<MilestoneApp6CartItem> orderedItems = [];

  BuildContext get context {
    final value = _context;
    if (value == null) {
      throw StateError('CheckoutScreenLogic has not been initialized.');
    }
    return value;
  }

  void initialize({
    required BuildContext context,
    required bool isBuyNow,
    required MilestoneApp6CartItem? buyNowItem,
    required List<CartItemModel> cartItems,
  }) {
    _context = context;
    createOrderItems(
      isBuyNow: isBuyNow,
      buyNowItem: buyNowItem,
      cartItems: cartItems,
    );
    initializeRazorpay();
  }

  void initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpayInitialized = true;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  void createOrderItems({
    required bool isBuyNow,
    required MilestoneApp6CartItem? buyNowItem,
    required List<CartItemModel> cartItems,
  }) {
    if (isBuyNow) {
      orderedItems = buyNowItem == null ? [] : [copyCartItem(buyNowItem)];
    } else {
      orderedItems = cartItems.map(convertApiCartItem).toList();
    }
  }

  MilestoneApp6CartItem convertApiCartItem(CartItemModel item) {
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

  MilestoneApp6CartItem copyCartItem(MilestoneApp6CartItem item) {
    return MilestoneApp6CartItem(
      food: item.food,
      size: item.size,
      unitPrice: item.unitPrice,
      quantity: item.quantity,
    );
  }

  int get totalItemCount => orderedItems.fold<int>(
        0,
        (total, item) => total + item.quantity,
      );

  double get subtotal => orderedItems.fold<double>(
        0.0,
        (total, item) => total + item.totalPrice,
      );

  double get shipping => orderedItems.isEmpty ? 0.0 : 2.00;

  double get discount => appliedCoupon == 'FOOD10' ? subtotal * 0.10 : 0.0;

  double get totalPayment {
    final value = subtotal + shipping - discount;
    return value < 0 ? 0.0 : value;
  }

  double get minimumPayment {
    if (totalPayment <= 0) return 0.0;
    final onePercent = totalPayment * 0.01;
    return onePercent < 1.0 ? 1.0 : onePercent;
  }

  double get amountPaidNow =>
      selectedPaymentMethod == 'cod' ? 0.0 : totalPayment;

  void applyCoupon() {
    final code = couponController.text.trim().toUpperCase();

    if (code.isEmpty) {
      showSnackBar('Please enter a coupon code.');
      return;
    }

    if (code == 'FOOD10') {
      appliedCoupon = 'FOOD10';
      onChanged();
      showSnackBar('Coupon applied successfully!');
      return;
    }

    appliedCoupon = null;
    onChanged();
    showSnackBar('Invalid coupon code.');
  }

  void removeCoupon() {
    appliedCoupon = null;
    couponController.clear();
    onChanged();
    showSnackBar('Coupon removed.');
  }

  void showSnackBar(String message) {
    if (!isMounted()) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint('========== RAZORPAY PAYMENT SUCCESS ==========');
    debugPrint('Payment ID: ${response.paymentId}');
    debugPrint('Razorpay Order ID: ${response.orderId}');
    debugPrint('Signature: ${response.signature}');

    final int? backendOrderId = _pendingBackendOrderId;
    final String? razorpayOrderId = _pendingRazorpayOrderId ?? response.orderId;
    final String? razorpayPaymentId = response.paymentId;
    final String? razorpaySignature = response.signature;

    if (backendOrderId == null) {
      showSnackBar('Backend order ID is missing.');
      return;
    }
    if (razorpayOrderId == null || razorpayOrderId.isEmpty) {
      showSnackBar('Razorpay order ID is missing.');
      return;
    }
    if (razorpayPaymentId == null || razorpayPaymentId.isEmpty) {
      showSnackBar('Razorpay payment ID is missing.');
      return;
    }
    if (razorpaySignature == null || razorpaySignature.isEmpty) {
      showSnackBar('Razorpay signature is missing.');
      return;
    }

    final orderController = context.read<OrderController>();
    debugPrint('========== VERIFY RAZORPAY PAYMENT ==========');
    debugPrint('Backend Order ID: $backendOrderId');
    debugPrint('Razorpay Order ID: $razorpayOrderId');
    debugPrint('Razorpay Payment ID: $razorpayPaymentId');

    final verified = await orderController.verifyRazorpayPayment(
      orderId: backendOrderId,
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId,
      razorpaySignature: razorpaySignature,
    );

    if (!isMounted()) return;

    if (!verified) {
      showSnackBar(
        orderController.paymentErrorMessage ?? 'Payment verification failed.',
      );
      return;
    }

    debugPrint('========== RAZORPAY PAYMENT VERIFIED ==========');
    debugPrint('Verified Backend Order ID: $backendOrderId');
    await finishSuccessfulPayment(backendOrderId);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    debugPrint('========== RAZORPAY PAYMENT ERROR ==========');
    debugPrint('Code: ${response.code}');
    debugPrint('Message: ${response.message}');
    showSnackBar(response.message ?? 'Razorpay payment failed.');
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('========== RAZORPAY EXTERNAL WALLET ==========');
    debugPrint('Wallet: ${response.walletName}');
    showSnackBar(
      'External wallet selected: ${response.walletName ?? 'Unknown'}',
    );
  }

  Future<void> finishSuccessfulPayment(int backendOrderId) async {
    final orderController = context.read<OrderController>();
    final cartController = context.read<CartController>();

    final orderInfoLoaded =
        await orderController.fetchOrderInfo(backendOrderId);
    if (!orderInfoLoaded) {
      debugPrint('WARNING: Order info could not be refreshed.');
    }

// Buy Now must not clear the user's existing cart.
// A cart-clear failure should not block navigation after verified payment.
    if (!_isBuyNow) {
      try {
        await cartController.clearCart();
      } catch (error, stackTrace) {
        debugPrint(
            'WARNING: Could not clear cart after verified payment: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    _pendingBackendOrderId = null;
    _pendingRazorpayOrderId = null;

    debugPrint('========== ORDER COMPLETED ==========');
    debugPrint('VERIFIED ORDER ID: $backendOrderId');

    if (!isMounted()) return;
    context.go('/order-details/$backendOrderId');
  }

  bool _isBuyNow = false;
  bool _razorpayInitialized = false;

  void openRazorpayCheckout({
    required int backendOrderId,
    required Map<String, dynamic> paymentData,
  }) {
    final String? razorpayOrderId =
        paymentData['razorpay_order_id']?.toString();
    final int amount =
        int.tryParse(paymentData['amount']?.toString() ?? '0') ?? 0;
    final String currency = paymentData['currency']?.toString() ?? 'INR';

    if (razorpayOrderId == null || razorpayOrderId.isEmpty) {
      debugPrint('Razorpay order ID missing');
      showSnackBar('Razorpay order ID is missing.');
      return;
    }

    _pendingBackendOrderId = backendOrderId;
    _pendingRazorpayOrderId = razorpayOrderId;

    final Map<String, dynamic> options = {
      'key': razorpayKeyId,
      'amount': amount,
      'currency': currency,
      'name': 'Tomato',
      'description': 'Food Order #$backendOrderId',
      'order_id': razorpayOrderId,
      'retry': {'enabled': true},
      'send_sms_hash': true,
      'theme': {'color': '#FF5722'},
    };

    debugPrint('Opening Razorpay Checkout...');
    debugPrint('Razorpay Order ID: $razorpayOrderId');
    debugPrint('Amount: $amount');
    debugPrint('Currency: $currency');
    _razorpay.open(options);
  }

  Future<bool> completePayment({
    required MilestoneApp6State state,
    required bool isBuyNow,
  }) async {
    _isBuyNow = isBuyNow;
    final orderController = context.read<OrderController>();
    final cartController = context.read<CartController>();

    final selectedAddress = state.selectedAddress;
    if (selectedAddress == null) {
      showSnackBar('Please select a delivery address.');
      return false;
    }

    final int? addressId = int.tryParse(selectedAddress.id.toString());
    if (addressId == null) {
      showSnackBar('Invalid delivery address.');
      return false;
    }

    final String? paymentMethod = selectedPaymentMethod;
    if (paymentMethod == null) {
      showSnackBar('Please select a payment method.');
      return false;
    }

    debugPrint('========== PLACE ORDER =========');
    final bool orderPlaced = await orderController.placeOrder(
      addressId: addressId,
      deliveryInstructions: deliveryInstructionsController.text.trim(),
    );

    if (!isMounted()) return false;

    if (!orderPlaced) {
      showSnackBar(orderController.errorMessage ?? 'Unable to place order.');
      return false;
    }

    final int? newOrderId = orderController.orderId;
    if (newOrderId == null) {
      showSnackBar('Order ID was not received.');
      return false;
    }

    debugPrint('NEW ORDER CREATED: $newOrderId');
    final String backendPaymentMethod =
        paymentMethod == 'online' ? 'razorpay' : 'cod';

    debugPrint('========== PAYMENT API =========');
    debugPrint('Backend Payment Method: $backendPaymentMethod');

    final bool paymentSuccess = await orderController.makePayment(
      orderId: newOrderId,
      paymentRequest: {'payment_method': backendPaymentMethod},
    );

    if (!isMounted()) return false;

    if (!paymentSuccess) {
      showSnackBar(orderController.paymentErrorMessage ?? 'Payment failed.');
      return false;
    }

    debugPrint('========== PAYMENT API SUCCESS =========');
    debugPrint('Payment created for order: $newOrderId');

    if (paymentMethod == 'online') {
      final Map<String, dynamic>? paymentData = orderController.paymentData;
      if (paymentData == null) {
        showSnackBar('Razorpay payment data was not received.');
        return false;
      }

      debugPrint('========== RAZORPAY PAYMENT DATA =========');
      debugPrint('$paymentData');
      openRazorpayCheckout(
        paymentData: paymentData,
        backendOrderId: newOrderId,
      );
      return true;
    }

    final bool orderInfoLoaded =
        await orderController.fetchOrderInfo(newOrderId);
    if (!orderInfoLoaded) {
      debugPrint(
        'WARNING: Order info could not be refreshed after COD payment.',
      );
    }

    if (!isBuyNow) {
      try {
        await cartController.clearCart();
      } catch (error, stackTrace) {
        debugPrint('WARNING: Could not clear cart after COD order: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    debugPrint('========== COD ORDER COMPLETED =========');
    debugPrint('COD ORDER ID: $newOrderId');

// Navigate after the COD order and payment API succeed.
    if (!isMounted()) return false;
    context.go('/order-details/$newOrderId');
    return true;
  }

  void dispose() {
    if (_razorpayInitialized) {
      _razorpay.clear();
    }
    couponController.dispose();
    deliveryInstructionsController.dispose();
  }
}
