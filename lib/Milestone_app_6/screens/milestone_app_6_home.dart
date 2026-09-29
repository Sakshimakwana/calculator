import 'dart:async';
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

class _MilestoneApp6HomeScreenState
    extends State<MilestoneApp6HomeScreen> {
  // ==============================================================
  // RESTAURANT API
  // ==============================================================

  bool _isLoadingRestaurants = false;

  String? _restaurantError;

  List<MilestoneApp6Restaurant> _nearbyRestaurants = [];

  final MilestoneApp6RestaurantApi _restaurantApi =
  MilestoneApp6RestaurantApi();

  // ==============================================================
// FILTERED API RESTAURANTS BY CATEGORY
// ==============================================================

  List<MilestoneApp6Restaurant> get _filteredNearbyRestaurants {
    final String selectedCategory =
    _selectedCategory.trim().toLowerCase();

    final String query =
    _searchController.text.trim().toLowerCase();

    return _nearbyRestaurants.where((restaurant) {
      // ------------------------------------------------------------
      // CATEGORY FILTER
      // ------------------------------------------------------------

      final bool matchesCategory =
          selectedCategory.isEmpty ||
              restaurant.menus.any(
                    (menu) =>
                menu.name.trim().toLowerCase() ==
                    selectedCategory,
              );

      if (!matchesCategory) {
        return false;
      }

      // ------------------------------------------------------------
      // SEARCH FILTER
      // ------------------------------------------------------------

      if (query.isEmpty) {
        return true;
      }

      // Search restaurant information
      final bool restaurantMatches =
          restaurant.name.toLowerCase().contains(query) ||
              restaurant.address.toLowerCase().contains(query) ||
              restaurant.cuisine.toLowerCase().contains(query);

      // Search API categories and food items
      final bool menuMatches =
      restaurant.menus.any((menu) {
        final bool categoryMatchesSearch =
        menu.name.toLowerCase().contains(query);

        final bool foodMatchesSearch =
        menu.menuItems.any((item) {
          return item.name.toLowerCase().contains(query);
        });

        return categoryMatchesSearch ||
            foodMatchesSearch;
      });

      return restaurantMatches || menuMatches;
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

  final TextEditingController _searchController =
  TextEditingController();

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

  final stt.SpeechToText _speech =
  stt.SpeechToText();

  bool _isListening = false;

  bool _speechAvailable = false;

  // ==============================================================
  // INIT
  // ==============================================================

  @override
  void initState() {
    super.initState();

    _loadSelectedAddress();

    _searchController.addListener(
      _onSearchChanged,
    );

    _searchHintTimer = Timer.periodic(
      const Duration(seconds: 3),
          (_) {
        if (!mounted) return;

        if (_searchController.text.trim().isEmpty &&
            !_isListening) {
          setState(() {
            _searchHintIndex =
                (_searchHintIndex + 1) %
                    _searchHints.length;
          });
        }
      },
    );

    _loadNearbyRestaurants();
  }

  // ==============================================================
  // LOAD SELECTED ADDRESS
  // ==============================================================

  Future<void> _loadSelectedAddress() async {
    final int? addressId =
        AddressStorage.selectedAddressId;

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

  Future<void> _loadNearbyRestaurants() async {
    if (!mounted) return;

    setState(() {
      _isLoadingRestaurants = true;
      _restaurantError = null;
    });

    try {
      // Get authentication token
      final String? token = await AuthStorage.token;

      if (token == null || token.trim().isEmpty) {
        throw Exception('Authentication token is missing.');
      }

      // Get selected address ID
      final int? addressId = await AddressStorage.selectedAddressId;

      if (addressId == null || addressId <= 0) {
        throw Exception('Please select an address first.');
      }

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('      LOAD NEARBY RESTAURANTS             ');
      debugPrint('==========================================');
      debugPrint('SELECTED ADDRESS ID: $addressId');
      debugPrint('==========================================');

      // Call Nearby Restaurants API
      final List<Map<String, dynamic>> response =
      await _restaurantApi.fetchNearbyRestaurants(
        token: token,
        addressId: addressId,
        page: 1,
        openNow: false,
        includeMenus: true,
      );

      debugPrint('');
      debugPrint('RAW RESTAURANT COUNT: ${response.length}');

      // Convert API response into Restaurant models
      final List<MilestoneApp6Restaurant> restaurants =
      response
          .map(
            (json) => MilestoneApp6Restaurant.fromJson(json),
      )
          .toList();

      debugPrint(
        'PARSED RESTAURANT COUNT: ${restaurants.length}',
      );

      // Debug Restaurant → Category/Menu → Food
      debugPrint('');
      debugPrint('========== PARSED RESTAURANT DATA ==========');

      for (final restaurant in restaurants) {
        debugPrint(
          'RESTAURANT: ${restaurant.name}',
        );

        debugPrint(
          'STATUS: ${restaurant.isOpen ? 'OPEN' : 'CLOSED'}',
        );

        debugPrint(
          'DISTANCE: ${restaurant.distance}',
        );

        debugPrint(
          'ADDRESS: ${restaurant.address}',
        );

        for (final menu in restaurant.menus) {
          debugPrint(
            'CATEGORY: ${menu.name}',
          );

          for (final item in menu.menuItems) {
            debugPrint(
              'FOOD: ${item.name} - ${item.price}',
            );

            debugPrint(
              'AVAILABLE: ${item.availability}',
            );
          }
        }

        debugPrint('--------------------------------------------');
      }

      debugPrint('============================================');

      if (!mounted) return;

      setState(() {
        // Keep BOTH open and closed restaurants.
        // Do NOT filter using restaurant.isOpen.
        _nearbyRestaurants = restaurants;

        _isLoadingRestaurants = false;
      });
    } catch (e) {
      debugPrint('');
      debugPrint('==========================================');
      debugPrint('   NEARBY RESTAURANT ERROR                ');
      debugPrint('==========================================');
      debugPrint(e.toString());
      debugPrint('==========================================');

      if (!mounted) return;

      setState(() {
        _isLoadingRestaurants = false;
        _restaurantError = e.toString();
      });
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

        categoryNames.putIfAbsent(key, () => name);
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
    final bool available =
    await _speech.initialize(
      onStatus: (status) {
        if (!mounted) return;

        if (status == 'done' ||
            status == 'notListening') {
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
              behavior:
              SnackBarBehavior.floating,
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

        final String words =
            result.recognizedWords;

        _searchController.value =
            TextEditingValue(
              text: words,
              selection:
              TextSelection.collapsed(
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
    final List<_ApiFoodEntry> foods =
    _restaurantApiFoods(restaurant);

    final String selectedCategory =
    _selectedCategory.trim().toLowerCase();

    if (selectedCategory.isEmpty) {
      return foods;
    }

    return foods.where((entry) {
      return entry.menu.name.trim().toLowerCase() ==
          selectedCategory;
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
  //       _filteredNearbyRestaurants.length,
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

  Widget _buildNearbyRestaurantsVertical() {
    // ------------------------------------------------------------
    // LOADING
    // ------------------------------------------------------------

    if (_isLoadingRestaurants) {
      return const Padding(
        padding:
        EdgeInsets.symmetric(
          vertical: 30,
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // ------------------------------------------------------------
    // ERROR
    // ------------------------------------------------------------

    if (_restaurantError != null) {
      return Padding(
        padding:
        const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 30,
        ),
        child: Column(
          children: [
            const Text(
              'Unable to load restaurants.',
              textAlign:
              TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed:
              _loadNearbyRestaurants,
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
        padding:
        const EdgeInsets.symmetric(
          vertical: 35,
          horizontal: 30,
        ),
        child: Column(
          children: [
            Icon(
              Icons
                  .restaurant_menu_rounded,
              size: 42,
              color: Theme.of(context)
                  .hintColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'No nearby restaurants found.',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .hintColor,
              ),
            ),
          ],
        ),
      );
    }

    // ------------------------------------------------------------
    // RESTAURANTS
    // ------------------------------------------------------------

    final List<MilestoneApp6Restaurant>
    restaurantsToShow =
        _filteredNearbyRestaurants;

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
              'No restaurants found for "$_selectedCategory".',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: restaurantsToShow.map(
            (restaurant) {
          return _newRestaurantItem(
            restaurant: restaurant,
          );
        },
      ).toList(),
    );
  }

  // ==============================================================
  // NEW RESTAURANT - ZOMATO STYLE
  // ==============================================================

  Widget _newRestaurantItem({
    required MilestoneApp6Restaurant restaurant,
  }) {
    final ThemeData theme =
    Theme.of(context);

    final bool isDark =
        theme.brightness ==
            Brightness.dark;

    final bool isClosed =
    !restaurant.isOpen;

    final Color cardColor =
    isClosed
        ? (isDark
        ? const Color(0xFF1C1C1C)
        : const Color(0xFFF5F5F5))
        : (isDark
        ? const Color(0xFF171717)
        : Colors.white);

    final Color titleColor =
    isClosed
        ? (isDark
        ? const Color(0xFF8A8A8A)
        : const Color(0xFF555555))
        : (isDark
        ? Colors.white
        : Colors.black);

    final Color secondaryColor =
    isClosed
        ? (isDark
        ? const Color(0xFF777777)
        : const Color(0xFF888888))
        : (isDark
        ? const Color(0xFFB5B5B5)
        : const Color(0xFF666666));

    final Color distanceColor =
    isClosed
        ? (isDark
        ? const Color(0xFF777777)
        : const Color(0xFF888888))
        : (isDark
        ? const Color(0xFFBDBDBD)
        : const Color(0xFF555555));

    return Container(
      margin:
      const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        18,
      ),
      decoration:
      BoxDecoration(
        color: cardColor,
        borderRadius:
        BorderRadius.circular(18),
        border: isDark
            ? Border.all(
          color: Colors.white
              .withOpacity(0.06),
        )
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black
                .withOpacity(0.35)
                : Colors.black
                .withOpacity(0.06),
            blurRadius:
            isDark ? 14 : 10,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior:
      Clip.antiAlias,
      child: InkWell(
        borderRadius:
        BorderRadius.circular(18),
        onTap: () {
          context.push(
            '/restaurant/${Uri.encodeComponent(
              restaurant.name,
            )}',
          );
        },
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------------
            // IMAGE
            // ------------------------------------------------------

            AspectRatio(
              aspectRatio: 1.75,
              child: isClosed
                  ? ColorFiltered(
                colorFilter:
                const ColorFilter
                    .matrix([
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
                child:
                MilestoneApp6Image(
                  url:
                  restaurant.image,
                  width:
                  double.infinity,
                  fit: BoxFit.cover,
                  borderRadius:
                  BorderRadius.zero,
                ),
              )
                  : MilestoneApp6Image(
                url:
                restaurant.image,
                width:
                double.infinity,
                fit: BoxFit.cover,
                borderRadius:
                BorderRadius.zero,
              ),
            ),

            // ------------------------------------------------------
            // INFORMATION
            // ------------------------------------------------------

            Padding(
              padding:
              const EdgeInsets.fromLTRB(
                14,
                12,
                14,
                15,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 20,
                      fontWeight:
                      FontWeight.w700,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Icon(
                        restaurant.isOpen
                            ? Icons
                            .check_circle_rounded
                            : Icons
                            .cancel_rounded,
                        size: 15,
                        color:
                        restaurant.isOpen
                            ? const Color(
                          0xFF00C853,
                        )
                            : const Color(
                          0xFFFF5252,
                        ),
                      ),

                      const SizedBox(
                        width: 4,
                      ),

                      Text(
                        restaurant.isOpen
                            ? 'Open'
                            : 'Closed',
                        style:
                        TextStyle(
                          color:
                          restaurant
                              .isOpen
                              ? const Color(
                            0xFF00C853,
                          )
                              : const Color(
                            0xFFFF5252,
                          ),
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      if (restaurant
                          .distance
                          .isNotEmpty) ...[
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          '•',
                          style:
                          TextStyle(
                            color: isDark
                                ? Colors.white38
                                : Colors.black45,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          restaurant.distance,
                          style:
                          TextStyle(
                            color:
                            distanceColor,
                            fontSize: 14,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  if (restaurant
                      .cuisine
                      .isNotEmpty)
                    Text(
                      restaurant.cuisine,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      TextStyle(
                        color:
                        secondaryColor,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),

                  if (restaurant
                      .address
                      .isNotEmpty) ...[
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Icon(
                          Icons
                              .location_on_rounded,
                          size: 15,
                          color: isDark
                              ? const Color(
                            0xFF9E9E9E,
                          )
                              : const Color(
                            0xFF777777,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            restaurant.address,
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            TextStyle(
                              color:
                              secondaryColor,
                              fontSize: 13,
                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
        final bool isDark =
            theme.brightness == Brightness.dark;

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
            ? (isDark
            ? const Color(0xFF1C1C1C)
            : const Color(0xFFF5F5F5))
            : (isDark
            ? const Color(0xFF171717)
            : theme.colorScheme.surface);

        final Color titleColor = isClosed
            ? (isDark
            ? const Color(0xFF858585)
            : const Color(0xFF555555))
            : (isDark ? Colors.white : Colors.black);

        final Color secondaryColor = isClosed
            ? (isDark
            ? const Color(0xFF777777)
            : const Color(0xFF888888))
            : (isDark
            ? const Color(0xFFB5B5B5)
            : const Color(0xFF666666));

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
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0,      0,      0,      1, 0,
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
                              color: isDark
                                  ? Colors.white54
                                  : Colors.black54,
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

                      if (showFoodCards &&
                          restaurantFoods.isNotEmpty) ...[
                        const SizedBox(height: 14),

                        SizedBox(
                          height: 250,
                          child: ListView.separated(
                            padding: const EdgeInsets.only(
                              bottom: 5,
                            ),
                            scrollDirection: Axis.horizontal,
                            physics:
                            const BouncingScrollPhysics(),
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

                      if (showFoodCards &&
                          restaurantFoods.isEmpty)
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
    final bool isDark =
        theme.brightness == Brightness.dark;

    final MilestoneApp6MenuItem item = entry.item;

    final bool isAvailable =
        item.availability && restaurant.isOpen;

    final Color cardColor = isDark
        ? const Color(0xFF202020)
        : Colors.white;

    final Color titleColor = isDark
        ? Colors.white
        : const Color(0xFF171717);

    final Color secondaryColor = isDark
        ? const Color(0xFFBDBDBD)
        : const Color(0xFF666666);

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
                          item.price.isEmpty
                              ? '₹0'
                              : '₹${item.price}',
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
      physics:
      const BouncingScrollPhysics(),
      slivers: [
        // ==========================================================
        // APP BAR
        // ==========================================================

        SliverAppBar(
          pinned: false,
          floating: false,
          snap: false,
          expandedHeight: 110,
          backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,
          surfaceTintColor:
          Colors.transparent,

          title: const Text(
            'Foodie',
            style: TextStyle(
              fontWeight:
              FontWeight.w700,
            ),
          ),

          // --------------------------------------------------------
          // ADDRESS
          // --------------------------------------------------------

          actions: [
            Padding(
              padding:
              const EdgeInsets.only(
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
                  constraints:
                  const BoxConstraints(
                    maxWidth: 145,
                  ),
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration:
                  BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.08),
                    borderRadius:
                    BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Icon(
                        Icons
                            .location_on_rounded,
                        size: 17,
                        color: Theme.of(
                          context,
                        )
                            .colorScheme
                            .primary,
                      ),

                      const SizedBox(
                        width: 4,
                      ),

                      Flexible(
                        child: Text(
                          _selectedAddress
                              .isEmpty
                              ? 'Add address'
                              : _selectedAddress,
                          maxLines: 1,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style:
                          TextStyle(
                            fontSize: 10,
                            fontWeight:
                            FontWeight.w700,
                            color: Theme.of(
                              context,
                            )
                                .colorScheme
                                .primary,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 2,
                      ),

                      Icon(
                        Icons
                            .keyboard_arrow_down_rounded,
                        size: 16,
                        color: Theme.of(
                          context,
                        )
                            .colorScheme
                            .primary,
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

          flexibleSpace:
          FlexibleSpaceBar(
            background: SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  0,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment:
                  MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Hi, Sakshi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    Text(
                      'What would you like to eat today?',
                      style: TextStyle(
                        fontSize: 11,
                        color:
                        Theme.of(context)
                            .hintColor,
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
          delegate:
          MilestoneApp6HomeStickyHeaderDelegate(
            minHeight: 145,
            maxHeight: 145,
            child: Container(
              color: Theme.of(context)
                  .scaffoldBackgroundColor,
              child: Column(
                children: [
                  // ------------------------------------------------
                  // SEARCH
                  // ------------------------------------------------

                  SizedBox(
                    height: 58,
                    child:
                    _buildSearchBar(),
                  ),

                  // ------------------------------------------------
                  // CATEGORY
                  // ------------------------------------------------

                  SizedBox(
                    height: 86,
                    child:
                    _buildCategoryRow(),
                  ),

                  Container(
                    height: 1,
                    color: Theme.of(context)
                        .dividerColor
                        .withOpacity(.25),
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
              padding:
              EdgeInsets.symmetric(
                vertical: 12,
              ),
              child:
              LinearProgressIndicator(
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
          child:
          _buildNearbyRestaurantsVertical(),
        ),

        // ==========================================================
        // EMPTY SEARCH
        // ==========================================================

        if (_searchController.text.trim().isNotEmpty &&
            _filteredNearbyRestaurants.isEmpty)
          SliverToBoxAdapter(
            child:
            _buildEmptyFoodState(
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
    final List<String> categories = _apiCategories;

    // No API categories
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    // If selected category no longer exists after API refresh,
    // select the first API category.
    if (!_selectedCategory.isNotEmpty ||
        !categories.any(
              (category) =>
          category.toLowerCase() ==
              _selectedCategory.toLowerCase(),
        )) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final String firstCategory = categories.first;

        if (_selectedCategory != firstCategory) {
          setState(() {
            _selectedCategory = firstCategory;
          });
        }
      });
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: categories.length,
      separatorBuilder: (_, __) {
        return const SizedBox(width: 10);
      },
      itemBuilder: (context, index) {
        final String categoryName = categories[index];

        final bool selected =
            _selectedCategory.toLowerCase() ==
                categoryName.toLowerCase();

        final MilestoneApp6Menu? selectedMenu =
        _findCategoryMenu(categoryName);

        return MilestoneApp6CategoryChip(
          category: MilestoneApp6Category(
            categoryName,
            selectedMenu?.image ?? '',
          ),
          selected: selected,
          onTap: () {
            setState(() {
              _selectedCategory = categoryName;
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
    final ThemeData theme =
    Theme.of(context);

    final bool hasSearch =
        _searchController.text
            .trim()
            .isNotEmpty;

    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 50,
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration:
            BoxDecoration(
              color: theme
                  .colorScheme
                  .primary
                  .withOpacity(.10),
              shape:
              BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 36,
              color: theme
                  .colorScheme
                  .primary,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          Text(
            'No food found',
            style: theme
                .textTheme
                .titleMedium
                ?.copyWith(
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            hasSearch
                ? 'Try another search or category.'
                : 'No items are available in this category.',
            textAlign:
            TextAlign.center,
            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color:
              theme.hintColor,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          if (hasSearch)
            OutlinedButton.icon(
              onPressed:
              _clearSearch,
              icon: const Icon(
                Icons.clear_rounded,
              ),
              label:
              const Text(
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
    final double width =
        MediaQuery.sizeOf(context)
            .width;

    final bool isTablet =
        width >= 700;

    final double bannerHeight =
    isTablet ? 150.0 : 140.0;

    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        15,
        10,
        15,
        10,
      ),
      child: SizedBox(
        height: bannerHeight,
        width: double.infinity,
        child: ClipRRect(
          borderRadius:
          BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ----------------------------------------------------
              // BACKGROUND
              // ----------------------------------------------------

              const DecoratedBox(
                decoration:
                BoxDecoration(
                  gradient:
                  LinearGradient(
                    begin:
                    Alignment.centerLeft,
                    end:
                    Alignment.centerRight,
                    colors: [
                      MilestoneApp6Colors
                          .green,
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
                width: isTablet
                    ? width * .48
                    : width * .52,
                child:
                MilestoneApp6Image(
                  url:
                  'https://images.unsplash.com/photo-1550547660-d9450f859349?w=1000',
                  fit: BoxFit.cover,
                  borderRadius:
                  BorderRadius.zero,
                ),
              ),

              // ----------------------------------------------------
              // OVERLAY
              // ----------------------------------------------------

              Positioned.fill(
                child: IgnorePointer(
                  child:
                  DecoratedBox(
                    decoration:
                    BoxDecoration(
                      gradient:
                      LinearGradient(
                        begin:
                        Alignment.centerLeft,
                        end:
                        Alignment.centerRight,
                        stops: const [
                          0.0,
                          0.38,
                          0.65,
                          1.0,
                        ],
                        colors: [
                          Colors.black
                              .withOpacity(
                            .40,
                          ),
                          Colors.black
                              .withOpacity(
                            .25,
                          ),
                          Colors.black
                              .withOpacity(
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
                  width: isTablet
                      ? width * .42
                      : width * .43,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      const Text(
                        'Delicious Food\nDelivered to You',
                        maxLines: 2,
                        overflow:
                        TextOverflow
                            .ellipsis,
                        style: TextStyle(
                          color:
                          Colors.white,
                          fontSize: 17,
                          height: 1.05,
                          fontWeight:
                          FontWeight.w800,
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
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 13,
                            vertical: 7,
                          ),
                          decoration:
                          BoxDecoration(
                            color:
                            MilestoneApp6Colors
                                .cream,
                            borderRadius:
                            BorderRadius
                                .circular(
                              10,
                            ),
                          ),
                          child:
                          const Text(
                            'Order Now',
                            style:
                            TextStyle(
                              color: Colors
                                  .black54,
                              fontSize: 10,
                              fontWeight:
                              FontWeight
                                  .w700,
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
      padding:
      const EdgeInsets.fromLTRB(
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
              overflow:
              TextOverflow.ellipsis,
              style:
              const TextStyle(
                fontWeight:
                FontWeight.w700,
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
                color: Theme.of(context)
                    .colorScheme
                    .primary,
                fontSize: 11,
                fontWeight:
                FontWeight.w600,
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
      controller:
      _searchController,
      searchHintIndex:
      _searchHintIndex,
      searchHints:
      _searchHints,
      isListening:
      _isListening,
      onMicTap:
      _toggleListening,
      onClear:
      _clearSearch,
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
  double get minExtent =>
      minHeight;

  @override
  double get maxExtent =>
      maxHeight;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return ClipRect(
      child: Material(
        color: Theme.of(context)
            .scaffoldBackgroundColor,
        elevation:
        overlapsContent ? 3 : 0,
        shadowColor:
        Colors.black.withOpacity(
          .12,
        ),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(
      covariant
      MilestoneApp6HomeStickyHeaderDelegate
      oldDelegate,
      ) {
    return minHeight !=
        oldDelegate.minHeight ||
        maxHeight !=
            oldDelegate.maxHeight ||
        child !=
            oldDelegate.child;
  }
}