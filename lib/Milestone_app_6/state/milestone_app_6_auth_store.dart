import 'package:flutter/foundation.dart';

class MilestoneApp6AuthStore extends ChangeNotifier {
  // ============================================================
  // SINGLETON
  // ============================================================

  MilestoneApp6AuthStore._();

  static final MilestoneApp6AuthStore instance =
  MilestoneApp6AuthStore._();

  // ============================================================
  // USER DATA
  // ============================================================

  String? _fullName;
  String? _email;
  String? _phone;
  String? _password;

  bool _isLoggedIn = false;

  // ============================================================
  // GETTERS
  // ============================================================

  bool get isLoggedIn => _isLoggedIn;

  String? get fullName => _fullName;

  String? get email => _email;

  String? get phone => _phone;

  // ------------------------------------------------------------
  // USER NAME
  //
  // This returns the same value as fullName.
  // It is useful for screens such as Order Details,
  // Profile, Checkout, etc.
  // ------------------------------------------------------------

  String get userName => _fullName ?? '';

  // ============================================================
  // CREATE ACCOUNT
  // UI / LOCAL ONLY
  // ============================================================

  void createAccount({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) {
    _fullName = fullName.trim();

    _email = email.trim().toLowerCase();

    _phone = phone.trim();

    _password = password;

    // ----------------------------------------------------------
    // After creating the account, user still needs to login.
    // ----------------------------------------------------------

    _isLoggedIn = false;

    notifyListeners();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  bool login({
    required String email,
    required String password,
  }) {
    final enteredEmail =
    email.trim().toLowerCase();

    // ----------------------------------------------------------
    // No account created
    // ----------------------------------------------------------

    if (_email == null ||
        _password == null) {
      return false;
    }

    // ----------------------------------------------------------
    // Check email and password
    // ----------------------------------------------------------

    if (enteredEmail != _email ||
        password != _password) {
      return false;
    }

    // ----------------------------------------------------------
    // Login successful
    // ----------------------------------------------------------

    _isLoggedIn = true;

    notifyListeners();

    return true;
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void logout() {
    _isLoggedIn = false;

    notifyListeners();
  }

  // ============================================================
  // CLEAR ACCOUNT
  // ============================================================

  void clearAccount() {
    _fullName = null;

    _email = null;

    _phone = null;

    _password = null;

    _isLoggedIn = false;

    notifyListeners();
  }
}