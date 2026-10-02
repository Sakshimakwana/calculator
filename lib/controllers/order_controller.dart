import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../repositories/order_repository.dart';

class OrderController extends ChangeNotifier {
  final OrderRepository repository;

  OrderController(this.repository);

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

      debugPrint('');
      debugPrint('========================================');
      debugPrint('          PLACE ORDER API');
      debugPrint('========================================');
      debugPrint('METHOD: POST');
      debugPrint('ENDPOINT: /orders/store');
      debugPrint('ADDRESS ID: $addressId');
      debugPrint(
        'DELIVERY INSTRUCTIONS: '
            '${deliveryInstructions ?? ''}',
      );
      debugPrint('========================================');

      final response = await repository.placeOrder(
        addressId: addressId,
        deliveryInstructions: deliveryInstructions,
      );

      orderData = response['data'];

      if (orderData != null) {
        orderId = int.tryParse(
          orderData!['id'].toString(),
        );
      }

      final bool success =
          response['success'] == true;

      debugPrint('');
      debugPrint('========================================');
      debugPrint('          PLACE ORDER RESPONSE');
      debugPrint('========================================');
      debugPrint('SUCCESS: $success');
      debugPrint(
        'MESSAGE: ${response['message']}',
      );
      debugPrint('ORDER ID: $orderId');
      debugPrint(
        'STATUS: ${orderData?['status']}',
      );
      debugPrint(
        'TOTAL: ${orderData?['total']}',
      );
      debugPrint('========================================');

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
        'PLACE ORDER API ERROR: $errorMessage',
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
}