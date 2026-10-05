import 'package:app_matic_tech_flutter_app/models/cart/cart_response_model.dart';
import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../core/network/api_service.dart';

class CartRepository {
  final ApiService apiService;

  CartRepository(this.apiService);

  // ==============================
  // FETCH CART
  // ==============================

  Future<CartResponseModel> fetchCart() async {
    final response = await apiService.get(
      ApiConstants.fetchCart,
      queryParameters: {
        'per_page': 20,
      },
    );

    final data = Map<String, dynamic>.from(response.data);

    return CartResponseModel.fromJson(data);
  }

  // ==============================
  // ADD TO CART
  // ==============================

  Future<CartItemModel> addToCart({
    required int menuItemId,
    required int quantity,
    required int restaurantId,
  }) async {
    final response = await apiService.post(
      ApiConstants.storeCart,
      data: {
        'menu_item_id': menuItemId,
        'quantity': quantity,
        'restaurant_id': restaurantId,
      },
    );

    final data = Map<String, dynamic>.from(response.data);

    return CartItemModel.fromJson(
      Map<String, dynamic>.from(data['data']),
    );
  }
  Future<CartItemModel> updateCartQuantity({
    required int cartId,
    required int quantity,
  }) async {
    final response = await apiService.put(
      ApiConstants.updateCart(cartId),
      data: {
        'quantity': quantity,
      },
    );

    final data = Map<String, dynamic>.from(response.data as Map);

    return CartItemModel.fromJson(
      Map<String, dynamic>.from(data['data']),
    );
  }
  Future<void> deleteCart({
    required int cartId,
  }) async {
    await apiService.delete(
      ApiConstants.deleteCart(cartId),
    );
  }
  // ==============================
  // CLEAR CART
  // ==============================

  Future<void> clearCart() async {
    try {
      final response = await apiService.delete(
        ApiConstants.clearCart,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 204) {
        return;
      }

      throw Exception(
        'Clear cart failed: ${response.statusCode}',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data ??
            e.message ??
            'Unable to clear cart',
      );
    }
  }
}
