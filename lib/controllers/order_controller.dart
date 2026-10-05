import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/order/order_info_model.dart';
import '../repositories/order_repository.dart';

class OrderController extends ChangeNotifier {
  final OrderRepository repository;

  OrderController(this.repository);

  // ============================================================
  // PLACE ORDER
  // ============================================================
  bool isProcessingPayment = false;
  String? paymentErrorMessage;
  Map<String, dynamic>? paymentData;
  bool isLoading = false;

  String? errorMessage;

  int? orderId;

  Map<String, dynamic>? orderData;

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

      final response = await repository.placeOrder(
        addressId: addressId,
        deliveryInstructions: deliveryInstructions,
      );

      orderData = response['data'];

      if (orderData != null) {
        orderId = int.tryParse(
          orderData?['id']?.toString() ?? '',
        );
      }

      final bool success =
          response['success'] == true;

      isLoading = false;

      notifyListeners();

      return success;
    } on DioException catch (e) {
      isLoading = false;

      errorMessage =
          e.response?.data?.toString() ??
              e.message ??
              'Unable to place order.';

      notifyListeners();

      return false;
    } catch (e) {
      isLoading = false;

      errorMessage = e.toString();

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

      notifyListeners();

      debugPrint('========== PAYMENT START ==========');
      debugPrint('Order ID: $orderId');
      debugPrint('Payment Request: $paymentRequest');

      final response = await repository.makePayment(
        orderId: orderId,
        paymentData: paymentRequest,
      );

      debugPrint('PAYMENT RESPONSE: $response');

      final success = response['success'] == true;

      if (success) {
        paymentData = response['data'];

        debugPrint('========== PAYMENT SUCCESS ==========');
        debugPrint('Order ID: $orderId');
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
            e.response?.data['message']?.toString() ??
                'Payment failed.';
      } else {
        paymentErrorMessage =
            e.message ?? 'Payment failed.';
      }

      debugPrint(
        'PAYMENT STATUS: ${e.response?.statusCode}',
      );

      debugPrint(
        'PAYMENT ERROR: ${e.response?.data}',
      );

      notifyListeners();

      return false;
    } catch (e) {
      isProcessingPayment = false;
      paymentErrorMessage = e.toString();

      notifyListeners();

      return false;
    }
  }
}