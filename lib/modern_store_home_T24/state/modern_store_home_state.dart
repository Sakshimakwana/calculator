import 'package:flutter/foundation.dart';

class ModernStoreHomeState {
  static final ValueNotifier<Set<int>> wishlist =
  ValueNotifier<Set<int>>({});

  static final ValueNotifier<Set<int>> cart =
  ValueNotifier<Set<int>>({});

  static void toggleWishlist(int productId) {
    final updated = {...wishlist.value};

    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }

    wishlist.value = updated;
  }

  static bool isWishlisted(int productId) {
    return wishlist.value.contains(productId);
  }

  static void toggleCart(int productId) {
    final updated = {...cart.value};

    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }

    cart.value = updated;
  }

  static bool isInCart(int productId) {
    return cart.value.contains(productId);
  }
}