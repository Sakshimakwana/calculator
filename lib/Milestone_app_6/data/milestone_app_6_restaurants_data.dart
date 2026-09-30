// ============================================================================
// RESTAURANT MENU ITEM / FOOD
// ============================================================================

class MilestoneApp6MenuItem {
  final int id;
  final String name;
  final String image;
  final String price;
  final bool availability;

  const MilestoneApp6MenuItem({
    this.id = 0,
    required this.name,
    this.image = '',
    this.price = '',
    this.availability = true,
  });

  factory MilestoneApp6MenuItem.fromJson(
      Map<String, dynamic> json,
      ) {
    return MilestoneApp6MenuItem(
      id: int.tryParse(
        json['id']?.toString() ?? '',
      ) ??
          0,
      name: json['name']?.toString() ?? '',
      image:
      json['image_url']?.toString() ??
          json['image']?.toString() ??
          '',
      price: json['price']?.toString() ?? '',
      availability:
      json['availability'] == true ||
          json['availability']?.toString() == '1' ||
          json['availability']
              ?.toString()
              .toLowerCase() ==
              'true',
    );
  }
}

// ============================================================================
// RESTAURANT MENU / CATEGORY
// ============================================================================

class MilestoneApp6Menu {
  final int id;
  final String name;
  final List<MilestoneApp6MenuItem> menuItems;

  const MilestoneApp6Menu({
    this.id = 0,
    required this.name,
    this.menuItems = const [],
  });

  // API category image.
  //
  // Backend does not currently send an image_url for the menu/category.
  // Therefore we use the first menu item's image as the category image.
  String get image {
    if (menuItems.isNotEmpty) {
      return menuItems.first.image;
    }

    return '';
  }

  factory MilestoneApp6Menu.fromJson(
      Map<String, dynamic> json,
      ) {
    final List<MilestoneApp6MenuItem> items = [];

    final dynamic rawItems =
        json['menu_items'] ??
            json['menuItems'] ??
            [];

    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map) {
          items.add(
            MilestoneApp6MenuItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    return MilestoneApp6Menu(
      id: int.tryParse(
        json['id']?.toString() ?? '',
      ) ??
          0,
      name: json['name']?.toString() ?? '',
      menuItems: items,
    );
  }
}

// ============================================================================
// RESTAURANT
// ============================================================================

class MilestoneApp6Restaurant {
  final int id;
  final String name;
  final String image;
  final String rating;
  final String time;
  final String cuisine;
  final String price;
  final bool isOpen;
  final String distance;
  final String address;
  final String latitude;
  final String longitude;

  final List<MilestoneApp6Menu> menus;

  const MilestoneApp6Restaurant({
    this.id = 0,
    required this.name,
    required this.image,
    required this.rating,
    required this.time,
    required this.cuisine,
    required this.price,
    required this.isOpen,
    required this.distance,
    required this.address,
    this.latitude = '',
    this.longitude = '',
    this.menus = const [],
  });

  factory MilestoneApp6Restaurant.fromJson(
      Map<String, dynamic> json,
      ) {
    final String status =
        json['status']
            ?.toString()
            .trim()
            .toLowerCase() ??
            '';

    final List<MilestoneApp6Menu> menus = [];

    final dynamic rawMenus = json['menus'];

    if (rawMenus is List) {
      for (final menu in rawMenus) {
        if (menu is Map) {
          menus.add(
            MilestoneApp6Menu.fromJson(
              Map<String, dynamic>.from(menu),
            ),
          );
        }
      }
    }

    return MilestoneApp6Restaurant(
      id: int.tryParse(
        json['id']?.toString() ?? '',
      ) ??
          0,

      name: json['name']?.toString() ?? '',

      image:
      json['image_url']?.toString() ??
          json['image']?.toString() ??
          '',

      rating: json['rating']?.toString() ?? '',

      time: json['time']?.toString() ?? '',

      cuisine: json['cuisine']?.toString() ?? '',

      price: json['price']?.toString() ?? '',

      // Both OPEN and CLOSED restaurants are kept.
      isOpen: status == 'open',

      distance: json['distance']?.toString() ?? '',

      address: json['address']?.toString() ?? '',

      latitude:
      json['latitude']?.toString() ?? '',

      longitude:
      json['longitude']?.toString() ?? '',

      menus: menus,
    );
  }
  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  MilestoneApp6Restaurant copyWith({
    int? id,
    String? name,
    String? image,
    String? rating,
    String? time,
    String? cuisine,
    String? price,
    bool? isOpen,
    String? distance,
    String? address,
    String? latitude,
    String? longitude,
    List<MilestoneApp6Menu>? menus,
  }) {
    return MilestoneApp6Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      time: time ?? this.time,
      cuisine: cuisine ?? this.cuisine,
      price: price ?? this.price,
      isOpen: isOpen ?? this.isOpen,
      distance: distance ?? this.distance,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      menus: menus ?? this.menus,
    );
  }
}

// ============================================================================
// HELPER
// ============================================================================

int _toInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(
    value?.toString() ?? '',
  ) ??
      0;
}
//
// // ============================================================================
// // ALL RESTAURANTS
// // ============================================================================
//
// const restaurants = <MilestoneApp6Restaurant>[
//   // ========================================================================
//   // EXISTING RESTAURANTS
//   // ========================================================================
//
//   MilestoneApp6Restaurant(
//     name: 'The Italian Bistro',
//     image:
//     'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=700',
//     rating: '4.5',
//     time: '20-30 min',
//     cuisine: 'Italian • Pizza • Pasta',
//     price: '₹₹',
//     isOpen: true,
//     distance: '8 km',
//     address: 'SG Highway, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Sushi World',
//     image:
//     'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=700',
//     rating: '4.7',
//     time: '25-35 min',
//     cuisine: 'Japanese • Sushi • Asian',
//     price: '₹₹₹',
//     isOpen: true,
//     distance: '12 km',
//     address: 'Vastrapur, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Burger Hub',
//     image:
//     'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=700',
//     rating: '4.6',
//     time: '15-25 min',
//     cuisine: 'Burgers • Fast Food',
//     price: '₹₹',
//     isOpen: true,
//     distance: '5 km',
//     address: 'Navrangpura, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Green Bowl',
//     image:
//     'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=700',
//     rating: '4.5',
//     time: '20-30 min',
//     cuisine: 'Healthy • Salads • Veg',
//     price: '₹₹',
//     isOpen: true,
//     distance: '7 km',
//     address: 'Bodakdev, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Pasta Corner',
//     image:
//     'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=700',
//     rating: '4.6',
//     time: '20-30 min',
//     cuisine: 'Italian • Pasta',
//     price: '₹₹',
//     isOpen: true,
//     distance: '10 km',
//     address: 'Satellite, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Fresh Bites',
//     image:
//     'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=700',
//     rating: '4.4',
//     time: '15-25 min',
//     cuisine: 'Sandwiches • Veg • Cafe',
//     price: '₹',
//     isOpen: true,
//     distance: '4 km',
//     address: 'Prahlad Nagar, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Morning Cafe',
//     image:
//     'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=700',
//     rating: '4.7',
//     time: '15-25 min',
//     cuisine: 'Breakfast • Cafe • Veg',
//     price: '₹₹',
//     isOpen: true,
//     distance: '6 km',
//     address: 'Thaltej, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Asian Kitchen',
//     image:
//     'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=700',
//     rating: '4.6',
//     time: '25-35 min',
//     cuisine: 'Asian • Noodles • Rice',
//     price: '₹₹',
//     isOpen: true,
//     distance: '9 km',
//     address: 'C G Road, Ahmedabad',
//   ),
//
//   // ========================================================================
//   // MORE RESTAURANTS
//   // ========================================================================
//
//   MilestoneApp6Restaurant(
//     name: 'Spice Garden',
//     image:
//     'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=700',
//     rating: '4.5',
//     time: '20-30 min',
//     cuisine: 'North Indian • Punjabi • Veg',
//     price: '₹₹',
//     isOpen: true,
//     distance: '8 km',
//     address: 'SG Highway, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Taco Fiesta',
//     image:
//     'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=700',
//     rating: '4.4',
//     time: '15-25 min',
//     cuisine: 'Mexican • Tacos • Wraps',
//     price: '₹₹',
//     isOpen: false,
//     distance: '83 km',
//     address: 'Satellite, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Sweet Cravings',
//     image:
//     'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=700',
//     rating: '4.6',
//     time: '15-25 min',
//     cuisine: 'Desserts • Cakes • Bakery',
//     price: '₹₹',
//     isOpen: true,
//     distance: '5 km',
//     address: 'Vastrapur, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Royal Thali',
//     image:
//     'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=700',
//     rating: '4.7',
//     time: '25-35 min',
//     cuisine: 'Indian • Gujarati • Thali',
//     price: '₹₹',
//     isOpen: true,
//     distance: '11 km',
//     address: 'Maninagar, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Wok Express',
//     image:
//     'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=700',
//     rating: '4.5',
//     time: '20-30 min',
//     cuisine: 'Chinese • Noodles • Rice',
//     price: '₹₹',
//     isOpen: true,
//     distance: '7 km',
//     address: 'Navrangpura, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Cafe Mocha',
//     image:
//     'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=700',
//     rating: '4.6',
//     time: '10-20 min',
//     cuisine: 'Cafe • Coffee • Desserts',
//     price: '₹₹',
//     isOpen: false,
//     distance: '14 km',
//     address: 'Bopal, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Dosa House',
//     image:
//     'https://images.unsplash.com/photo-1630383249896-424e482df921?w=700',
//     rating: '4.5',
//     time: '20-30 min',
//     cuisine: 'South Indian • Dosa • Idli',
//     price: '₹',
//     isOpen: true,
//     distance: '6 km',
//     address: 'Naranpura, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'The BBQ Station',
//     image:
//     'https://images.unsplash.com/photo-1544025162-d76694265947?w=700',
//     rating: '4.7',
//     time: '30-40 min',
//     cuisine: 'BBQ • Grill • Kebabs',
//     price: '₹₹₹',
//     isOpen: true,
//     distance: '16 km',
//     address: 'Prahlad Nagar, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Wrap & Roll',
//     image:
//     'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=700',
//     rating: '4.3',
//     time: '15-25 min',
//     cuisine: 'Wraps • Rolls • Fast Food',
//     price: '₹',
//     isOpen: true,
//     distance: '4 km',
//     address: 'Vastrapur, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Biryani House',
//     image:
//     'https://images.unsplash.com/photo-1631515242808-497c3fbd3972?auto=format&fit=crop&w=700&q=80',
//     rating: '4.6',
//     time: '25-35 min',
//     cuisine: 'Biryani • Mughlai • Indian',
//     price: '₹₹',
//     isOpen: true,
//     distance: '9 km',
//     address: 'Juhapura, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'The Healthy Kitchen',
//     image:
//     'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=700',
//     rating: '4.4',
//     time: '20-30 min',
//     cuisine: 'Healthy • Salads • Bowls',
//     price: '₹₹',
//     isOpen: true,
//     distance: '13 km',
//     address: 'Bodakdev, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Pizza Palace',
//     image:
//     'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=700',
//     rating: '4.6',
//     time: '20-30 min',
//     cuisine: 'Pizza • Italian • Fast Food',
//     price: '₹₹',
//     isOpen: true,
//     distance: '3 km',
//     address: 'Satellite, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Chai & Snacks',
//     image:
//     'https://images.unsplash.com/photo-1594631252845-29fc4cc8cde9?w=700',
//     rating: '4.3',
//     time: '10-20 min',
//     cuisine: 'Indian Snacks • Tea • Cafe',
//     price: '₹',
//     isOpen: true,
//     distance: '2 km',
//     address: 'Navrangpura, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Street Food Co.',
//     image:
//     'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=700',
//     rating: '4.5',
//     time: '15-25 min',
//     cuisine: 'Street Food • Chaat • Snacks',
//     price: '₹',
//     isOpen: false,
//     distance: '18 km',
//     address: 'Maninagar, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Urban Eats',
//     image:
//     'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=700',
//     rating: '4.4',
//     time: '20-30 min',
//     cuisine: 'Multi Cuisine • Fast Food',
//     price: '₹₹',
//     isOpen: true,
//     distance: '12 km',
//     address: 'Thaltej, Ahmedabad',
//   ),
// ];
//
// // ============================================================================
// // NEW RESTAURANTS - HOME VERTICAL SECTION
// // ============================================================================
//
// const newRestaurants = <MilestoneApp6Restaurant>[
//   MilestoneApp6Restaurant(
//     name: 'Spice Garden',
//     image:
//     'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=900',
//     rating: '4.5',
//     time: '20-30 min',
//     cuisine: 'North Indian • Punjabi • Veg',
//     price: '₹₹',
//     isOpen: true,
//     distance: '8 km',
//     address: 'SG Highway, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Taco Fiesta',
//     image:
//     'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=900',
//     rating: '4.4',
//     time: '15-25 min',
//     cuisine: 'Mexican • Tacos • Wraps',
//     price: '₹₹',
//     isOpen: false,
//     distance: '83 km',
//     address: 'Satellite, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Sweet Cravings',
//     image:
//     'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
//     rating: '4.6',
//     time: '15-25 min',
//     cuisine: 'Desserts • Cakes • Bakery',
//     price: '₹₹',
//     isOpen: true,
//     distance: '5 km',
//     address: 'Vastrapur, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Royal Thali',
//     image:
//     'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=900',
//     rating: '4.7',
//     time: '25-35 min',
//     cuisine: 'Indian • Gujarati • Thali',
//     price: '₹₹',
//     isOpen: true,
//     distance: '11 km',
//     address: 'Maninagar, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Wok Express',
//     image:
//     'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
//     rating: '4.5',
//     time: '20-30 min',
//     cuisine: 'Chinese • Noodles • Rice',
//     price: '₹₹',
//     isOpen: true,
//     distance: '7 km',
//     address: 'Navrangpura, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Cafe Mocha',
//     image:
//     'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=900',
//     rating: '4.6',
//     time: '10-20 min',
//     cuisine: 'Cafe • Coffee • Desserts',
//     price: '₹₹',
//     isOpen: false,
//     distance: '14 km',
//     address: 'Bopal, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Dosa House',
//     image:
//     'https://images.unsplash.com/photo-1630383249896-424e482df921?w=900',
//     rating: '4.5',
//     time: '20-30 min',
//     cuisine: 'South Indian • Dosa • Idli',
//     price: '₹',
//     isOpen: true,
//     distance: '6 km',
//     address: 'Naranpura, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'The BBQ Station',
//     image:
//     'https://images.unsplash.com/photo-1544025162-d76694265947?w=900',
//     rating: '4.7',
//     time: '30-40 min',
//     cuisine: 'BBQ • Grill • Kebabs',
//     price: '₹₹₹',
//     isOpen: true,
//     distance: '16 km',
//     address: 'Prahlad Nagar, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Wrap & Roll',
//     image:
//     'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=900',
//     rating: '4.3',
//     time: '15-25 min',
//     cuisine: 'Wraps • Rolls • Fast Food',
//     price: '₹',
//     isOpen: true,
//     distance: '4 km',
//     address: 'Vastrapur, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Biryani House',
//     image:
//     'https://images.unsplash.com/photo-1563379091339-03246963d51a?w=900',
//     rating: '4.6',
//     time: '25-35 min',
//     cuisine: 'Biryani • Mughlai • Indian',
//     price: '₹₹',
//     isOpen: true,
//     distance: '9 km',
//     address: 'Juhapura, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'The Healthy Kitchen',
//     image:
//     'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=900',
//     rating: '4.4',
//     time: '20-30 min',
//     cuisine: 'Healthy • Salads • Bowls',
//     price: '₹₹',
//     isOpen: true,
//     distance: '13 km',
//     address: 'Bodakdev, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Pizza Palace',
//     image:
//     'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=900',
//     rating: '4.6',
//     time: '20-30 min',
//     cuisine: 'Pizza • Italian • Fast Food',
//     price: '₹₹',
//     isOpen: true,
//     distance: '3 km',
//     address: 'Satellite, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Chai & Snacks',
//     image:
//     'https://images.unsplash.com/photo-1594631252845-29fc4cc8cde9?w=900',
//     rating: '4.3',
//     time: '10-20 min',
//     cuisine: 'Indian Snacks • Tea • Cafe',
//     price: '₹',
//     isOpen: true,
//     distance: '2 km',
//     address: 'Navrangpura, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Street Food Co.',
//     image:
//     'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=900',
//     rating: '4.5',
//     time: '15-25 min',
//     cuisine: 'Street Food • Chaat • Snacks',
//     price: '₹',
//     isOpen: false,
//     distance: '18 km',
//     address: 'Maninagar, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Urban Eats',
//     image:
//     'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=900',
//     rating: '4.4',
//     time: '20-30 min',
//     cuisine: 'Multi Cuisine • Fast Food',
//     price: '₹₹',
//     isOpen: true,
//     distance: '12 km',
//     address: 'Thaltej, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Maharaja Kitchen',
//     image:
//     'https://images.unsplash.com/photo-1601050690117-94f5f6fa8bd7?w=900',
//     rating: '4.6',
//     time: '25-35 min',
//     cuisine: 'Indian • Mughlai • Punjabi',
//     price: '₹₹',
//     isOpen: true,
//     distance: '10 km',
//     address: 'C G Road, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Bombay Street',
//     image:
//     'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=900',
//     rating: '4.5',
//     time: '15-25 min',
//     cuisine: 'Street Food • Chaat • Indian',
//     price: '₹',
//     isOpen: true,
//     distance: '15 km',
//     address: 'Gurukul Road, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Cheese & Crust',
//     image:
//     'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
//     rating: '4.7',
//     time: '20-30 min',
//     cuisine: 'Pizza • Italian • Cheese',
//     price: '₹₹',
//     isOpen: true,
//     distance: '6 km',
//     address: 'Bodakdev, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Noodle Nation',
//     image:
//     'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=900',
//     rating: '4.5',
//     time: '20-30 min',
//     cuisine: 'Asian • Noodles • Chinese',
//     price: '₹₹',
//     isOpen: true,
//     distance: '9 km',
//     address: 'Vastrapur, Ahmedabad',
//   ),
//
//   MilestoneApp6Restaurant(
//     name: 'Dessert Story',
//     image:
//     'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=900',
//     rating: '4.6',
//     time: '15-25 min',
//     cuisine: 'Desserts • Ice Cream • Cakes',
//     price: '₹₹',
//     isOpen: false,
//     distance: '20 km',
//     address: 'Bopal, Ahmedabad',
//   ),
// ];
