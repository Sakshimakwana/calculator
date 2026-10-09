import 'package:app_matic_tech_flutter_app/Milestone_app_6/order%20details_and_checkout/order_details/models/delivery/delivery_response_model.dart';

abstract class DeliveryRepository {
  Future<DeliveryResponseModel>
  fetchDeliveries();

  Future<DeliveryResponseModel>
  fetchDeliveryForOrder(
      int orderId,
      );
}