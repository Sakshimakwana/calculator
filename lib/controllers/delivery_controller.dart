import 'package:flutter/foundation.dart';


import '../models/delivery/delivery_model.dart';
import '../repositories/delivery_repository.dart';

class DeliveryController
    extends ChangeNotifier {
  final DeliveryRepository repository;

  DeliveryController({
    required this.repository,
  });

  // ============================================================
  // STATE
  // ============================================================

  bool isLoading = false;

  bool isRefreshing = false;

  String? errorMessage;

  List<DeliveryModel> deliveries = [];

  DeliveryModel? currentDelivery;

  // ============================================================
  // FETCH ALL DELIVERIES
  // ============================================================

  Future<void> fetchDeliveries() async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      final response =
      await repository.fetchDeliveries();

      deliveries =
          response.data;

      errorMessage = null;
    } catch (e) {
      errorMessage = e
          .toString()
          .replaceFirst(
        'Exception: ',
        '',
      );
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  // ============================================================
  // REFRESH DELIVERIES
  // ============================================================

  Future<void> refreshDeliveries() async {
    isRefreshing = true;
    errorMessage = null;

    notifyListeners();

    try {
      final response =
      await repository.fetchDeliveries();

      deliveries =
          response.data;

      errorMessage = null;
    } catch (e) {
      errorMessage = e
          .toString()
          .replaceFirst(
        'Exception: ',
        '',
      );
    } finally {
      isRefreshing = false;

      notifyListeners();
    }
  }

  // ============================================================
  // FETCH DELIVERY FOR ORDER
  // ============================================================

  Future<DeliveryModel?>
  fetchDeliveryForOrder(
      int orderId,
      ) async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      final response =
      await repository
          .fetchDeliveryForOrder(
        orderId,
      );

      if (response.data.isEmpty) {
        currentDelivery = null;
        return null;
      }

      currentDelivery =
          response.data.first;

      return currentDelivery;
    } catch (e) {
      errorMessage = e
          .toString()
          .replaceFirst(
        'Exception: ',
        '',
      );

      return null;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  // ============================================================
  // FIND FROM ALREADY LOADED DATA
  // ============================================================

  DeliveryModel? findDeliveryForOrder(
      int orderId,
      ) {
    for (final delivery
    in deliveries) {
      if (delivery.orderId ==
          orderId ||
          delivery.order?.id ==
              orderId) {
        return delivery;
      }
    }

    return null;
  }

  // ============================================================
  // STATUS
  // ============================================================

  String get currentDeliveryStatus {
    return currentDelivery
        ?.status
        .trim()
        .toLowerCase() ??
        '';
  }

  String get currentOrderStatus {
    return currentDelivery
        ?.order
        ?.status
        .trim()
        .toLowerCase() ??
        '';
  }

  // ============================================================
  // CLEAR
  // ============================================================

  void clear() {
    deliveries = [];
    currentDelivery = null;
    errorMessage = null;

    notifyListeners();
  }
}