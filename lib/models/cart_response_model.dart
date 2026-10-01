class CartResponseModel {
  final bool success;
  final String message;
  final List<CartItemModel> data;

  CartResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CartResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CartResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map(
            (item) => CartItemModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }
}

class CartItemModel {
  final int id;
  final int userId;
  final int restaurantId;
  final int quantity;
  final CartMenuItemModel menuItem;
  final CartRestaurantModel restaurant;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.quantity,
    required this.menuItem,
    required this.restaurant,
  });

  factory CartItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CartItemModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      restaurantId: json['restaurant_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      menuItem: CartMenuItemModel.fromJson(
        json['menu_item'] ?? {},
      ),
      restaurant: CartRestaurantModel.fromJson(
        json['restaurant'] ?? {},
      ),
    );
  }
}

class CartMenuItemModel {
  final int id;
  final int menuId;
  final String name;
  final double price;
  final bool availability;
  final String imageUrl;

  CartMenuItemModel({
    required this.id,
    required this.menuId,
    required this.name,
    required this.price,
    required this.availability,
    required this.imageUrl,
  });

  factory CartMenuItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CartMenuItemModel(
      id: json['id'] ?? 0,
      menuId: json['menu_id'] ?? 0,
      name: json['name'] ?? '',
      price: double.tryParse(
        json['price']?.toString() ?? '0',
      ) ??
          0,
      availability: json['availability'] ?? false,
      imageUrl: json['image_url'] ?? '',
    );
  }
}

class CartRestaurantModel {
  final int id;
  final String name;
  final String imageUrl;
  final String address;
  final String status;
  final String latitude;
  final String longitude;
  final dynamic distance;

  CartRestaurantModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.distance,
  });

  factory CartRestaurantModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CartRestaurantModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      distance: json['distance'],
    );
  }
}