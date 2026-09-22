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

  static const String _themeKey = 'milestone_app_6_dark';
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

  final Map<String, MilestoneApp6CartItem> _cart =
  <String, MilestoneApp6CartItem>{};

  // ================================================================
  // FAVORITES
  // ================================================================

  final Set<String> _saved = <String>{};

  final Set<String> _savedRestaurants =
  <String>{};

  // ================================================================
  // ORDERS
  // ================================================================

  final List<MilestoneApp6Order> _orders =
  <MilestoneApp6Order>[];

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

  ThemeMode get themeMode => _themeMode;

  bool get onboardingDone => _onboardingDone;

  Map<String, MilestoneApp6CartItem> get cart =>
      Map.unmodifiable(_cart);

  Set<String> get saved =>
      Set.unmodifiable(_saved);

  Set<String> get savedRestaurants =>
      Set.unmodifiable(_savedRestaurants);

  List<MilestoneApp6Order> get orders =>
      List.unmodifiable(_orders);

  MilestoneApp6Address? get selectedAddress =>
      _selectedAddress;

  String? get appliedPromoCode =>
      _appliedPromoCode;

  double get promoDiscount =>
      _promoDiscount;

  // ================================================================
  // CART COUNT
  // ================================================================

  int get cartCount {
    return _cart.values.fold<int>(
      0,
          (total, item) => total + item.quantity,
    );
  }

  // ================================================================
  // CART SUBTOTAL
  // ================================================================

  double get cartSubtotal {
    return _cart.values.fold<double>(
      0.0,
          (total, item) => total + item.totalPrice,
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

  double get discountAmount =>
      _promoDiscount;

  // ================================================================
  // FINAL TOTAL
  // ================================================================

  double get finalTotal {
    final total =
        cartSubtotal +
            deliveryCharge -
            discountAmount;

    return total < 0 ? 0.0 : total;
  }

  // ================================================================
  // LOAD
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
  // ONBOARDING
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
  // CART KEY
  // ================================================================

  String _cartKey(
      MilestoneApp6Food food,
      String size,
      ) {
    return '${food.id}_$size';
  }

  // ================================================================
  // ADD TO CART
  // ================================================================

  void addToCart(
      MilestoneApp6Food food, {
        String size = 'Small',
        required double unitPrice,
        int quantity = 1,
      }) {
    if (quantity <= 0) {
      return;
    }

    final key = _cartKey(
      food,
      size,
    );

    final existing =
    _cart[key];

    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _cart[key] =
          MilestoneApp6CartItem(
            food: food,
            quantity: quantity,
            size: size,
            unitPrice: unitPrice,
          );
    }

    _recalculatePromo();

    notifyListeners();
  }

  // ================================================================
  // ADD FOOD WITH RESTAURANT CHECK
  // ================================================================

  Future<bool> addFoodToCart({
    required BuildContext context,
    required MilestoneApp6Food food,
    String size = 'Small',
    double? unitPrice,
    int quantity = 1,
  }) async {
    if (quantity <= 0) {
      return false;
    }

    final price =
        unitPrice ?? food.price;

    // Empty cart.
    if (_cart.isEmpty) {
      addToCart(
        food,
        size: size,
        unitPrice: price,
        quantity: quantity,
      );

      return true;
    }

    final firstItem =
        _cart.values.first;

    final currentRestaurant =
    firstItem.food.restaurant.trim();

    final newRestaurant =
    food.restaurant.trim();

    // Same restaurant.
    if (currentRestaurant
        .toLowerCase() ==
        newRestaurant.toLowerCase()) {
      addToCart(
        food,
        size: size,
        unitPrice: price,
        quantity: quantity,
      );

      return true;
    }

    // Different restaurant.
    final shouldReplace =
    await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final theme =
        Theme.of(dialogContext);

        return AlertDialog(
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration:
                BoxDecoration(
                  color: theme
                      .colorScheme
                      .primary
                      .withOpacity(.10),
                  shape:
                  BoxShape.circle,
                ),
                child: Icon(
                  Icons
                      .shopping_cart_rounded,
                  color: theme
                      .colorScheme
                      .primary,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Replace Cart?',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: RichText(
            text: TextSpan(
              style: TextStyle(
                color: theme
                    .colorScheme
                    .onSurface,
                fontSize: 14,
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text:
                  'Your cart contains items from ',
                ),
                TextSpan(
                  text:
                  currentRestaurant,
                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text:
                  '.\n\nDo you want to replace them with items from ',
                ),
                TextSpan(
                  text: newRestaurant,
                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text: '?',
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                'Keep Existing',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              child: const Text(
                'Replace Cart',
              ),
            ),
          ],
        );
      },
    );

    if (shouldReplace != true) {
      return false;
    }

    _cart.clear();
    clearPromo();

    addToCart(
      food,
      size: size,
      unitPrice: price,
      quantity: quantity,
    );

    return true;
  }

  // ================================================================
  // REMOVE ONE
  // ================================================================

  void removeFromCart(
      MilestoneApp6Food food, {
        String size = 'Small',
      }) {
    final key =
    _cartKey(food, size);

    final item =
    _cart[key];

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
    _cartKey(food, size);

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
  // PROMO
  // ================================================================

  bool applyPromoCode(
      String code,
      ) {
    final promo =
    code.trim().toUpperCase();

    if (promo == 'FOOD10') {
      _appliedPromoCode = 'FOOD10';

      _promoDiscount =
          cartSubtotal * .10;

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
    if (_appliedPromoCode ==
        'FOOD10') {
      _promoDiscount =
          cartSubtotal * .10;
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
    if (_savedRestaurants
        .contains(restaurantName)) {
      _savedRestaurants
          .remove(restaurantName);
    } else {
      _savedRestaurants
          .add(restaurantName);
    }

    notifyListeners();
  }

  bool isRestaurantSaved(
      String restaurantName,
      ) {
    return _savedRestaurants
        .contains(restaurantName);
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
    if (quantity <= 0) {
      return;
    }

    final order =
    MilestoneApp6Order(
      id: DateTime.now()
          .microsecondsSinceEpoch
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

  void clearAddress() {
    _selectedAddress = null;

    notifyListeners();
  }
}