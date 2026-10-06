import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/order/order_info_model.dart';
import '../repositories/order_repository.dart';

class OrderController extends ChangeNotifier {
  final OrderRepository repository;

  OrderController(this.repository);

  // ============================================================
  // PAYMENT STATE
  // ============================================================

  bool isProcessingPayment = false;

  String? paymentErrorMessage;

  Map<String, dynamic>? paymentData;

  // ============================================================
  // PLACE ORDER STATE
  // ============================================================

  bool isLoading = false;

  String? errorMessage;

  int? orderId;

  Map<String, dynamic>? orderData;

  // ============================================================
  // PLACE ORDER
  // POST /orders/store
  // ============================================================

  Future<bool> placeOrder({
    required int addressId,
    String? deliveryInstructions,
  }) async {
    if (isLoading) {
      return false;
    }

    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      debugPrint('========== PLACE ORDER START ==========');
      debugPrint('Address ID: $addressId');
      debugPrint(
        'Delivery Instructions: $deliveryInstructions',
      );

      final response = await repository.placeOrder(
        addressId: addressId,
        deliveryInstructions: deliveryInstructions,
      );

      debugPrint('PLACE ORDER RESPONSE: $response');

      orderData = response['data'];

      if (orderData != null) {
        orderId = int.tryParse(
          orderData?['id']?.toString() ?? '',
        );
      }

      final bool success =
          response['success'] == true;

      if (success) {
        debugPrint(
            '========== ORDER CREATED =========='
        );
        debugPrint('NEW ORDER ID: $orderId');
      } else {
        errorMessage =
            response['message']?.toString() ??
                'Unable to place order.';
      }

      isLoading = false;

      notifyListeners();

      return success;
    } on DioException catch (e) {
      isLoading = false;

      errorMessage =
          e.response?.data?.toString() ??
              e.message ??
              'Unable to place order.';

      debugPrint(
        'PLACE ORDER STATUS: ${e.response?.statusCode}',
      );

      debugPrint(
        'PLACE ORDER ERROR: ${e.response?.data}',
      );

      notifyListeners();

      return false;
    } catch (e) {
      isLoading = false;

      errorMessage = e.toString();

      debugPrint(
        'PLACE ORDER ERROR: $e',
      );

      notifyListeners();

      return false;
    }
  }

  // ============================================================
  // MY ORDERS
  // ============================================================

  final List<OrderInfoModel> myOrders =
  <OrderInfoModel>[];

  bool isLoadingMyOrders = false;

  bool isLoadingMoreMyOrders = false;

  String? myOrdersErrorMessage;

  int myOrdersCurrentPage = 0;

  int myOrdersLastPage = 1;

  bool myOrdersHasMore = false;

  int myOrdersTotal = 0;

  // ============================================================
  // FETCH FIRST PAGE
  // ============================================================

  Future<bool> fetchMyOrders({
    bool refresh = false,
  }) async {
    if (isLoadingMyOrders ||
        isLoadingMoreMyOrders) {
      return false;
    }

    try {
      if (refresh) {
        myOrdersCurrentPage = 0;
        myOrdersLastPage = 1;
        myOrdersHasMore = false;
        myOrders.clear();
      }

      isLoadingMyOrders = true;
      myOrdersErrorMessage = null;

      notifyListeners();

      final response =
      await repository.fetchMyOrders(
        page: 1,
        perPage: 6,
      );

      myOrders.clear();
      myOrders.addAll(response.data);

      myOrdersCurrentPage =
          response.pagination.currentPage;

      myOrdersLastPage =
          response.pagination.lastPage;

      myOrdersHasMore =
          response.pagination.hasMorePages;

      myOrdersTotal =
          response.pagination.total;

      isLoadingMyOrders = false;

      notifyListeners();

      return response.success;
    } on DioException catch (e) {
      isLoadingMyOrders = false;

      myOrdersErrorMessage =
          e.response?.data?.toString() ??
              e.message ??
              'Unable to load orders.';

      notifyListeners();

      return false;
    } catch (e) {
      isLoadingMyOrders = false;

      myOrdersErrorMessage = e.toString();

      notifyListeners();

      return false;
    }
  }

  // ============================================================
  // LOAD NEXT PAGE
  // ============================================================

  Future<bool> loadMoreMyOrders() async {
    if (isLoadingMyOrders ||
        isLoadingMoreMyOrders ||
        !myOrdersHasMore) {
      return false;
    }

    if (myOrdersCurrentPage >=
        myOrdersLastPage) {
      myOrdersHasMore = false;

      notifyListeners();

      return false;
    }

    try {
      isLoadingMoreMyOrders = true;

      notifyListeners();

      final int nextPage =
          myOrdersCurrentPage + 1;

      debugPrint(
        'MY ORDERS: Loading page $nextPage',
      );

      final response =
      await repository.fetchMyOrders(
        page: nextPage,
        perPage: 6,
      );

      myOrders.addAll(response.data);

      myOrdersCurrentPage =
          response.pagination.currentPage;

      myOrdersLastPage =
          response.pagination.lastPage;

      myOrdersHasMore =
          response.pagination.hasMorePages;

      myOrdersTotal =
          response.pagination.total;

      isLoadingMoreMyOrders = false;

      notifyListeners();

      return response.success;
    } on DioException catch (e) {
      isLoadingMoreMyOrders = false;

      myOrdersErrorMessage =
          e.response?.data?.toString() ??
              e.message ??
              'Unable to load more orders.';

      notifyListeners();

      return false;
    } catch (e) {
      isLoadingMoreMyOrders = false;

      myOrdersErrorMessage = e.toString();

      notifyListeners();

      return false;
    }
  }

  // ============================================================
  // ORDER INFO
  // GET /orders/{orderId}
  // ============================================================

  OrderInfoModel? orderInfo;

  bool isLoadingOrderInfo = false;

  String? orderInfoErrorMessage;

  Future<bool> fetchOrderInfo(
      int orderId,
      ) async {
    try {
      isLoadingOrderInfo = true;
      orderInfoErrorMessage = null;

      notifyListeners();

      final response =
      await repository.fetchOrderInfo(
        orderId,
      );

      orderInfo = response.data;

      isLoadingOrderInfo = false;

      notifyListeners();

      return response.success;
    } on DioException catch (e) {
      isLoadingOrderInfo = false;

      orderInfoErrorMessage =
          e.response?.data?.toString() ??
              e.message ??
              'Unable to load order details.';

      notifyListeners();

      return false;
    } catch (e) {
      isLoadingOrderInfo = false;

      orderInfoErrorMessage = e.toString();

      notifyListeners();

      return false;
    }
  }

  Future<bool> makePayment({
    required int orderId,
    required Map<String, dynamic> paymentRequest,
  }) async {
    if (isProcessingPayment) {
      return false;
    }

    try {
      isProcessingPayment = true;
      paymentErrorMessage = null;

      // Clear previous payment response.
      paymentData = null;

      notifyListeners();

      debugPrint(
        '========== PAYMENT START ==========',
      );

      debugPrint(
        'Order ID: $orderId',
      );

      debugPrint(
        'Payment Request: $paymentRequest',
      );

      final response =
      await repository.makePayment(
        orderId: orderId,
        paymentData: paymentRequest,
      );

      debugPrint(
        'PAYMENT RESPONSE: $response',
      );

      final bool success =
          response['success'] == true;

      if (success) {
        final dynamic data =
        response['data'];

        if (data is Map) {
          paymentData =
          Map<String, dynamic>.from(data);
        }

        debugPrint(
            '========== PAYMENT CREATED =========='
        );

        debugPrint(
          'Backend Order ID: $orderId',
        );

        debugPrint(
          'Payment Data: $paymentData',
        );
      } else {
        paymentErrorMessage =
            response['message']?.toString() ??
                'Payment failed.';
      }

      isProcessingPayment = false;

      notifyListeners();

      return success;
    } on DioException catch (e) {
      isProcessingPayment = false;

      if (e.response?.data is Map) {
        paymentErrorMessage =
            e.response?.data['message']
                ?.toString() ??
                'Payment failed.';
      } else {
        paymentErrorMessage =
            e.message ??
                'Payment failed.';
      }

      debugPrint(
        'PAYMENT STATUS: '
            '${e.response?.statusCode}',
      );

      debugPrint(
        'PAYMENT ERROR: '
            '${e.response?.data}',
      );

      notifyListeners();

      return false;
    } catch (e) {
      isProcessingPayment = false;

      paymentErrorMessage = e.toString();

      debugPrint(
        'PAYMENT ERROR: $e',
      );

      notifyListeners();

      return false;
    }
  }

  // ============================================================
  // VERIFY RAZORPAY PAYMENT
  // POST /orders/{orderId}/payment/verify
  // ============================================================

  Future<bool> verifyRazorpayPayment({
    required int orderId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    if (isProcessingPayment) {
      return false;
    }

    try {
      isProcessingPayment = true;
      paymentErrorMessage = null;

      notifyListeners();

      debugPrint(
          '========== RAZORPAY VERIFY START =========='
      );

      debugPrint(
        'Backend Order ID: $orderId',
      );

      debugPrint(
        'Razorpay Order ID: $razorpayOrderId',
      );

      debugPrint(
        'Razorpay Payment ID: $razorpayPaymentId',
      );

      debugPrint(
        'Razorpay Signature: $razorpaySignature',
      );

      final response =
      await repository.verifyPayment(
        orderId: orderId,
        paymentData: {
          'razorpay_order_id':
          razorpayOrderId,
          'razorpay_payment_id':
          razorpayPaymentId,
          'razorpay_signature':
          razorpaySignature,
        },
      );

      debugPrint(
        'RAZORPAY VERIFY RESPONSE: '
            '$response',
      );

      final bool success =
          response['success'] == true;

      if (success) {
        final dynamic data =
        response['data'];

        if (data is Map) {
          paymentData =
          Map<String, dynamic>.from(data);
        }

        debugPrint(
            '========== RAZORPAY VERIFIED =========='
        );

        debugPrint(
          'Backend Order ID: $orderId',
        );

        debugPrint(
          'Payment Status: paid',
        );
      } else {
        paymentErrorMessage =
            response['message']?.toString() ??
                'Payment verification failed.';
      }

      isProcessingPayment = false;

      notifyListeners();

      return success;
    } on DioException catch (e) {
      isProcessingPayment = false;

      if (e.response?.data is Map) {
        paymentErrorMessage =
            e.response?.data['message']
                ?.toString() ??
                'Payment verification failed.';
      } else {
        paymentErrorMessage =
            e.message ??
                'Payment verification failed.';
      }

      debugPrint(
        'VERIFY STATUS: '
            '${e.response?.statusCode}',
      );

      debugPrint(
        'VERIFY ERROR: '
            '${e.response?.data}',
      );

      notifyListeners();

      return false;
    } catch (e) {
      isProcessingPayment = false;

      paymentErrorMessage = e.toString();

      debugPrint(
        'VERIFY ERROR: $e',
      );

      notifyListeners();

      return false;
    }
  }
}