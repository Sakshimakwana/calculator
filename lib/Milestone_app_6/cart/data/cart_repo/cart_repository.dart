import 'package:app_matic_tech_flutter_app/Milestone_app_6/core/constants/api_constants.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/core/network/api_service.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/model/cart_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


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
      // Fetch the latest cart from the backend.
      final currentCart = await fetchCart();

      // Delete every cart item from the backend.
      for (final item in currentCart.data) {
        await deleteCart(cartId: item.id);
      }

      // Verify that the cart is empty.
      final remainingCart = await fetchCart();

      if (remainingCart.data.isNotEmpty) {
        throw Exception(
          'Failed to remove all cart products.',
        );
      }

      debugPrint('CART CLEARED SUCCESSFULLY');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?.toString() ??
            e.message ??
            'Unable to clear cart.',
      );
    }
  }

}
