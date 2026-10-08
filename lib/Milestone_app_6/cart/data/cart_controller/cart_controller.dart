import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../model/cart_response_model.dart';
import '../cart_repo/cart_repository.dart';

class CartController extends ChangeNotifier {
  final CartRepository repository;

  CartController(this.repository);

  bool isLoading = false;
  bool isAddingToCart = false;
  bool isUpdatingCart = false;
  bool isDeletingCart = false;

  String? errorMessage;

  List<CartItemModel> cartItems = [];

  Future<bool> fetchCart() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response =
      await repository.fetchCart();

      cartItems = response.data;

      isLoading = false;
      notifyListeners();

      return response.success;
    } on DioException catch (e) {
      isLoading = false;
      errorMessage =
          e.response?.data?.toString() ??
              e.message ??
              'Unable to load cart.';
      notifyListeners();
      return false;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> addToCart({
    required int menuItemId,
    required int quantity,
    required int restaurantId,
  }) async {
    try {
      isAddingToCart = true;
      errorMessage = null;
      notifyListeners();

      await repository.addToCart(
        menuItemId: menuItemId,
        quantity: quantity,
        restaurantId: restaurantId,
      );

      isAddingToCart = false;
      notifyListeners();

      await fetchCart();

      return true;
    } on DioException catch (e) {
      isAddingToCart = false;
      errorMessage =
          e.response?.data?.toString() ??
              e.message ??
              'Unable to add item to cart.';
      notifyListeners();
      return false;
    } catch (e) {
      isAddingToCart = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCartQuantity({
    required int cartId,
    required int quantity,
  }) async {
    if (quantity < 1) {
      return false;
    }

    try {
      isUpdatingCart = true;
      errorMessage = null;
      notifyListeners();

      await repository.updateCartQuantity(
        cartId: cartId,
        quantity: quantity,
      );

      isUpdatingCart = false;
      notifyListeners();

      await fetchCart();

      return true;
    } on DioException catch (e) {
      isUpdatingCart = false;
      errorMessage =
          e.response?.data?.toString() ??
              e.message ??
              'Unable to update cart.';
      notifyListeners();
      return false;
    } catch (e) {
      isUpdatingCart = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ================================================================
  // DELETE ONE PRODUCT
  // ================================================================

  Future<bool> deleteCart({
    required int cartId,
  }) async {
    try {
      isDeletingCart = true;
      errorMessage = null;
      notifyListeners();

      await repository.deleteCart(
        cartId: cartId,
      );

      isDeletingCart = false;
      notifyListeners();

      await fetchCart();

      return true;
    } on DioException catch (e) {
      isDeletingCart = false;
      errorMessage =
          e.response?.data?.toString() ??
              e.message ??
              'Unable to delete cart item.';
      notifyListeners();
      return false;
    } catch (e) {
      isDeletingCart = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ================================================================
  // CLEAR ALL PRODUCTS
  //
  // The verified backend endpoint available in the supplied
  // Postman collection is DELETE /carts/{cartId}/destroy.
  // Therefore clear-all is implemented by deleting every current
  // cart row through that same single-item DELETE API.
  // ================================================================

  // ================================================================
// CLEAR ALL PRODUCTS
// DELETE /cart
// ================================================================

  Future<bool> clearCart() async {
    try {
      isDeletingCart = true;
      errorMessage = null;
      notifyListeners();

      await repository.clearCart();

      cartItems.clear();

      isDeletingCart = false;
      notifyListeners();

      return true;
    } on DioException catch (e) {
      isDeletingCart = false;

      errorMessage =
          e.response?.data?.toString() ??
              e.message ??
              'Unable to clear cart.';

      notifyListeners();

      return false;
    } catch (e) {
      isDeletingCart = false;
      errorMessage = e.toString();

      notifyListeners();

      return false;
    }
  }
}
