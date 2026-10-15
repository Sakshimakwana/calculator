import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../model/cart_response_model.dart';
import '../cart_repo/cart_repository.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/data/address_storage/address_cart_storage.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/data/address_storage/address_storage.dart';

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

      // Clear local cart only after the repository succeeds.
      cartItems.clear();

      isDeletingCart = false;
      notifyListeners();

      debugPrint('Cart cleared successfully');
      return true;
    } catch (e) {
      isDeletingCart = false;
      errorMessage = e.toString();

      notifyListeners();

      debugPrint('Failed to clear cart: $e');
      return false;
    }
  }

  Future<bool> switchAddressCart({
    required int? oldAddressId,
    required int newAddressId,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // 1. Get the latest backend cart before changing addresses.
      final currentResponse = await repository.fetchCart();
      final currentItems = currentResponse.data;

      // 2. Save the current cart against the old address.
      if (oldAddressId != null) {
        final snapshot = currentItems.map((item) {
          return <String, int>{
            'menu_item_id': item.menuItem.id,
            'restaurant_id': item.restaurantId,
            'quantity': item.quantity,
          };
        }).toList();

        await AddressCartStorage.saveCart(
          addressId: oldAddressId,
          items: snapshot,
        );
      }

      // 3. Clear the active backend cart.
      await repository.clearCart();

      // 4. Restore the cart previously saved for the new address.
      final savedItems = await AddressCartStorage.getCart(newAddressId);

      for (final item in savedItems) {
        await repository.addToCart(
          menuItemId: item['menu_item_id']!,
          restaurantId: item['restaurant_id']!,
          quantity: item['quantity']!,
        );
      }

      // 5. Refresh the controller with the active address's cart.
      final updatedResponse = await repository.fetchCart();
      cartItems = updatedResponse.data;

      isLoading = false;
      notifyListeners();

      debugPrint(
        'Cart switched from address $oldAddressId to $newAddressId. '
            'Restored ${cartItems.length} item(s).',
      );

      return true;
    } catch (e) {
      errorMessage = 'Unable to switch address cart: $e';

      // Best-effort rollback: restore the old address's saved cart.
      try {
        await repository.clearCart();

        if (oldAddressId != null) {
          final oldItems = await AddressCartStorage.getCart(oldAddressId);

          for (final item in oldItems) {
            await repository.addToCart(
              menuItemId: item['menu_item_id']!,
              restaurantId: item['restaurant_id']!,
              quantity: item['quantity']!,
            );
          }
        }

        final rollbackResponse = await repository.fetchCart();
        cartItems = rollbackResponse.data;
      } catch (rollbackError) {
        debugPrint('Cart rollback failed: $rollbackError');
      }

      isLoading = false;
      notifyListeners();

      debugPrint('Failed to switch address cart: $e');
      return false;
    }
  }

}
