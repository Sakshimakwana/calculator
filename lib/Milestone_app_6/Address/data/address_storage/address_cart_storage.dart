
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddressCartStorage {
  AddressCartStorage._();

  static String _key(int addressId) => 'cart_by_address_$addressId';

  static Future<void> saveCart({
    required int addressId,
    required List<Map<String, int>> items,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _key(addressId),
      jsonEncode(items),
    );
  }

  static Future<List<Map<String, int>>> getCart(
      int addressId,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(addressId));

    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw) as List;

      return decoded.map((entry) {
        final item = Map<String, dynamic>.from(entry as Map);

        return <String, int>{
          'menu_item_id': (item['menu_item_id'] as num).toInt(),
          'restaurant_id': (item['restaurant_id'] as num).toInt(),
          'quantity': (item['quantity'] as num).toInt(),
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> clearCartForAddress(int addressId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(addressId));
  }

  static Future<void> clearAllCarts() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (final key in keys) {
      if (key.startsWith('cart_by_address_')) {
        await prefs.remove(key);
      }
    }
  }
}
