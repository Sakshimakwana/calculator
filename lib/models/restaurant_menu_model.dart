class RestaurantMenuResponse {
  final bool success;
  final String message;
  final List<RestaurantMenu> data;

  RestaurantMenuResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RestaurantMenuResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return RestaurantMenuResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map(
            (item) => RestaurantMenu.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList() ??
          [],
    );
  }
}

class RestaurantMenu {
  final int id;
  final String name;
  final List<RestaurantMenuItem> menuItems;

  RestaurantMenu({
    required this.id,
    required this.name,
    required this.menuItems,
  });

  factory RestaurantMenu.fromJson(
      Map<String, dynamic> json,
      ) {
    return RestaurantMenu(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      menuItems: (json['menu_items'] as List<dynamic>?)
          ?.map(
            (item) => RestaurantMenuItem.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList() ??
          [],
    );
  }
}

class RestaurantMenuItem {
  final int id;
  final int menuId;
  final String name;
  final double price;
  final bool availability;
  final String imageUrl;

  RestaurantMenuItem({
    required this.id,
    required this.menuId,
    required this.name,
    required this.price,
    required this.availability,
    required this.imageUrl,
  });

  factory RestaurantMenuItem.fromJson(
      Map<String, dynamic> json,
      ) {
    return RestaurantMenuItem(
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