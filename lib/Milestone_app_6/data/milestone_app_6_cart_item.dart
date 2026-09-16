import 'milestone_app_6_food.dart';

class MilestoneApp6CartItem {
  final MilestoneApp6Food food;
  final String size;
  final double unitPrice;
  int quantity;

  MilestoneApp6CartItem({
    required this.food,
    required this.size,
    required this.unitPrice,
    this.quantity = 1,
  });

  String get key => '${food.id}_$size';

  double get totalPrice => unitPrice * quantity;
}