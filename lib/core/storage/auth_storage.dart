import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  AuthStorage._();

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _fullNameKey = 'full_name';
  static const String _emailKey = 'user_email';
  static const String _phoneKey = 'user_phone';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveLoginData({
    required String token,
    required int userId,
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    await _prefs.setString(
      _tokenKey,
      token,
    );

    await _prefs.setInt(
      _userIdKey,
      userId,
    );

    await _prefs.setString(
      _fullNameKey,
      fullName,
    );

    await _prefs.setString(
      _emailKey,
      email,
    );

    await _prefs.setString(
      _phoneKey,
      phoneNumber,
    );
  }

  static String? get token {
    return _prefs.getString(_tokenKey);
  }

  static bool get isLoggedIn {
    final savedToken = _prefs.getString(_tokenKey);

    return savedToken != null && savedToken.isNotEmpty;
  }

  static int get userId {
    return _prefs.getInt(_userIdKey) ?? 0;
  }

  static String get fullName {
    return _prefs.getString(_fullNameKey) ?? '';
  }

  static String get email {
    return _prefs.getString(_emailKey) ?? '';
  }

  static String get phoneNumber {
    return _prefs.getString(_phoneKey) ?? '';
  }

  static Future<void> clearAuth() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_fullNameKey);
    await _prefs.remove(_emailKey);
    await _prefs.remove(_phoneKey);
  }
}