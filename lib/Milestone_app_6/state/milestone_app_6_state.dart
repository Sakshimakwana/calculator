import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/milestone_app_6_address_data.dart';
import '../data/milestone_app_6_cart_item.dart';
import '../data/milestone_app_6_food.dart';
import '../data/milestone_app_6_order.dart';

class MilestoneApp6State extends ChangeNotifier {
  // ================================================================
  // SHARED PREFERENCES
  // ================================================================

  static const String _themeKey =
      'milestone_app_6_dark';

  static const String _onboardingKey =
      'milestone_app_6_onboarding_done';

  // ================================================================
  // THEME
  // ================================================================

  ThemeMode _themeMode = ThemeMode.light;

  // ================================================================
  // ONBOARDING
  // ================================================================

  bool _onboardingDone = false;

  // ================================================================
  // CART
  // ================================================================

  final Map<String, MilestoneApp6CartItem> _cart = {};

  // ================================================================
  // FAVORITE PRODUCTS
  // ================================================================

  final Set<String> _saved = {};

  // ================================================================
  // FAVORITE RESTAURANTS
  // ================================================================

  final Set<String> _savedRestaurants = {};

  // ================================================================
  // ORDERS
  // ================================================================

  final List<MilestoneApp6Order> _orders = [];

  // ================================================================
  // PROMO
  // ================================================================

  String? _appliedPromoCode;

  double _promoDiscount = 0.0;

  // ================================================================
  // ADDRESS
  // ================================================================

  MilestoneApp6Address? _selectedAddress;

  // ================================================================
  // GETTERS
  // ================================================================

  ThemeMode get themeMode {
    return _themeMode;
  }

  bool get onboardingDone {
    return _onboardingDone;
  }

  Map<String, MilestoneApp6CartItem> get cart {
    return Map.unmodifiable(_cart);
  }

  Set<String> get saved {
    return Set.unmodifiable(_saved);
  }

  Set<String> get savedRestaurants {
    return Set.unmodifiable(_savedRestaurants);
  }

  List<MilestoneApp6Order> get orders {
    return List.unmodifiable(_orders);
  }

  MilestoneApp6Address? get selectedAddress {
    return _selectedAddress;
  }

  String? get appliedPromoCode {
    return _appliedPromoCode;
  }

  double get promoDiscount {
    return _promoDiscount;
  }

  // ================================================================
  // CART COUNT
  // ================================================================

  int get cartCount {
    return _cart.values.fold(
      0,
          (total, item) {
        return total + item.quantity;
      },
    );
  }

  // ================================================================
  // CART SUBTOTAL
  // ================================================================

  double get cartSubtotal {
    return _cart.values.fold(
      0.0,
          (total, item) {
        return total + item.totalPrice;
      },
    );
  }

  // ================================================================
  // DELIVERY CHARGE
  // ================================================================

  double get deliveryCharge {
    if (_cart.isEmpty) {
      return 0.0;
    }

    return 2.00;
  }

  // ================================================================
  // DISCOUNT
  // ================================================================

  double get discountAmount {
    return _promoDiscount;
  }

  // ================================================================
  // FINAL TOTAL
  // ================================================================

  double get finalTotal {
    final total =
        cartSubtotal +
            deliveryCharge -
            discountAmount;

    return total < 0 ? 0 : total;
  }

  // ================================================================
  // LOAD SETTINGS
  // ================================================================

  Future<void> load() async {
    final prefs =
    await SharedPreferences.getInstance();

    final dark =
        prefs.getBool(_themeKey) ?? false;

    _themeMode = dark
        ? ThemeMode.dark
        : ThemeMode.light;

    _onboardingDone =
        prefs.getBool(_onboardingKey) ?? false;

    notifyListeners();
  }

  // ================================================================
  // FINISH ONBOARDING
  // ================================================================

  Future<void> finishOnboarding() async {
    _onboardingDone = true;

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(
      _onboardingKey,
      true,
    );

    notifyListeners();
  }

  // ================================================================
  // DARK MODE
  // ================================================================

  Future<void> setDarkMode(
      bool value,
      ) async {
    _themeMode = value
        ? ThemeMode.dark
        : ThemeMode.light;

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(
      _themeKey,
      value,
    );

    notifyListeners();
  }

  // ================================================================
  // ADD TO CART
  // ================================================================

  void addToCart(
      MilestoneApp6Food food, {
        String size = 'Small',
        double? unitPrice,
        int quantity = 1,
      }) {
    final price =
        unitPrice ?? food.price;

    final key =
        '${food.id}_$size';

    if (_cart.containsKey(key)) {
      _cart[key]!.quantity += quantity;
    } else {
      _cart[key] =
          MilestoneApp6CartItem(
            food: food,
            size: size,
            unitPrice: price,
            quantity: quantity,
          );
    }

    _recalculatePromo();

    notifyListeners();
  }

  // ================================================================
  // REMOVE ONE
  // ================================================================

  void removeFromCart(
      MilestoneApp6Food food, {
        String size = 'Small',
      }) {
    final key =
        '${food.id}_$size';

    final item = _cart[key];

    if (item == null) {
      return;
    }

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _cart.remove(key);
    }

    _recalculatePromo();

    if (_cart.isEmpty) {
      clearPromo();
    }

    notifyListeners();
  }

  // ================================================================
  // DELETE ITEM
  // ================================================================

  void deleteFromCart(
      MilestoneApp6Food food, {
        String size = 'Small',
      }) {
    final key =
        '${food.id}_$size';

    _cart.remove(key);

    _recalculatePromo();

    if (_cart.isEmpty) {
      clearPromo();
    }

    notifyListeners();
  }

  // ================================================================
  // CLEAR CART
  // ================================================================

  void clearCart() {
    _cart.clear();

    clearPromo();

    notifyListeners();
  }

  // ================================================================
  // APPLY PROMO
  // ================================================================

  bool applyPromoCode(
      String code,
      ) {
    final promo =
    code.trim().toUpperCase();

    if (promo == 'FOOD10') {
      _appliedPromoCode = 'FOOD10';

      _promoDiscount =
          cartSubtotal * 0.10;

      notifyListeners();

      return true;
    }

    _appliedPromoCode = null;

    _promoDiscount = 0.0;

    notifyListeners();

    return false;
  }

  // ================================================================
  // RECALCULATE PROMO
  // ================================================================

  void _recalculatePromo() {
    if (_appliedPromoCode == 'FOOD10') {
      _promoDiscount =
          cartSubtotal * 0.10;
    }
  }

  // ================================================================
  // CLEAR PROMO
  // ================================================================

  void clearPromo() {
    _appliedPromoCode = null;

    _promoDiscount = 0.0;
  }

  // ================================================================
  // FAVORITE PRODUCT
  // ================================================================

  void toggleSaved(
      String id,
      ) {
    if (_saved.contains(id)) {
      _saved.remove(id);
    } else {
      _saved.add(id);
    }

    notifyListeners();
  }

  // ================================================================
  // CHECK FAVORITE PRODUCT
  // ================================================================

  bool isSaved(
      String id,
      ) {
    return _saved.contains(id);
  }

  // ================================================================
  // FAVORITE RESTAURANT
  // ================================================================

  void toggleRestaurantSaved(
      String restaurantName,
      ) {
    if (_savedRestaurants.contains(
      restaurantName,
    )) {
      _savedRestaurants.remove(
        restaurantName,
      );
    } else {
      _savedRestaurants.add(
        restaurantName,
      );
    }

    notifyListeners();
  }

  // ================================================================
  // CHECK FAVORITE RESTAURANT
  // ================================================================

  bool isRestaurantSaved(
      String restaurantName,
      ) {
    return _savedRestaurants.contains(
      restaurantName,
    );
  }

  // ================================================================
  // ADD ORDER
  // ================================================================

  void addOrder({
    required MilestoneApp6Food food,
    required String size,
    required double unitPrice,
    required int quantity,
    required String paymentType,
  }) {
    final order =
    MilestoneApp6Order(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),

      food: food,

      size: size,

      unitPrice: unitPrice,

      quantity: quantity,

      paymentType: paymentType,

      orderDate: DateTime.now(),
    );

    _orders.insert(
      0,
      order,
    );

    notifyListeners();
  }

  // ================================================================
  // ADDRESS
  // ================================================================

  void setAddress(
      MilestoneApp6Address address,
      ) {
    _selectedAddress = address;

    notifyListeners();
  }

  // ================================================================
  // CLEAR ADDRESS
  // ================================================================

  void clearAddress() {
    _selectedAddress = null;

    notifyListeners();
  }
}