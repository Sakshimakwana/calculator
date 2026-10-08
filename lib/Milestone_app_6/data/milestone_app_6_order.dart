import '../cart/data/milestone_app_6_cart_item.dart';
import '../Home/data/milestone_app_6_food.dart';

enum MilestoneApp6OrderStatus {
  placed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

class MilestoneApp6Order {
  final String id;
  final List<MilestoneApp6CartItem> items;
  final String restaurantName;
  final String restaurantImage;
  final String restaurantAddress;
  final String paymentType;
  final DateTime orderDate;
  final double subtotal;
  final double shipping;
  final double discount;
  final double totalPayment;
  final double minimumPayment;
  final double amountPaidNow;
  MilestoneApp6OrderStatus status;

  MilestoneApp6Order({
    required this.id,
    required List<MilestoneApp6CartItem> items,
    required this.restaurantName,
    required this.restaurantImage,
    required this.restaurantAddress,
    required this.paymentType,
    required this.orderDate,
    this.subtotal = 0.0,
    this.shipping = 0.0,
    this.discount = 0.0,
    double? totalPayment,
    this.minimumPayment = 0.0,
    double? amountPaidNow,
    this.status = MilestoneApp6OrderStatus.placed,
  })  : items = List.unmodifiable(
    items.map(
          (item) => MilestoneApp6CartItem(
        food: item.food,
        quantity: item.quantity,
        size: item.size,
        unitPrice: item.unitPrice,
      ),
    ),
  ),
        totalPayment = totalPayment ??
            items.fold<double>(
              0.0,
                  (sum, item) => sum + item.totalPrice,
            ),
        amountPaidNow = amountPaidNow ??
            (totalPayment ??
                items.fold<double>(
                  0.0,
                      (sum, item) => sum + item.totalPrice,
                ));

  MilestoneApp6Food get food {
    if (items.isEmpty) {
      throw StateError('Order contains no items.');
    }
    return items.first.food;
  }

  String get size => items.isEmpty ? 'Small' : items.first.size;

  double get unitPrice => items.isEmpty ? 0.0 : items.first.unitPrice;

  int get quantity =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);

  int get itemCount => quantity;

  /// Kept for compatibility with older order-card code.
  double get totalPrice => totalPayment;

  String get statusText {
    switch (status) {
      case MilestoneApp6OrderStatus.placed:
        return 'Placed';
      case MilestoneApp6OrderStatus.preparing:
        return 'Preparing';
      case MilestoneApp6OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case MilestoneApp6OrderStatus.delivered:
        return 'Delivered';
      case MilestoneApp6OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isPlaced => status == MilestoneApp6OrderStatus.placed;

  bool get isPreparing => status == MilestoneApp6OrderStatus.preparing;

  bool get isOutForDelivery =>
      status == MilestoneApp6OrderStatus.outForDelivery;

  bool get isDelivered => status == MilestoneApp6OrderStatus.delivered;

  bool get isCancelled => status == MilestoneApp6OrderStatus.cancelled;

  bool get canCancel =>
      status == MilestoneApp6OrderStatus.placed ||
          status == MilestoneApp6OrderStatus.preparing;
}
