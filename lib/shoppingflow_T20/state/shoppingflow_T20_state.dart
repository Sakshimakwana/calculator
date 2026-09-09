import 'package:flutter/foundation.dart';

import '../data/shoppingflow_T20_data.dart';
import '../model/shoppingflow_user_model.dart';

class ShoppingFlowT20State extends ChangeNotifier {

  // =========================================================
  // AUTHENTICATION
  // =========================================================

  bool isLoggedIn = false;

  ShoppingUser? currentUser;

  // =========================================================
  // CART
  // =========================================================

  final Map<String, int> _cart = {};

  // =========================================================
  // FAVOURITES
  // =========================================================

  final Set<String> _favourites = {
    '1',
    '2',
    '3',
  };

  // =========================================================
  // ORDERS
  // =========================================================

  final List<Map<String, dynamic>> orders = [];

  // =========================================================
  // SIGN UP
  // =========================================================

  void signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) {
    currentUser = ShoppingUser(
      name: name,
      email: email,
      phone: phone,
      password: password,
      address: address,
    );

    isLoggedIn = true;

    notifyListeners();
  }

  // =========================================================
  // LOGIN
  // =========================================================

  bool login({
    required String email,
    required String password,
  }) {
    if (currentUser == null) {
      return false;
    }

    if (currentUser!.email == email &&
        currentUser!.password == password) {
      isLoggedIn = true;

      notifyListeners();

      return true;
    }

    return false;
  }

  // =========================================================
  // UPDATE PROFILE
  // =========================================================

  void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) {
    if (currentUser == null) {
      return;
    }

    currentUser!.name = name;
    currentUser!.email = email;
    currentUser!.phone = phone;
    currentUser!.address = address;

    notifyListeners();
  }

  // =========================================================
  // CART FUNCTIONS
  // =========================================================

  int quantity(String productId) {
    return _cart[productId] ?? 0;
  }

  void addToCart(String productId) {
    _cart[productId] = quantity(productId) + 1;

    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    final current = quantity(productId);

    if (current <= 1) {
      _cart.remove(productId);
    } else {
      _cart[productId] = current - 1;
    }

    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.remove(productId);

    notifyListeners();
  }

  List get cartProducts {
    return shoppingFlowT20Products
        .where(
          (product) => _cart.containsKey(product.id),
    )
        .toList();
  }

  // =========================================================
  // FAVOURITE FUNCTIONS
  // =========================================================

  bool isFavourite(String productId) {
    return _favourites.contains(productId);
  }

  void toggleFavourite(String productId) {
    if (_favourites.contains(productId)) {
      _favourites.remove(productId);
    } else {
      _favourites.add(productId);
    }

    notifyListeners();
  }

  List get favouriteProducts {
    return shoppingFlowT20Products
        .where(
          (product) =>
          _favourites.contains(product.id),
    )
        .toList();
  }

  // =========================================================
  // PRICE
  // =========================================================

  double get subtotal {
    double total = 0;

    for (final product in cartProducts) {
      total += product.price * quantity(product.id);
    }

    return total;
  }

  double get shipping {
    return cartProducts.isEmpty ? 0 : 10;
  }

  double get total {
    return subtotal + shipping;
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  void logout() {
    isLoggedIn = false;
    currentUser = null;

    notifyListeners();
  }

  // =========================================================
  // PLACE ORDER
  // =========================================================

  void placeOrder() {
    orders.insert(
      0,
      {
        'id': '#${1230 + orders.length + 1}',
        'total': total,
        'status': 'Processing',
      },
    );

    _cart.clear();

    notifyListeners();
  }
}

final shoppingFlowT20State =
ShoppingFlowT20State();