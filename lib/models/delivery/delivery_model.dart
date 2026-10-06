class DeliveryModel {
  final int? id;
  final int? orderId;
  final int? deliveryAgentId;
  final String status;
  final DeliveryOrderModel? order;

  const DeliveryModel({
    this.id,
    this.orderId,
    this.deliveryAgentId,
    this.status = '',
    this.order,
  });

  factory DeliveryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeliveryModel(
      id: _parseInt(json['id']),
      orderId: _parseInt(json['order_id']),
      deliveryAgentId:
      _parseInt(json['delivery_agent_id']),
      status:
      json['status']?.toString().trim() ?? '',
      order: json['order'] is Map
          ? DeliveryOrderModel.fromJson(
        Map<String, dynamic>.from(
          json['order'],
        ),
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'delivery_agent_id': deliveryAgentId,
      'status': status,
      'order': order?.toJson(),
    };
  }

  static int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    );
  }
}

// ============================================================
// DELIVERY ORDER
// ============================================================

class DeliveryOrderModel {
  final int? id;
  final int? userId;
  final int? addressId;
  final int? restaurantId;
  final String status;
  final String total;
  final String deliveryFee;
  final String? deliveryInstructions;
  final String? createdAt;
  final String? deliveredAt;
  final String? cancelledAt;

  final DeliveryCustomerModel? customer;
  final DeliveryAddressModel? deliveryAddress;
  final DeliveryPaymentModel? orderPayment;

  const DeliveryOrderModel({
    this.id,
    this.userId,
    this.addressId,
    this.restaurantId,
    this.status = '',
    this.total = '',
    this.deliveryFee = '',
    this.deliveryInstructions,
    this.createdAt,
    this.deliveredAt,
    this.cancelledAt,
    this.customer,
    this.deliveryAddress,
    this.orderPayment,
  });

  factory DeliveryOrderModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeliveryOrderModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      addressId: _parseInt(json['address_id']),
      restaurantId:
      _parseInt(json['restaurant_id']),
      status:
      json['status']?.toString().trim() ?? '',
      total:
      json['total']?.toString() ?? '',
      deliveryFee:
      json['delivery_fee']?.toString() ?? '',
      deliveryInstructions:
      json['delivery_instructions']
          ?.toString(),
      createdAt:
      json['created_at']?.toString(),
      deliveredAt:
      json['delivered_at']?.toString(),
      cancelledAt:
      json['cancelled_at']?.toString(),

      customer: json['customer'] is Map
          ? DeliveryCustomerModel.fromJson(
        Map<String, dynamic>.from(
          json['customer'],
        ),
      )
          : null,

      deliveryAddress:
      json['delivery_address'] is Map
          ? DeliveryAddressModel.fromJson(
        Map<String, dynamic>.from(
          json['delivery_address'],
        ),
      )
          : null,

      orderPayment:
      json['order_payment'] is Map
          ? DeliveryPaymentModel.fromJson(
        Map<String, dynamic>.from(
          json['order_payment'],
        ),
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'address_id': addressId,
      'restaurant_id': restaurantId,
      'status': status,
      'total': total,
      'delivery_fee': deliveryFee,
      'delivery_instructions':
      deliveryInstructions,
      'created_at': createdAt,
      'delivered_at': deliveredAt,
      'cancelled_at': cancelledAt,
      'customer': customer?.toJson(),
      'delivery_address':
      deliveryAddress?.toJson(),
      'order_payment':
      orderPayment?.toJson(),
    };
  }

  static int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    );
  }
}

// ============================================================
// CUSTOMER
// ============================================================

class DeliveryCustomerModel {
  final int? id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String type;

  const DeliveryCustomerModel({
    this.id,
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.type = '',
  });

  factory DeliveryCustomerModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeliveryCustomerModel(
      id: _parseInt(json['id']),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'type': type,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    );
  }
}

// ============================================================
// ADDRESS
// ============================================================

class DeliveryAddressModel {
  final int? id;
  final String label;
  final String addressLine;
  final String city;
  final String state;
  final String pincode;
  final String latitude;
  final String longitude;
  final bool isDefault;

  const DeliveryAddressModel({
    this.id,
    this.label = '',
    this.addressLine = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.latitude = '',
    this.longitude = '',
    this.isDefault = false,
  });

  factory DeliveryAddressModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeliveryAddressModel(
      id: _parseInt(json['id']),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'address_line': addressLine,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    );
  }
}

// ============================================================
// PAYMENT
// ============================================================

class DeliveryPaymentModel {
  final int? id;
  final int? orderId;
  final String method;
  final String status;
  final String? razorpayOrderId;
  final dynamic amount;
  final String currency;
  final String? paidAt;
  final String? refundedAt;

  const DeliveryPaymentModel({
    this.id,
    this.orderId,
    this.method = '',
    this.status = '',
    this.razorpayOrderId,
    this.amount,
    this.currency = 'INR',
    this.paidAt,
    this.refundedAt,
  });

  factory DeliveryPaymentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeliveryPaymentModel(
      id: _parseInt(json['id']),
      orderId:
      _parseInt(json['order_id']),
      method:
      json['method']?.toString() ?? '',
      status:
      json['status']?.toString() ?? '',
      razorpayOrderId:
      json['razorpay_order_id']
          ?.toString(),
      amount: json['amount'],
      currency:
      json['currency']?.toString() ?? 'INR',
      paidAt:
      json['paid_at']?.toString(),
      refundedAt:
      json['refunded_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'method': method,
      'status': status,
      'razorpay_order_id':
      razorpayOrderId,
      'amount': amount,
      'currency': currency,
      'paid_at': paidAt,
      'refunded_at': refundedAt,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    );
  }
}