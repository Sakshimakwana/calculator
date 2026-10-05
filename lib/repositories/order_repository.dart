import '../core/constants/api_constants.dart';
import '../core/network/api_service.dart';
import 'package:app_matic_tech_flutter_app/models/order/order_info_model.dart';
import '../models/order/my_orders_response_model.dart';

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
        'delivery_instructions': deliveryInstructions,
      },
    );

    return Map<String, dynamic>.from(
      response.data as Map,
    );
  }

  // ============================================================
  // MY ORDERS
  // GET /orders?page=1&per_page=6
  // ============================================================

  Future<MyOrdersResponseModel> fetchMyOrders({
    int page = 1,
    int perPage = 6,
  }) async {
    final response = await apiService.get(
      ApiConstants.myOrders,
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );

    final Map<String, dynamic> data =
    Map<String, dynamic>.from(
      response.data as Map,
    );

    return MyOrdersResponseModel.fromJson(data);
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

    return OrderInfoResponseModel.fromJson(data);
  }
  Future<Map<String, dynamic>> makePayment({
    required int orderId,
    required Map<String, dynamic> paymentData,
  }) async {
    final response = await apiService.post(
      ApiConstants.makePayment(orderId),
      data: paymentData,
    );

    return Map<String, dynamic>.from(
      response.data as Map,
    );
  }
}