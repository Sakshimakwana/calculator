import 'package:shared_preferences/shared_preferences.dart';

class AddressStorage {
  AddressStorage._();

  static const String _selectedAddressIdKey =
      'selected_address_id';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs =
    await SharedPreferences
        .getInstance();
  }

  static Future<void>
  saveSelectedAddressId(
      int addressId,
      ) async {
    await _prefs.setInt(
      _selectedAddressIdKey,
      addressId,
    );
  }

  static int? get selectedAddressId {
    return _prefs.getInt(
      _selectedAddressIdKey,
    );
  }

  static bool get hasSelectedAddress {
    final id =
        selectedAddressId;

    return id != null &&
        id > 0;
  }

  static Future<void>
  clearAddress() async {
    await _prefs.remove(
      _selectedAddressIdKey,
    );
  }
}