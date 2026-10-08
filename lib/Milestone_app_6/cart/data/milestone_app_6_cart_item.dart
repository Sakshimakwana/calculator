import '../../Home/data/milestone_app_6_food.dart';

class MilestoneApp6CartItem {
  final MilestoneApp6Food food;
  int quantity;
  final String size;
  final double unitPrice;

  MilestoneApp6CartItem({
    required this.food,
    required this.quantity,
    required this.size,
    required this.unitPrice,
  });

  double get totalPrice => unitPrice * quantity;

  MilestoneApp6CartItem copyWith({
    MilestoneApp6Food? food,
    int? quantity,
    String? size,
    double? unitPrice,
  }) {
    return MilestoneApp6CartItem(
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}