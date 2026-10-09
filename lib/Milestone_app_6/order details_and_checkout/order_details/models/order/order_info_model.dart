class OrderInfoResponseModel {
  final bool success;
  final String message;
  final OrderInfoModel data;

  OrderInfoResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderInfoResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderInfoResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: OrderInfoModel.fromJson(
        Map<String, dynamic>.from(
          json['data'] ?? {},
        ),
      ),
    );
  }
}

class OrderInfoModel {
  final int id;
  final int userId;
  final int addressId;
  final int restaurantId;
  final String status;
  final double total;
  final double deliveryFee;
  final String? deliveryInstructions;
  final String? createdAt;
  final String? deliveredAt;
  final String? cancelledAt;

  final OrderCustomerModel customer;
  final OrderRestaurantModel restaurant;
  final OrderDeliveryAddressModel deliveryAddress;
  final List<OrderItemModel> orderItems;

  final OrderPaymentModel? orderPayment;
  final OrderInvoiceModel? invoice;
  final OrderReviewModel? orderReview;
  final OrderDeliveryModel? orderDelivery;

  OrderInfoModel({
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
    required this.customer,
    required this.restaurant,
    required this.deliveryAddress,
    required this.orderItems,
    required this.orderPayment,
    required this.invoice,
    required this.orderReview,
    required this.orderDelivery,
  });

  factory OrderInfoModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderInfoModel(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      addressId: _toInt(json['address_id']),
      restaurantId: _toInt(json['restaurant_id']),
      status: json['status']?.toString() ?? '',
      total: _toDouble(json['total']),
      deliveryFee: _toDouble(json['delivery_fee']),
      deliveryInstructions:
      json['delivery_instructions']?.toString(),
      createdAt: json['created_at']?.toString(),
      deliveredAt: json['delivered_at']?.toString(),
      cancelledAt: json['cancelled_at']?.toString(),

      customer: OrderCustomerModel.fromJson(
        Map<String, dynamic>.from(
          json['customer'] ?? {},
        ),
      ),

      restaurant: OrderRestaurantModel.fromJson(
        Map<String, dynamic>.from(
          json['restaurant'] ?? {},
        ),
      ),

      deliveryAddress:
      OrderDeliveryAddressModel.fromJson(
        Map<String, dynamic>.from(
          json['delivery_address'] ?? {},
        ),
      ),

      orderItems:
      (json['order_items'] as List? ?? [])
          .map(
            (item) => OrderItemModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList(),

      orderPayment:
      json['order_payment'] == null
          ? null
          : OrderPaymentModel.fromJson(
        Map<String, dynamic>.from(
          json['order_payment'],
        ),
      ),

      invoice:
      json['invoice'] == null
          ? null
          : OrderInvoiceModel.fromJson(
        Map<String, dynamic>.from(
          json['invoice'],
        ),
      ),

      orderReview:
      json['order_review'] == null
          ? null
          : OrderReviewModel.fromJson(
        Map<String, dynamic>.from(
          json['order_review'],
        ),
      ),

      orderDelivery:
      json['order_delivery'] == null
          ? null
          : OrderDeliveryModel.fromJson(
        Map<String, dynamic>.from(
          json['order_delivery'],
        ),
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }
}
class OrderPaymentModel {
  final int id;
  final int orderId;
  final String method;
  final String status;
  final String? razorpayOrderId;
  final double amount;
  final String currency;

  OrderPaymentModel({
    required this.id,
    required this.orderId,
    required this.method,
    required this.status,
    required this.razorpayOrderId,
    required this.amount,
    required this.currency,
  });

  factory OrderPaymentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderPaymentModel(
      id: int.tryParse(
        json['id']?.toString() ?? '',
      ) ??
          0,
      orderId: int.tryParse(
        json['order_id']?.toString() ?? '',
      ) ??
          0,
      method:
      json['method']?.toString() ?? '',
      status:
      json['status']?.toString() ?? '',
      razorpayOrderId:
      json['razorpay_order_id']?.toString(),
      amount:
      double.tryParse(
        json['amount']?.toString() ?? '',
      ) ??
          0.0,
      currency:
      json['currency']?.toString() ?? 'INR',
    );
  }
}
class OrderCustomerModel {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String type;

  OrderCustomerModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.type,
  });

  factory OrderCustomerModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderCustomerModel(
      id: int.tryParse(
        json['id']?.toString() ?? '',
      ) ??
          0,
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
}
class OrderRestaurantModel {
  final int id;
  final String name;
  final String imageUrl;
  final String address;
  final String status;
  final String latitude;
  final String longitude;
  final dynamic distance;

  OrderRestaurantModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  factory OrderRestaurantModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderRestaurantModel(
      id: int.tryParse(
        json['id']?.toString() ?? '',
      ) ??
          0,
      name:
      json['name']?.toString() ?? '',
      imageUrl:
      json['image_url']?.toString() ?? '',
      address:
      json['address']?.toString() ?? '',
      status:
      json['status']?.toString() ?? '',
      latitude:
      json['latitude']?.toString() ?? '',
      longitude:
      json['longitude']?.toString() ?? '',
      distance: json['distance'],
    );
  }
}
class OrderDeliveryAddressModel {
  final int id;
  final String label;
  final String addressLine;
  final String city;
  final String state;
  final String pincode;
  final String latitude;
  final String longitude;
  final bool isDefault;

  OrderDeliveryAddressModel({
    required this.id,
    required this.label,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  factory OrderDeliveryAddressModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderDeliveryAddressModel(
      id: int.tryParse(
        json['id']?.toString() ?? '',
      ) ??
          0,
      label:
      json['label']?.toString() ?? '',
      addressLine:
      json['address_line']?.toString() ?? '',
      city:
      json['city']?.toString() ?? '',
      state:
      json['state']?.toString() ?? '',
      pincode:
      json['pincode']?.toString() ?? '',
      latitude:
      json['latitude']?.toString() ?? '',
      longitude:
      json['longitude']?.toString() ?? '',
      isDefault:
      json['is_default'] == true,
    );
  }

  String get fullAddress {
    final parts = [
      addressLine,
      city,
      state,
      pincode,
    ].where(
          (value) => value.trim().isNotEmpty,
    );

    return parts.join(', ');
  }
}
class OrderItemModel {
  final int id;
  final int orderId;
  final int menuItemId;
  final int quantity;
  final double priceAtPurchase;
  final OrderMenuItemModel menuItem;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.menuItemId,
    required this.quantity,
    required this.priceAtPurchase,
    required this.menuItem,
  });

  factory OrderItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderItemModel(
      id: int.tryParse(
        json['id']?.toString() ?? '',
      ) ??
          0,
      orderId: int.tryParse(
        json['order_id']?.toString() ?? '',
      ) ??
          0,
      menuItemId: int.tryParse(
        json['menu_item_id']?.toString() ?? '',
      ) ??
          0,
      quantity: int.tryParse(
        json['quantity']?.toString() ?? '',
      ) ??
          0,
      priceAtPurchase:
      double.tryParse(
        json['price_at_purchase']
            ?.toString() ??
            '',
      ) ??
          0.0,
      menuItem: OrderMenuItemModel.fromJson(
        Map<String, dynamic>.from(
          json['menu_item'] ?? {},
        ),
      ),
    );
  }

  double get totalPrice {
    return priceAtPurchase * quantity;
  }
}
class OrderMenuItemModel {
  final int id;
  final int menuId;
  final String name;
  final double price;
  final bool availability;
  final String imageUrl;

  OrderMenuItemModel({
    required this.id,
    required this.menuId,
    required this.name,
    required this.price,
    required this.availability,
    required this.imageUrl,
  });

  factory OrderMenuItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderMenuItemModel(
      id: int.tryParse(
        json['id']?.toString() ?? '',
      ) ??
          0,
      menuId: int.tryParse(
        json['menu_id']?.toString() ?? '',
      ) ??
          0,
      name:
      json['name']?.toString() ?? '',
      price:
      double.tryParse(
        json['price']?.toString() ?? '',
      ) ??
          0.0,
      availability:
      json['availability'] == true,
      imageUrl:
      json['image_url']?.toString() ?? '',
    );
  }
}
class OrderInvoiceModel {
  final int id;
  final int orderId;
  final String invoiceNumber;
  final double deliveryFee;
  final double total;
  final String? generatedAt;

  OrderInvoiceModel({
    required this.id,
    required this.orderId,
    required this.invoiceNumber,
    required this.deliveryFee,
    required this.total,
    required this.generatedAt,
  });

  factory OrderInvoiceModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderInvoiceModel(
      id: int.tryParse(
        json['id']?.toString() ?? '',
      ) ??
          0,
      orderId: int.tryParse(
        json['order_id']?.toString() ?? '',
      ) ??
          0,
      invoiceNumber:
      json['invoice_number']?.toString() ?? '',
      deliveryFee:
      double.tryParse(
        json['delivery_fee']?.toString() ?? '',
      ) ??
          0.0,
      total:
      double.tryParse(
        json['total']?.toString() ?? '',
      ) ??
          0.0,
      generatedAt:
      json['generated_at']?.toString(),
    );
  }
}

class OrderReviewModel {
  final int id;

  OrderReviewModel({
    required this.id,
  });

  factory OrderReviewModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderReviewModel(
      id: int.tryParse(
        json['id']?.toString() ?? '',
      ) ??
          0,
    );
  }
}

class OrderDeliveryModel {
  final int id;

  OrderDeliveryModel({
    required this.id,
  });

  factory OrderDeliveryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderDeliveryModel(
      id: int.tryParse(
        json['id']?.toString() ?? '',
      ) ??
          0,
    );
  }
}