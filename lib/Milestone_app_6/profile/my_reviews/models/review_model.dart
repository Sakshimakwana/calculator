class ReviewModel {
  final int id;
  final int rating;
  final String comment;
  final ReviewOrderModel order;
  final ReviewUserModel user;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.order,
    required this.user,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: _toInt(json['id']),
      rating: _toInt(json['rating']),
      comment: json['comment']?.toString() ?? '',
      order: ReviewOrderModel.fromJson(
        json['order'] is Map
            ? Map<String, dynamic>.from(json['order'])
            : {},
      ),
      user: ReviewUserModel.fromJson(
        json['user'] is Map
            ? Map<String, dynamic>.from(json['user'])
            : {},
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class ReviewOrderModel {
  final int id;
  final int userId;
  final int addressId;
  final int restaurantId;
  final String status;
  final String total;
  final String deliveryFee;
  final String? deliveryInstructions;
  final DateTime? createdAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;

  ReviewOrderModel({
    required this.id,
    required this.userId,
    required this.addressId,
    required this.restaurantId,
    required this.status,
    required this.total,
    required this.deliveryFee,
    required this.deliveryInstructions,
    required this.createdAt,
    required this.deliveredAt,
    required this.cancelledAt,
  });

  factory ReviewOrderModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ReviewOrderModel(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      addressId: _toInt(json['address_id']),
      restaurantId: _toInt(json['restaurant_id']),
      status: json['status']?.toString() ?? '',
      total: json['total']?.toString() ?? '0.00',
      deliveryFee:
      json['delivery_fee']?.toString() ?? '0.00',
      deliveryInstructions:
      json['delivery_instructions']?.toString(),
      createdAt: _parseDate(json['created_at']),
      deliveredAt: _parseDate(json['delivered_at']),
      cancelledAt: _parseDate(json['cancelled_at']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(
      value.toString().replaceFirst(' ', 'T'),
    );
  }
}

class ReviewUserModel {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String type;

  ReviewUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.type,
  });

  factory ReviewUserModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ReviewUserModel(
      id: _toInt(json['id']),
      fullName:
      json['full_name']?.toString() ?? '',
      email:
      json['email']?.toString() ?? '',
      phoneNumber:
      json['phone_number']?.toString() ?? '',
      type:
      json['type']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}