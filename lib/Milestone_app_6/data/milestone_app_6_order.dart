import 'milestone_app_6_food.dart';

class MilestoneApp6Order {
  final String id;
  final MilestoneApp6Food food;
  final String size;
  final double unitPrice;
  final int quantity;
  final String paymentType;
  final DateTime orderDate;

  const MilestoneApp6Order({
    required this.id,
    required this.food,
    required this.size,
    required this.unitPrice,
    required this.quantity,
    required this.paymentType,
    required this.orderDate,
  });

  double get totalPrice {
    return unitPrice * quantity;
  }
}