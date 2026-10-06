import '../models/delivery/delivery_response_model.dart';

abstract class DeliveryRepository {
  Future<DeliveryResponseModel>
  fetchDeliveries();

  Future<DeliveryResponseModel>
  fetchDeliveryForOrder(
      int orderId,
      );
}