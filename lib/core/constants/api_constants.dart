class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://tomato-backend-hpby.onrender.com/api';

  static const String register = '/register';

  static const String login = '/login';

  static const String logout = '/logout';

  static const String addresses = '/addresses';

  static const String storeAddress = '/addresses/store';

  static String updateAddress(int id) =>
      '/addresses/$id/update';

  static String deleteAddress(int id) =>
      '/addresses/$id/destroy';

  static const String nearbyRestaurants =
      '/restaurants/nearby';

  static String restaurantMenus(int restaurantId) {
    return '/restaurants/$restaurantId/menus';
  }

  static const String fetchCart = '/cart';

  static const String storeCart = '/carts/store';

  static String updateCart(int cartId) =>
      '/carts/$cartId/update';

  static String deleteCart(int cartId) =>
      '/carts/$cartId/destroy';

  static const String clearCart = '/cart';

  // ============================================================
  // ORDERS
  // ============================================================

  static const String placeOrder =
      '/orders/store';

  static const String storeOrder =
      '/orders/store';

  static String orderInfo(int orderId) =>
      '/orders/$orderId';

  static String generateInvoice(int orderId) =>
      '/orders/$orderId/invoice';

  static String cancelOrder(int orderId) =>
      '/orders/$orderId/cancel';

  static const String myOrders = '/orders';

  static String makePayment(int orderId) {
    return '/orders/$orderId/payment';
  }
  static String verifyPayment(int orderId) {
    return '/orders/$orderId/payment/verify';
  }
}