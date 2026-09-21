import 'package:flutter/foundation.dart';

class MilestoneApp6AuthStore extends ChangeNotifier {
  MilestoneApp6AuthStore._();

  static final MilestoneApp6AuthStore instance =
  MilestoneApp6AuthStore._();

  String? _fullName;
  String? _email;
  String? _phone;
  String? _password;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  String? get fullName => _fullName;

  String? get email => _email;

  String? get phone => _phone;

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
    final enteredEmail = email.trim().toLowerCase();

    if (_email == null || _password == null) {
      return false;
    }

    if (enteredEmail != _email || password != _password) {
      return false;
    }

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