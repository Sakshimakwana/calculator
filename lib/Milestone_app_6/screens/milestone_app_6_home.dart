import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_matic_tech_flutter_app/Milestone_app_6/data/milestone_app_6_food.dart';
import 'package:app_matic_tech_flutter_app/core/storage/address_storage.dart';
import 'package:app_matic_tech_flutter_app/core/storage/auth_storage.dart';
import 'package:app_matic_tech_flutter_app/services/milestone_app_6_restaurant_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../data/milestone_app_6_restaurants_data.dart';
import '../state/milestone_app_6_state.dart';
import '../theme/milestone_app_6_colors.dart';
import '../widgets/milestone_app_6_category.dart';
import '../widgets/milestone_app_6_image.dart';
import '../widgets/milestone_app_6_animated_search_hint.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_matic_tech_flutter_app/core/constants/api_constants.dart';
import 'package:app_matic_tech_flutter_app/models/restaurant_menu_model.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/widgets/RestaurantShimmerCard.dart';

class _ApiFoodEntry {
  final MilestoneApp6Restaurant restaurant;
  final MilestoneApp6Menu menu;
  final MilestoneApp6MenuItem item;

  const _ApiFoodEntry({
    required this.restaurant,
    required this.menu,
    required this.item,
  });
}

class MilestoneApp6HomeScreen extends StatefulWidget {
  final MilestoneApp6State state;

  const MilestoneApp6HomeScreen({
    super.key,
    required this.state,
  });

  @override
  State<MilestoneApp6HomeScreen> createState() =>
      _MilestoneApp6HomeScreenState();
}

class _MilestoneApp6HomeScreenState extends State<MilestoneApp6HomeScreen> {
// ==============================================================
// RESTAURANT API
// ==============================================================

  bool _isLoadingRestaurants = false;

  String? _restaurantError;

  List<MilestoneApp6Restaurant> _nearbyRestaurants = [];

  final MilestoneApp6RestaurantApi _restaurantApi =
      MilestoneApp6RestaurantApi();

// =============================================================
// RESTAURANT PAGINATION
// =============================================================

  static const int _restaurantPerPage = 6;

  int _currentRestaurantPage = 0;

  int _lastRestaurantPage = 1;

  int _totalRestaurants = 0;

  int _recordsLoaded = 0;

  bool _hasMoreRestaurantPages = true;

  bool _isLoadingMoreRestaurants = false;

  final ScrollController _homeScrollController = ScrollController();

// ==============================================================
// FILTERED API RESTAURANTS BY CATEGORY
// ==============================================================

  List<MilestoneApp6Restaurant> get _filteredNearbyRestaurants {
    final String selectedCategory = _selectedCategory.trim().toLowerCase();

// All category.
    if (selectedCategory.isEmpty) {
      return _nearbyRestaurants;
    }

    return _nearbyRestaurants.where((restaurant) {
      return restaurant.menus.any(
        (menu) {
          return menu.name.trim().toLowerCase() == selectedCategory;
        },
      );
    }).toList();
  }

// ==============================================================
// ADDRESS
// ==============================================================

  String _selectedAddress = '';

// ==============================================================
// CATEGORY
// ==============================================================

  String _selectedCategory = '';

// ==============================================================
// SEARCH
// ==============================================================

  final TextEditingController _searchController = TextEditingController();

  Timer? _searchHintTimer;

  int _searchHintIndex = 0;

  final List<String> _searchHints = [
    'Pizza',
    'Burger',
    'Sushi',
    'Dessert',
    'Pasta',
    'Salad',
    'Drinks',
    'Tacos',
    'Asian',
    'Breakfast',
    'Sandwich',
  ];

// ==============================================================
// SPEECH
// ==============================================================

  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;

  bool _speechAvailable = false;

// ==============================================================
// INIT
// ==============================================================

  @override
  void initState() {
    super.initState();

    _homeScrollController.addListener(
      _onHomeScroll,
    );

    _loadSelectedAddress();

    _searchController.addListener(
      _onSearchChanged,
    );

    _searchHintTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) {
        if (!mounted) return;

        if (_searchController.text.trim().isEmpty && !_isListening) {
          setState(() {
            _searchHintIndex = (_searchHintIndex + 1) % _searchHints.length;
          });
        }
      },
    );

    _loadNearbyRestaurants();
  }

// =============================================================
// RESTAURANT PAGINATION SCROLL
// ==============================================================

  void _onHomeScroll() {
    if (!_homeScrollController.hasClients) {
      return;
    }

    final ScrollPosition position = _homeScrollController.position;

// Start loading the next page before the user reaches
// the absolute bottom.
    if (position.pixels >= position.maxScrollExtent - 500) {
      _loadNextRestaurantPage();
    }
  }

  Future<void> _refreshHome() async {
    setState(() {
      _selectedCategory = '';
    });

// KEEP YOUR EXISTING API CALL HERE
    await _loadNearbyRestaurants();
  }

// ==============================================================
// LOAD SELECTED ADDRESS
// ==============================================================

  Future<void> _loadSelectedAddress() async {
    final int? addressId = AddressStorage.selectedAddressId;

    if (!mounted) return;

    if (addressId == null || addressId <= 0) {
      setState(() {
        _selectedAddress = '';
      });

      return;
    }

    setState(() {
      _selectedAddress = 'Address #$addressId';
    });
  }

// ==============================================================
// LOAD NEARBY RESTAURANTS
// ==============================================================

// =============================================================
// LOAD FIRST RESTAURANT PAGE
// ==============================================================

  Future<void> _loadNearbyRestaurants() async {
    if (!mounted) return;

    setState(() {
      _isLoadingRestaurants = true;
      _restaurantError = null;

      _nearbyRestaurants = [];

      _currentRestaurantPage = 0;
      _lastRestaurantPage = 1;

      _totalRestaurants = 0;
      _recordsLoaded = 0;

      _hasMoreRestaurantPages = true;
      _isLoadingMoreRestaurants = false;

      _selectedCategory = '';
    });

    try {
      final String? token = await AuthStorage.token;

      if (token == null || token.trim().isEmpty) {
        throw Exception(
          'Authentication token is missing.',
        );
      }

      final int? addressId = await AddressStorage.selectedAddressId;

      if (addressId == null || addressId <= 0) {
        throw Exception(
          'Please select an address first.',
        );
      }

      final response = await _restaurantApi.fetchNearbyRestaurantsPage(
        token: token,
        addressId: addressId,
        page: 1,
        perPage: _restaurantPerPage,
        openNow: false,
        includeMenus: true,
      );

      List<MilestoneApp6Restaurant> restaurants = response.data
          .map(
            (json) => MilestoneApp6Restaurant.fromJson(json),
          )
          .toList();

      restaurants = await _loadMenusForRestaurants(
        token,
        restaurants,
      );

      if (!mounted) return;

      setState(() {
        _nearbyRestaurants = restaurants;

        _currentRestaurantPage = response.currentPage;

        _lastRestaurantPage = response.lastPage;

        _totalRestaurants = response.total;

        _recordsLoaded = response.recordsLoaded;

        _hasMoreRestaurantPages = response.hasMorePages;

        _isLoadingRestaurants = false;

        _restaurantError = null;
      });

      debugPrint(
        'PAGE: ${response.currentPage}',
      );
      debugPrint(
        'PER PAGE: ${response.perPage}',
      );
      debugPrint(
        'COUNT: ${response.count}',
      );
      debugPrint(
        'TOTAL: ${response.total}',
      );
      debugPrint(
        'HAS MORE: ${response.hasMorePages}',
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingRestaurants = false;
        _restaurantError = e.toString();
        _nearbyRestaurants = [];
        _hasMoreRestaurantPages = false;
      });
    }
  }

  Future<RestaurantMenuResponse> _loadRestaurantMenus(
    String token,
    int restaurantId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.restaurantMenus(restaurantId)}',
    );

    debugPrint(
      'MENU API REQUEST: $uri',
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ).timeout(
      const Duration(seconds: 30),
    );

    debugPrint(
      'MENU API STATUS: ${response.statusCode}',
    );

    if (response.statusCode == 401) {
      throw Exception(
        'Unauthorized while loading menu for restaurant $restaurantId.',
      );
    }

    if (response.statusCode == 404) {
      throw Exception(
        'Menu not found for restaurant $restaurantId.',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Failed to load menu for restaurant $restaurantId. '
        'Status: ${response.statusCode}',
      );
    }

    if (response.body.trim().isEmpty) {
      return RestaurantMenuResponse(
        success: true,
        message: 'No menu data.',
        data: const [],
      );
    }

    final dynamic decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        'Invalid menu API response for restaurant $restaurantId.',
      );
    }

    return RestaurantMenuResponse.fromJson(
      decoded,
    );
  }

  Future<MilestoneApp6Restaurant> _loadMenusForRestaurant(
    String token,
    MilestoneApp6Restaurant restaurant,
  ) async {
    if (restaurant.id <= 0) {
      debugPrint(
        'MENU API SKIPPED: invalid restaurant id for ${restaurant.name}',
      );
      return restaurant;
    }

    try {
      final RestaurantMenuResponse menuResponse = await _loadRestaurantMenus(
        token,
        restaurant.id,
      );

      final List<MilestoneApp6Menu> menus = menuResponse.data.map((apiMenu) {
        final List<MilestoneApp6MenuItem> items =
            apiMenu.menuItems.map((apiItem) {
          return MilestoneApp6MenuItem(
            id: apiItem.id,
            name: apiItem.name,
            image: apiItem.imageUrl,
            price: apiItem.price.toString(),
            availability: apiItem.availability,
          );
        }).toList();

        return MilestoneApp6Menu(
          id: apiMenu.id,
          name: apiMenu.name,
          menuItems: items,
        );
      }).toList();

      debugPrint(
        'MENU LOADED: ${restaurant.name} -> ${menus.length} categories',
      );

      for (final menu in menus) {
        debugPrint(
          'CATEGORY: ${menu.name}',
        );

        for (final item in menu.menuItems) {
          debugPrint(
            'FOOD: ${item.name} - ${item.price}',
          );
        }
      }

      return restaurant.copyWith(
        menus: menus,
      );
    } catch (e) {
      debugPrint(
        'MENU API ERROR for ${restaurant.name} (${restaurant.id}): $e',
      );

// Keep the restaurant visible even if its menu API fails.
      return restaurant;
    }
  }

  Future<List<MilestoneApp6Restaurant>> _loadMenusForRestaurants(
    String token,
    List<MilestoneApp6Restaurant> restaurants,
  ) async {
    final List<MilestoneApp6Restaurant> result = [];

    for (final restaurant in restaurants) {
      final updatedRestaurant = await _loadMenusForRestaurant(
        token,
        restaurant,
      );

      result.add(updatedRestaurant);
    }

    return result;
  }

// =============================================================
// LOAD NEXT RESTAURANT PAGE
// ==============================================================

  Future<void> _loadNextRestaurantPage() async {
    if (_isLoadingMoreRestaurants || !_hasMoreRestaurantPages) {
      return;
    }

    setState(() {
      _isLoadingMoreRestaurants = true;
    });

    try {
      final String? token = await AuthStorage.token;
      final int? addressId = await AddressStorage.selectedAddressId;

      if (token == null || addressId == null) {
        return;
      }

      final int nextPage = _currentRestaurantPage + 1;

      if (nextPage > _lastRestaurantPage) {
        setState(() {
          _hasMoreRestaurantPages = false;
        });
        return;
      }

      final response = await _restaurantApi.fetchNearbyRestaurantsPage(
        token: token,
        addressId: addressId,
        page: nextPage,
        perPage: _restaurantPerPage,
        openNow: false,
        includeMenus: true,
      );

      List<MilestoneApp6Restaurant> newRestaurants = response.data
          .map(
            (json) => MilestoneApp6Restaurant.fromJson(json),
          )
          .toList();

      newRestaurants = await _loadMenusForRestaurants(
        token,
        newRestaurants,
      );

      if (!mounted) return;

      setState(() {
        _nearbyRestaurants.addAll(newRestaurants);

        _currentRestaurantPage = response.currentPage;
        _lastRestaurantPage = response.lastPage;
        _totalRestaurants = response.total;
        _recordsLoaded = response.recordsLoaded;
        _hasMoreRestaurantPages = response.hasMorePages;
      });

      debugPrint(
        'RESTAURANT PAGE: $_currentRestaurantPage / $_lastRestaurantPage',
      );

      debugPrint(
        'RESTAURANTS LOADED: $_recordsLoaded / $_totalRestaurants',
      );
    } catch (e) {
      debugPrint(
        'LOAD NEXT RESTAURANT PAGE ERROR: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMoreRestaurants = false;
        });
      }
    }
  }

// ==============================================================
// API CATEGORIES
// ==============================================================

  List<String> get _apiCategories {
    final Map<String, String> categoryNames = {};

    for (final restaurant in _nearbyRestaurants) {
      for (final menu in restaurant.menus) {
        final String name = menu.name.trim();

        if (name.isEmpty) {
          continue;
        }

        final String key = name.toLowerCase();

        categoryNames.putIfAbsent(
          key,
          () => name,
        );
      }
    }

    return categoryNames.values.toList();
  }

// ==============================================================
// API FOOD ITEMS
// ==============================================================

  List<MilestoneApp6MenuItem> get _apiFoodItems {
    final List<MilestoneApp6MenuItem> items = [];

    for (final restaurant in _nearbyRestaurants) {
      for (final menu in restaurant.menus) {
        items.addAll(menu.menuItems);
      }
    }

    return items;
  }

// ==============================================================
// SEARCH LISTENER
// ==============================================================

  void _onSearchChanged() {
    if (!mounted) return;

    setState(() {});
  }

// ==============================================================
// DISPOSE
// ==============================================================

  @override
  void dispose() {
    _searchHintTimer?.cancel();

    _homeScrollController.removeListener(
      _onHomeScroll,
    );

    _homeScrollController.dispose();

    _searchController.removeListener(
      _onSearchChanged,
    );

    _searchController.dispose();

    if (_isListening) {
      _speech.stop();
    }

    super.dispose();
  }

// ==============================================================
// SPEECH INITIALIZATION
// ==============================================================

  Future<void> _initializeSpeech() async {
    final bool available = await _speech.initialize(
      onStatus: (status) {
        if (!mounted) return;

        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          _isListening = false;
        });
      },
    );

    if (!mounted) return;

    setState(() {
      _speechAvailable = available;
    });
  }

// ==============================================================
// MICROPHONE
// ==============================================================

  Future<void> _toggleListening() async {
    if (!_speechAvailable) {
      await _initializeSpeech();

      if (!_speechAvailable) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'Speech recognition is not available.',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );

        return;
      }
    }

// ------------------------------------------------------------
// STOP LISTENING
// ------------------------------------------------------------

    if (_isListening) {
      await _speech.stop();

      if (!mounted) return;

      setState(() {
        _isListening = false;
      });

      return;
    }

// ------------------------------------------------------------
// START LISTENING
// ------------------------------------------------------------

    FocusScope.of(context).unfocus();

    setState(() {
      _isListening = true;
    });

    await _speech.listen(
      listenMode: stt.ListenMode.search,
      partialResults: true,
      onResult: (result) {
        if (!mounted) return;

        final String words = result.recognizedWords;

        _searchController.value = TextEditingValue(
          text: words,
          selection: TextSelection.collapsed(
            offset: words.length,
          ),
        );
      },
    );
  }

// ==============================================================
// CATEGORY SELECTION
// ==============================================================

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

// ==============================================================
// FILTERED API RESTAURANT FOOD
// ==============================================================

  List<_ApiFoodEntry> _filteredRestaurantApiFoods(
    MilestoneApp6Restaurant restaurant,
  ) {
    final List<_ApiFoodEntry> foods = _restaurantApiFoods(restaurant);

    final String selectedCategory = _selectedCategory.trim().toLowerCase();

    if (selectedCategory.isEmpty) {
      return foods;
    }

    return foods.where((entry) {
      return entry.menu.name.trim().toLowerCase() == selectedCategory;
    }).toList();
  }

// ==============================================================
// API RESTAURANT FOOD
// ==============================================================

// ==============================================================

  List<_ApiFoodEntry> _restaurantApiFoods(
    MilestoneApp6Restaurant restaurant,
  ) {
    final List<_ApiFoodEntry> result = [];

    for (final menu in restaurant.menus) {
      for (final item in menu.menuItems) {
        result.add(
          _ApiFoodEntry(
            restaurant: restaurant,
            menu: menu,
            item: item,
          ),
        );
      }
    }

    return result;
  }

// ==============================================================
// CLEAR SEARCH
// ==============================================================

  void _clearSearch() {
    _searchController.clear();

    FocusScope.of(context).unfocus();
  }

// ==============================================================
// NEARBY RESTAURANTS HORIZONTAL
// ==============================================================

// Widget _buildNearbyRestaurantsHorizontal() {
//   // ------------------------------------------------------------
//   // LOADING
//   // ------------------------------------------------------------
//
//   if (_isLoadingRestaurants) {
//     return const SizedBox(
//       height: 350,
//       child: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
//
//   // ------------------------------------------------------------
//   // ERROR
//   // ------------------------------------------------------------
//
//   if (_restaurantError != null) {
//     return SizedBox(
//       height: 180,
//       child: Center(
//         child: Padding(
//           padding:
//           const EdgeInsets.symmetric(
//             horizontal: 30,
//           ),
//           child: Column(
//             mainAxisAlignment:
//             MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons
//                     .cloud_off_rounded,
//                 size: 42,
//                 color: Theme.of(context)
//                     .colorScheme
//                     .primary,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text(
//                 'Unable to load restaurants.',
//                 textAlign:
//                 TextAlign.center,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               TextButton(
//                 onPressed:
//                 _loadNearbyRestaurants,
//                 child: const Text(
//                   'Retry',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ------------------------------------------------------------
//   // EMPTY
//   // ------------------------------------------------------------
//
//   if (_nearbyRestaurants.isEmpty) {
//     return SizedBox(
//       height: 180,
//       child: Center(
//         child: Padding(
//           padding:
//           const EdgeInsets.symmetric(
//             horizontal: 30,
//           ),
//           child: Column(
//             mainAxisAlignment:
//             MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons
//                     .restaurant_outlined,
//                 size: 42,
//                 color: Theme.of(context)
//                     .hintColor,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'No nearby restaurants found.',
//                 textAlign:
//                 TextAlign.center,
//                 style: TextStyle(
//                   color: Theme.of(context)
//                       .hintColor,
//                   fontWeight:
//                   FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ------------------------------------------------------------
//   // RESTAURANTS
//   // ------------------------------------------------------------
//
//   return SizedBox(
//     height: 350,
//     child: ListView.separated(
//       padding:
//       const EdgeInsets.fromLTRB(
//         10,
//         0,
//         16,
//         0,
//       ),
//       scrollDirection:
//       Axis.horizontal,
//       physics:
//       const BouncingScrollPhysics(),
//       itemCount:
//      _filteredNearbyRestaurants.length,
//       separatorBuilder:
//           (_, __) =>
//       const SizedBox(
//         width: 1,
//       ),
//       itemBuilder:
//           (context, index) {
//         final restaurant =
//         _filteredNearbyRestaurants[index];
//
//         return SizedBox(
//           width: 340,
//           child: _restaurantItem(
//             restaurant: restaurant,
//             showFoodCards: false,
//           ),
//         );
//       },
//     ),
//   );
// }

// ==============================================================
// NEARBY RESTAURANTS VERTICAL
// ==============================================================

// =============================================================
// NEARBY RESTAURANTS - 2 COLUMN GRID
// =============================================================

  Widget _buildNearbyRestaurantsVertical() {
// ------------------------------------------------------------
// LOADING
// ------------------------------------------------------------

    if (_isLoadingRestaurants && _nearbyRestaurants.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: MilestoneApp6RestaurantShimmer(
          itemCount: 6,
        ),
      );
    }

// ------------------------------------------------------------
// ERROR
// ------------------------------------------------------------

    if (_restaurantError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 30,
        ),
        child: Column(
          children: [
            const Text(
              'Unable to load restaurants.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _loadNearbyRestaurants,
              child: const Text(
                'Retry',
              ),
            ),
          ],
        ),
      );
    }

// ------------------------------------------------------------
// EMPTY
// ------------------------------------------------------------

    if (_nearbyRestaurants.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 35,
          horizontal: 30,
        ),
        child: Column(
          children: [
            Icon(
              Icons.restaurant_menu_rounded,
              size: 42,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 10),
            Text(
              'No nearby restaurants found.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      );
    }

// ------------------------------------------------------------
// FILTERED RESTAURANTS
// ------------------------------------------------------------

    final List<MilestoneApp6Restaurant> restaurantsToShow =
        _filteredNearbyRestaurants;

// ------------------------------------------------------------
// NO RESTAURANTS AFTER FILTER
// ------------------------------------------------------------

    if (restaurantsToShow.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 35,
          horizontal: 30,
        ),
        child: Column(
          children: [
            Icon(
              Icons.restaurant_menu_rounded,
              size: 42,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 10),
            Text(
              _selectedCategory.trim().isEmpty
                  ? 'No restaurants found.'
                  : 'No restaurants found for "$_selectedCategory".',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      );
    }

// ------------------------------------------------------------
// 2 COLUMN RESTAURANT GRID
// ------------------------------------------------------------

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.68,
          ),
          itemCount: restaurantsToShow.length,
          itemBuilder: (context, index) {
            final restaurant = restaurantsToShow[index];

            return _newRestaurantItem(
              restaurant: restaurant,
            );
          },
        ),
        _buildRestaurantPaginationFooter(),
      ],
    );
  }

  Widget _buildRestaurantPaginationFooter() {
    if (_isLoadingMoreRestaurants) {
      final bool isDark = Theme.of(context).brightness == Brightness.dark;

      return Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          24,
        ),
        child: SizedBox(
          height: 230,
          child: MilestoneApp6RestaurantShimmer(
            itemCount: 6,
          ),
        ),
      );
    }

    if (_hasMoreRestaurantPages) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Center(
          child: Text(
            'Scroll down to load more restaurants',
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_rounded,
          ),
          const SizedBox(height: 8),
          const Text(
            'All restaurants loaded',
          ),
          const SizedBox(height: 4),
          Text(
            '$_recordsLoaded of $_totalRestaurants restaurants',
          ),
        ],
      ),
    );
  }

// ==============================================================
// NEW RESTAURANT - ZOMATO STYLE
// ==============================================================

// =============================================================
// RESTAURANT CARD - 2 COLUMN GRID
// =============================================================

  Widget _newRestaurantItem({
    required MilestoneApp6Restaurant restaurant,
  }) {
    final ThemeData theme = Theme.of(context);

    final bool isDark = theme.brightness == Brightness.dark;

    final bool isClosed = !restaurant.isOpen;

    final Color cardColor = isClosed
        ? (isDark ? const Color(0xFF1C1C1C) : const Color(0xFFF5F5F5))
        : (isDark ? const Color(0xFF171717) : Colors.white);

    final Color titleColor = isClosed
        ? (isDark ? const Color(0xFF8A8A8A) : const Color(0xFF555555))
        : (isDark ? Colors.white : const Color(0xFF171717));

    final Color secondaryColor = isClosed
        ? (isDark ? const Color(0xFF777777) : const Color(0xFF888888))
        : (isDark ? const Color(0xFFB5B5B5) : const Color(0xFF666666));

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? Border.all(
                color: Colors.white.withOpacity(0.06),
              )
            : Border.all(
                color: const Color(0xFFEAEAEA),
              ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.30)
                : Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.push(
            '/restaurant-info',
            extra: <String, dynamic>{
              'restaurant': restaurant,
            },
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
// =======================================================
// RESTAURANT IMAGE
// =======================================================

            AspectRatio(
              aspectRatio: 1.35,
              child: Stack(
                fit: StackFit.expand,
                children: [
// IMAGE
                  isClosed
                      ? ColorFiltered(
                          colorFilter: const ColorFilter.matrix(
                            <double>[
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                            ],
                          ),
                          child: MilestoneApp6Image(
                            url: restaurant.image,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.zero,
                          ),
                        )
                      : MilestoneApp6Image(
                          url: restaurant.image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.zero,
                        ),

// =================================================
// CLOSED OVERLAY
// =================================================

                  if (isClosed)
                    Container(
                      color: Colors.black.withOpacity(
                        0.32,
                      ),
                    ),

// =================================================
// CLOSED LABEL
// =================================================

                  if (isClosed)
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.72),
                          borderRadius: BorderRadius.circular(
                            6,
                          ),
                        ),
                        child: const Text(
                          'CLOSED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

// =======================================================
// RESTAURANT DETAILS
// =======================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                10,
                9,
                10,
                10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
// =================================================
// RESTAURANT NAME
// =================================================

                  Text(
                    restaurant.name.trim().isEmpty
                        ? 'Restaurant'
                        : restaurant.name.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 6),

// =================================================
// STATUS + DISTANCE
// =================================================

                  Row(
                    children: [
// STATUS
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isClosed
                                  ? Icons.storefront_outlined
                                  : Icons.check_circle_rounded,
                              size: 12,
                              color: isClosed
                                  ? secondaryColor
                                  : const Color(
                                      0xFF2E9D55,
                                    ),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Flexible(
                              child: Text(
                                isClosed ? 'Closed' : 'Open',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

// DISTANCE
                      if (restaurant.distance.trim().isNotEmpty) ...[
                        const SizedBox(width: 5),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 12,
                                color: secondaryColor,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Flexible(
                                child: Text(
                                  restaurant.distance.trim(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 7),

// =================================================
// ADDRESS
// =================================================

                  if (restaurant.address.trim().isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_city_outlined,
                          size: 12,
                          color: secondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            restaurant.address.trim(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 10,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 8),

// =================================================
// CATEGORY
// =================================================

                  if (restaurant.menus.isNotEmpty)
                    Text(
                      restaurant.menus
                          .map(
                            (menu) => menu.name.trim(),
                          )
                          .where(
                            (name) => name.isNotEmpty,
                          )
                          .toSet()
                          .take(2)
                          .join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 10,
                        height: 1.2,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// ==============================================================
// RESTAURANT ITEM
// ==============================================================

  Widget _restaurantItem({
    required MilestoneApp6Restaurant restaurant,
    bool showFoodCards = true,
  }) {
    return AnimatedBuilder(
      animation: widget.state,
      builder: (context, child) {
        final ThemeData theme = Theme.of(context);
        final bool isDark = theme.brightness == Brightness.dark;

        final bool isClosed = !restaurant.isOpen;

        final List<_ApiFoodEntry> restaurantFoods =
            _filteredRestaurantApiFoods(restaurant);

// When a category/search is selected, don't show a restaurant
// that has no matching API food/menu item.
        if (restaurantFoods.isEmpty &&
            (_selectedCategory.toLowerCase() != 'all' ||
                _searchController.text.trim().isNotEmpty)) {
          return const SizedBox.shrink();
        }

        final Color cardColor = isClosed
            ? (isDark ? const Color(0xFF1C1C1C) : const Color(0xFFF5F5F5))
            : (isDark ? const Color(0xFF171717) : theme.colorScheme.surface);

        final Color titleColor = isClosed
            ? (isDark ? const Color(0xFF858585) : const Color(0xFF555555))
            : (isDark ? Colors.white : Colors.black);

        final Color secondaryColor = isClosed
            ? (isDark ? const Color(0xFF777777) : const Color(0xFF888888))
            : (isDark ? const Color(0xFFB5B5B5) : const Color(0xFF666666));

        return Container(
          margin: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            24,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: isDark
                ? Border.all(
                    color: Colors.white.withOpacity(0.06),
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(.35)
                    : Colors.black.withOpacity(.07),
                blurRadius: isDark ? 16 : 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              context.push(
                '/restaurant/${Uri.encodeComponent(restaurant.name)}',
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
// ------------------------------------------------------
// RESTAURANT IMAGE
// ------------------------------------------------------

                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: isClosed
                      ? ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0,
                            0,
                            0,
                            1,
                            0,
                          ]),
                          child: MilestoneApp6Image(
                            url: restaurant.image,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.zero,
                          ),
                        )
                      : MilestoneApp6Image(
                          url: restaurant.image,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.zero,
                        ),
                ),

// ------------------------------------------------------
// RESTAURANT INFORMATION
// ------------------------------------------------------

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    14,
                    11,
                    14,
                    14,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            restaurant.isOpen ? 'Open' : 'Closed',
                            style: TextStyle(
                              color: restaurant.isOpen
                                  ? const Color(0xFF00A651)
                                  : const Color(0xFFE53935),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '•',
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (restaurant.distance.isNotEmpty)
                            Text(
                              restaurant.distance,
                              style: TextStyle(
                                color: isClosed
                                    ? const Color(0xFF888888)
                                    : (isDark
                                        ? const Color(0xFFBDBDBD)
                                        : const Color(0xFF555555)),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      if (restaurant.cuisine.isNotEmpty)
                        Text(
                          restaurant.cuisine,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      if (restaurant.address.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 15,
                              color: isDark
                                  ? const Color(0xFF9E9E9E)
                                  : const Color(0xFF777777),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                restaurant.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

// ------------------------------------------------
// API FOOD CARDS
// ------------------------------------------------

                      if (showFoodCards && restaurantFoods.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 250,
                          child: ListView.separated(
                            padding: const EdgeInsets.only(
                              bottom: 5,
                            ),
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: restaurantFoods.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final _ApiFoodEntry entry =
                                  restaurantFoods[index];

                              return SizedBox(
                                width: 190,
                                child: _buildApiFoodCard(
                                  entry: entry,
                                  restaurant: restaurant,
                                ),
                              );
                            },
                          ),
                        ),
                      ],

// ------------------------------------------------
// NO API FOOD
// ------------------------------------------------

                      if (showFoodCards && restaurantFoods.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 4,
                          ),
                          child: Text(
                            'Explore the menu to discover delicious dishes.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// ==============================================================
// API FOOD CARD
// ==============================================================

  Widget _buildApiFoodCard({
    required _ApiFoodEntry entry,
    required MilestoneApp6Restaurant restaurant,
  }) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final MilestoneApp6MenuItem item = entry.item;

    final bool isAvailable = item.availability && restaurant.isOpen;

    final Color cardColor = isDark ? const Color(0xFF202020) : Colors.white;

    final Color titleColor = isDark ? Colors.white : const Color(0xFF171717);

    final Color secondaryColor =
        isDark ? const Color(0xFFBDBDBD) : const Color(0xFF666666);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? Border.all(
                color: Colors.white.withOpacity(0.06),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              isDark ? 0.25 : 0.06,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isAvailable
            ? () {
                context.push('/food/${item.id}');
              }
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 125,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MilestoneApp6Image(
                    url: item.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.zero,
                  ),
                  if (!isAvailable)
                    Container(
                      color: Colors.black.withOpacity(0.45),
                      alignment: Alignment.center,
                      child: const Text(
                        'Unavailable',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                10,
                12,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    entry.menu.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.price.isEmpty ? '₹0' : '₹${item.price}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Icon(
                        isAvailable
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 18,
                        color: isAvailable
                            ? const Color(0xFF00A651)
                            : const Color(0xFFE53935),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// ==============================================================
// BUILD
// ==============================================================

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _homeScrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: _refreshHome,
        ),
// ==========================================================
// APP BAR
// ==========================================================

        SliverAppBar(
          pinned: false,
          floating: false,
          snap: false,
          expandedHeight: 110,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,

          title: const Text(
            'Foodie',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),

// --------------------------------------------------------
// ADDRESS
// --------------------------------------------------------

          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 12,
              ),
              child: GestureDetector(
                onTap: () async {
                  await context.push(
                    '/profile/address',
                  );

                  await _loadSelectedAddress();

                  await _loadNearbyRestaurants();
                },
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 145,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 17,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Flexible(
                        child: Text(
                          _selectedAddress.isEmpty
                              ? 'Add address'
                              : _selectedAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

// --------------------------------------------------------
// FLEXIBLE SPACE
// --------------------------------------------------------

          flexibleSpace: FlexibleSpaceBar(
            background: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Hi, Sakshi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      'What would you like to eat today?',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

// ==========================================================
// STICKY SEARCH + CATEGORY
// ==========================================================

        SliverPersistentHeader(
          pinned: true,
          delegate: MilestoneApp6HomeStickyHeaderDelegate(
            minHeight: 145,
            maxHeight: 145,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
// ------------------------------------------------
// SEARCH
// ------------------------------------------------

                  SizedBox(
                    height: 58,
                    child: _buildSearchBar(),
                  ),

// ------------------------------------------------
// CATEGORY
// ------------------------------------------------

                  SizedBox(
                    height: 86,
                    child: _buildCategoryRow(),
                  ),

                  Container(
                    height: 1,
                    color: Theme.of(context).dividerColor.withOpacity(.25),
                  ),
                ],
              ),
            ),
          ),
        ),

// ==========================================================
// RESTAURANT API LOADING
// ==========================================================

        if (_isLoadingRestaurants)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: LinearProgressIndicator(
                minHeight: 2,
              ),
            ),
          ),

// ==========================================================
// BANNER
// ==========================================================

        SliverToBoxAdapter(
          child: _banner(context),
        ),

// ==========================================================
// POPULAR RESTAURANTS
// ==========================================================
//
// SliverToBoxAdapter(
//   child: _sectionTitle(
//     context,
//     'Popular Restaurants',
//         () {
//       context.push(
//         '/restaurants',
//       );
//     },
//   ),
// ),
//
// SliverToBoxAdapter(
//   child:
//   _buildNearbyRestaurantsHorizontal(),
// ),

// ==========================================================
// ALL RESTAURANTS
// ==========================================================

        SliverToBoxAdapter(
          child: _sectionTitle(
            context,
            'All Restaurants',
            () {
              context.push(
                '/restaurants',
              );
            },
          ),
        ),

        SliverToBoxAdapter(
          child: _buildNearbyRestaurantsVertical(),
        ),

// ==========================================================
// EMPTY SEARCH
// ==========================================================

        if (_searchController.text.trim().isNotEmpty &&
            _filteredNearbyRestaurants.isEmpty)
          SliverToBoxAdapter(
            child: _buildEmptyFoodState(
              context,
            ),
          ),

// ==========================================================
// BOTTOM SPACE
// ==========================================================

        const SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
      ],
    );
  }

// ==============================================================
// CATEGORY ROW
// ==============================================================

  Widget _buildCategoryRow() {
    final List<String> apiCategories = _apiCategories;

    if (apiCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<String> categories = [
      'All',
      ...apiCategories,
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        final String categoryName = categories[index];

        final bool isAll = categoryName.toLowerCase() == 'all';

        final bool selected = isAll
            ? _selectedCategory.isEmpty
            : _selectedCategory.toLowerCase() == categoryName.toLowerCase();

// ----------------------------------------------------------
// ALL CATEGORY
// Use a fixed network image.
// ----------------------------------------------------------
        String categoryImage =
            'https://images.unsplash.com/photo-1547592180-85f173990554?w=300';

// ----------------------------------------------------------
// OTHER CATEGORIES
// Use image coming from API.
// ----------------------------------------------------------
        if (!isAll) {
          final MilestoneApp6Menu? selectedMenu =
              _findCategoryMenu(categoryName);

          if (selectedMenu != null && selectedMenu.menuItems.isNotEmpty) {
            final String apiImage = selectedMenu.menuItems.first.image.trim();

            if (apiImage.isNotEmpty) {
              categoryImage = apiImage;
            }
          }
        }

        return MilestoneApp6CategoryChip(
          category: MilestoneApp6Category(
            categoryName,
            categoryImage,
          ),
          selected: selected,
          onTap: () {
            setState(() {
              if (isAll) {
                _selectedCategory = '';
              } else {
                _selectedCategory = categoryName;
              }
            });
          },
        );
      },
    );
  }

  MilestoneApp6Menu? _findCategoryMenu(
    String categoryName,
  ) {
    for (final restaurant in _nearbyRestaurants) {
      for (final menu in restaurant.menus) {
        if (menu.name.trim().toLowerCase() ==
            categoryName.trim().toLowerCase()) {
          return menu;
        }
      }
    }

    return null;
  }

// ==============================================================
// EMPTY FOOD STATE
// ==============================================================

  Widget _buildEmptyFoodState(
    BuildContext context,
  ) {
    final ThemeData theme = Theme.of(context);

    final bool hasSearch = _searchController.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 50,
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 36,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'No food found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            hasSearch
                ? 'Try another search or category.'
                : 'No items are available in this category.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          if (hasSearch)
            OutlinedButton.icon(
              onPressed: _clearSearch,
              icon: const Icon(
                Icons.clear_rounded,
              ),
              label: const Text(
                'Clear Search',
              ),
            ),
        ],
      ),
    );
  }

// ==============================================================
// BANNER
// ==============================================================

  Widget _banner(
    BuildContext context,
  ) {
    final double width = MediaQuery.sizeOf(context).width;

    final bool isTablet = width >= 700;

    final double bannerHeight = isTablet ? 150.0 : 140.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        15,
        10,
        15,
        10,
      ),
      child: SizedBox(
        height: bannerHeight,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
// ----------------------------------------------------
// BACKGROUND
// ----------------------------------------------------

              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      MilestoneApp6Colors.green,
                      Color(
                        0xFFFCE4EC,
                      ),
                    ],
                  ),
                ),
              ),

// ----------------------------------------------------
// IMAGE
// ----------------------------------------------------

              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: isTablet ? width * .48 : width * .52,
                child: MilestoneApp6Image(
                  url:
                      'https://images.unsplash.com/photo-1550547660-d9450f859349?w=1000',
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.zero,
                ),
              ),

// ----------------------------------------------------
// OVERLAY
// ----------------------------------------------------

              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [
                          0.0,
                          0.38,
                          0.65,
                          1.0,
                        ],
                        colors: [
                          Colors.black.withOpacity(
                            .40,
                          ),
                          Colors.black.withOpacity(
                            .25,
                          ),
                          Colors.black.withOpacity(
                            .08,
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

// ----------------------------------------------------
// CONTENT
// ----------------------------------------------------

              Positioned(
                left: 18,
                top: 15,
                bottom: 15,
                child: SizedBox(
                  width: isTablet ? width * .42 : width * .43,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delicious Food\nDelivered to You',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          height: 1.05,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          context.go(
                            '/categories',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: MilestoneApp6Colors.cream,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: const Text(
                            'Order Now',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// ==============================================================
// SECTION TITLE
// ==============================================================

  Widget _sectionTitle(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        14,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              'See All',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

// ==============================================================
// SEARCH BAR
// ==============================================================

  Widget _buildSearchBar() {
    return HomeSearchBar(
      controller: _searchController,
      searchHintIndex: _searchHintIndex,
      searchHints: _searchHints,
      isListening: _isListening,
      onMicTap: _toggleListening,
      onClear: _clearSearch,
    );
  }
}

// ==================================================================
// STICKY HEADER DELEGATE
// ==================================================================

class MilestoneApp6HomeStickyHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final double minHeight;

  final double maxHeight;

  final Widget child;

  MilestoneApp6HomeStickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ClipRect(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: overlapsContent ? 3 : 0,
        shadowColor: Colors.black.withOpacity(
          .12,
        ),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(
    covariant MilestoneApp6HomeStickyHeaderDelegate oldDelegate,
  ) {
    return minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight ||
        child != oldDelegate.child;
  }
}
