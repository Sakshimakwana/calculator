import 'package:app_matic_tech_flutter_app/models/cart_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../repositories/cart_repository.dart';

class CartController extends ChangeNotifier {
  final CartRepository repository;

  CartController(this.repository);

  bool isLoading = false;
  bool isAddingToCart = false;
  bool isUpdatingCart = false;

  String? errorMessage;

  List<CartItemModel> cartItems = [];

  // =========================================================
  // FETCH CART
  // =========================================================

  Future<bool> fetchCart() async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    print('');
    print('========================================');
    print('           FETCH CART STARTED');
    print('========================================');
    print('Calling: GET /cart');

    try {
      final response = await repository.fetchCart();

      cartItems = response.data;

      print('');
      print('========================================');
      print('           FETCH CART SUCCESS');
      print('========================================');
      print('Success: ${response.success}');
      print('Message: ${response.message}');
      print('Cart Items: ${cartItems.length}');

      for (final item in cartItems) {
        print(
          'Food: ${item.menuItem.name} | '
              'Quantity: ${item.quantity} | '
              'Restaurant: ${item.restaurant.name}',
        );
      }

      print('========================================');
      print('');

      isLoading = false;
      notifyListeners();

      return response.success;
    } on DioException catch (e) {
      isLoading = false;

      print('');
      print('========================================');
      print('            FETCH CART FAILED');
      print('========================================');
      print('Status Code: ${e.response?.statusCode}');
      print('Error: ${e.message}');
      print('Response: ${e.response?.data}');
      print('========================================');
      print('');

      errorMessage =
      e.response?.data is Map
          ? e.response?.data['message']?.toString() ??
          'Failed to fetch cart'
          : 'Failed to fetch cart';

      notifyListeners();

      return false;
    } catch (e) {
      isLoading = false;

      print('');
      print('========================================');
      print('        FETCH CART UNKNOWN ERROR');
      print('========================================');
      print('Error: $e');
      print('========================================');
      print('');

      errorMessage = 'Something went wrong while fetching cart.';

      notifyListeners();

      return false;
    }
  }

  // =========================================================
  // ADD TO CART
  // =========================================================

  Future<bool> addToCart({
    required int menuItemId,
    required int quantity,
    required int restaurantId,
  }) async {
    isAddingToCart = true;
    errorMessage = null;

    notifyListeners();

    print('');
    print('========================================');
    print('          ADD TO CART STARTED');
    print('========================================');
    print('Menu Item ID: $menuItemId');
    print('Quantity: $quantity');
    print('Restaurant ID: $restaurantId');
    print('Calling: POST /carts/store');

    try {
      final response = await repository.addToCart(
        menuItemId: menuItemId,
        quantity: quantity,
        restaurantId: restaurantId,
      );

      print('');
      print('========================================');
      print('          ADD TO CART SUCCESS');
      print('========================================');
      print('Cart ID: ${response.id}');
      print('Food: ${response.menuItem.name}');
      print('Quantity: ${response.quantity}');
      print('Restaurant: ${response.restaurant.name}');
      print('========================================');
      print('');

      isAddingToCart = false;

      notifyListeners();

      // Get latest cart from backend
      await fetchCart();

      return true;
    } on DioException catch (e) {
      isAddingToCart = false;

      print('');
      print('========================================');
      print('           ADD TO CART FAILED');
      print('========================================');
      print('Status Code: ${e.response?.statusCode}');
      print('Error: ${e.message}');
      print('Response: ${e.response?.data}');
      print('========================================');
      print('');

      final responseData = e.response?.data;

      if (responseData is Map) {
        errorMessage =
            responseData['message']?.toString() ??
                'Failed to add item to cart';
      } else {
        errorMessage =
        'Failed to add item to cart. Please try again.';
      }

      notifyListeners();

      return false;
    } catch (e) {
      isAddingToCart = false;

      print('');
      print('========================================');
      print('       ADD TO CART UNKNOWN ERROR');
      print('========================================');
      print('Error: $e');
      print('========================================');
      print('');

      errorMessage =
      'Something went wrong while adding to cart.';

      notifyListeners();

      return false;
    }
  }
  Future<bool> updateCartQuantity({
    required int cartId,
    required int quantity,
  }) async {
    try {
      isUpdatingCart = true;
      errorMessage = null;
      notifyListeners();

      debugPrint('');
      debugPrint('========================================');
      debugPrint('       UPDATE CART QUANTITY');
      debugPrint('========================================');
      debugPrint('Cart ID: $cartId');
      debugPrint('Quantity: $quantity');
      debugPrint(
        'Endpoint: PUT /carts/$cartId/update',
      );
      debugPrint('========================================');

      await repository.updateCartQuantity(
        cartId: cartId,
        quantity: quantity,
      );

      isUpdatingCart = false;
      notifyListeners();

      // Get latest cart from backend.
      await fetchCart();

      return true;
    } on DioException catch (e) {
      isUpdatingCart = false;

      errorMessage =
          e.response?.data?['message']?.toString() ??
              e.message ??
              'Failed to update cart quantity';

      debugPrint(
        'UPDATE CART ERROR: $errorMessage',
      );

      notifyListeners();

      return false;
    } catch (e) {
      isUpdatingCart = false;
      errorMessage = e.toString();

      debugPrint(
        'UPDATE CART ERROR: $e',
      );

      notifyListeners();

      return false;
    }
  }
}