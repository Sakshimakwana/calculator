import 'package:flutter/foundation.dart';
import '../auth_storage/auth_storage.dart';

class MilestoneApp6AuthStore extends ChangeNotifier {
  MilestoneApp6AuthStore._();

  static final MilestoneApp6AuthStore instance =
  MilestoneApp6AuthStore._();

  bool get isLoggedIn => AuthStorage.isLoggedIn;

  String get userName => AuthStorage.fullName;

  String get userEmail => AuthStorage.email;

  String get userPhone => AuthStorage.phoneNumber;

  int get userId => AuthStorage.userId;

  void refresh() {
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthStorage.clearAuth();
    notifyListeners();
  }
}