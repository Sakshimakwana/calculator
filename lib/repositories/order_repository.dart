import '../core/constants/api_constants.dart';
import '../core/network/api_service.dart';
import '../models/order_info_model.dart';

class OrderRepository {
  final ApiService apiService;

  OrderRepository(this.apiService);

  // ============================================================
  // PLACE ORDER
  // POST /orders/store
  // ============================================================

  Future<Map<String, dynamic>> placeOrder({
    required int addressId,
    String? deliveryInstructions,
  }) async {
    final response = await apiService.post(
      ApiConstants.placeOrder,
      data: {
        'address_id': addressId,
        'delivery_instructions':
        deliveryInstructions,
      },
    );

    return Map<String, dynamic>.from(
      response.data as Map,
    );
  }

  // ============================================================
  // ORDER INFO
  // GET /orders/{orderId}
  // ============================================================

  Future<OrderInfoResponseModel> fetchOrderInfo(
      int orderId,
      ) async {
    final response = await apiService.get(
      ApiConstants.orderInfo(orderId),
    );

    final Map<String, dynamic> data =
    Map<String, dynamic>.from(
      response.data as Map,
    );

    return OrderInfoResponseModel.fromJson(
      data,
    );
  }
}