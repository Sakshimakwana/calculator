import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../core/network/api_service.dart';

class OrderRepository {
  final ApiService apiService;

  OrderRepository(this.apiService);

  Future<Map<String, dynamic>> placeOrder({
    required int addressId,
    String? deliveryInstructions,
  }) async {
    final response = await apiService.post(
      ApiConstants.storeOrder,
      data: {
        'address_id': addressId,
        if (deliveryInstructions != null &&
            deliveryInstructions.trim().isNotEmpty)
          'delivery_instructions':
          deliveryInstructions.trim(),
      },
    );

    final data = Map<String, dynamic>.from(
      response.data as Map,
    );

    return data;
  }
}