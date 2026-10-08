import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../Address/data/address_storage/address_storage.dart';
import '../../Address/models/milestone_app_6_address_model.dart';
import '../../Login/auth_storage/auth_storage.dart';
import '../../state/milestone_app_6_state.dart';
import '../../Address/data/service/milestone_app_6_address_api.dart';
import '../data/service/milestone_app_6_restaurant_api.dart';
import '../data/milestone_app_6_restaurants_data.dart';

class MilestoneApp6HomeLogic {
  // ============================================================
  // CALLBACK
  // ============================================================

  final VoidCallback onChanged;
  final MilestoneApp6State appState;

  MilestoneApp6HomeLogic({
    required this.onChanged,
    required this.appState,
  });

  bool _mounted = false;

  void initialize() {
    _mounted = true;

    homeScrollController.addListener(
      onHomeScroll,
    );

    searchController.addListener(
      onSearchChanged,
    );

    loadUserName();
    loadSelectedAddress();

    searchHintTimer = Timer.periodic(
      const Duration(seconds: 3),
          (_) {
        if (!_mounted) {
          return;
        }

        if (searchController.text.trim().isEmpty &&
            !isListening) {
          searchHintIndex =
              (searchHintIndex + 1) %
                  searchHints.length;

          notify();
        }
      },
    );

    loadNearbyRestaurants();
  }

  // ============================================================
  // RESTAURANT STATE
  // ============================================================

  bool isLoadingRestaurants = false;

  String? restaurantError;

  List<MilestoneApp6Restaurant> nearbyRestaurants = [];

  final MilestoneApp6RestaurantApi restaurantApi =
  MilestoneApp6RestaurantApi();

  static const int restaurantPerPage = 6;

  int currentRestaurantPage = 0;

  int lastRestaurantPage = 1;

  int totalRestaurants = 0;

  int recordsLoaded = 0;

  bool hasMoreRestaurantPages = true;

  bool isLoadingMoreRestaurants = false;

  // ============================================================
  // ADDRESS STATE
  // ============================================================

  final MilestoneApp6AddressApi addressApi =
  MilestoneApp6AddressApi();

  MilestoneApp6Address? selectedApiAddress;

  bool isLoadingAddress = true;

  // ============================================================
  // SEARCH STATE
  // ============================================================

  final TextEditingController searchController =
  TextEditingController();

  Timer? searchHintTimer;

  int searchHintIndex = 0;

  final List<String> searchHints = [
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

  // ============================================================
  // CATEGORY STATE
  // ============================================================

  String selectedCategory = '';

  // ============================================================
  // SPEECH STATE
  // ============================================================

  final stt.SpeechToText speech =
  stt.SpeechToText();

  bool isListening = false;

  bool speechAvailable = false;

  // ============================================================
  // USER
  // ============================================================

  String fullname = 'User';

  // ============================================================
  // SCROLL
  // ============================================================

  final ScrollController homeScrollController =
  ScrollController();

  // ============================================================
  // FILTERED RESTAURANTS
  // ============================================================

  List<MilestoneApp6Restaurant>
  get filteredNearbyRestaurants {
    final String category =
    selectedCategory.trim().toLowerCase();

    final String searchQuery =
    searchController.text.trim().toLowerCase();

    return nearbyRestaurants.where((restaurant) {
      // --------------------------------------------------------
      // CATEGORY FILTER
      // --------------------------------------------------------

      if (category.isNotEmpty) {
        final bool categoryMatches =
        restaurant.menus.any(
              (menu) {
            return menu.name
                .trim()
                .toLowerCase() ==
                category &&
                menu.menuItems.isNotEmpty;
          },
        );

        if (!categoryMatches) {
          return false;
        }
      }

      // --------------------------------------------------------
      // SEARCH FILTER
      // --------------------------------------------------------

      if (searchQuery.isNotEmpty) {
        final bool restaurantNameMatches =
        restaurant.name
            .toLowerCase()
            .contains(searchQuery);

        final bool cuisineMatches =
        restaurant.cuisine
            .toLowerCase()
            .contains(searchQuery);

        final bool menuMatches =
        restaurant.menus.any(
              (menu) {
            if (menu.menuItems.isEmpty) {
              return false;
            }

            final bool menuNameMatches =
            menu.name
                .toLowerCase()
                .contains(searchQuery);

            final bool foodItemMatches =
            menu.menuItems.any(
                  (item) {
                return item.name
                    .toLowerCase()
                    .contains(searchQuery);
              },
            );

            return menuNameMatches ||
                foodItemMatches;
          },
        );

        if (!restaurantNameMatches &&
            !cuisineMatches &&
            !menuMatches) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // ============================================================
  // INITIALIZATION
  // ============================================================

  Future<void> loadUserName() async {
    final String? name =
    await AuthStorage.fullName;

    if (!_mounted) {
      return;
    }

    fullname =
    name == null || name.trim().isEmpty
        ? 'User'
        : name.trim();

    notify();
  }

  // ============================================================
  // HOME SCROLL
  // ============================================================

  void onHomeScroll() {
    if (!homeScrollController.hasClients) {
      return;
    }

    final ScrollPosition position =
        homeScrollController.position;

    if (position.pixels >=
        position.maxScrollExtent - 500) {
      loadNextRestaurantPage();
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshHome() async {
    if (!_mounted) {
      return;
    }

    selectedCategory = '';

    notify();

    await loadSelectedAddress();

    await loadNearbyRestaurants();
  }

  // ============================================================
  // LOAD SELECTED ADDRESS
  // ============================================================

  Future<void> loadSelectedAddress() async {
    if (!_mounted) {
      return;
    }

    isLoadingAddress = true;

    notify();

    try {
      final String? token =
      await AuthStorage.token;

      if (token == null ||
          token.trim().isEmpty) {
        if (!_mounted) {
          return;
        }

        selectedApiAddress = null;
        isLoadingAddress = false;

        notify();

        return;
      }

      final List<MilestoneApp6Address>
      addresses =
      await addressApi.fetchAddresses(
        token: token,
      );

      final int? selectedAddressId =
          AddressStorage.selectedAddressId;

      MilestoneApp6Address? selectedAddress;

      if (selectedAddressId != null &&
          selectedAddressId > 0) {
        for (final address in addresses) {
          if (address.id ==
              selectedAddressId) {
            selectedAddress = address;
            break;
          }
        }
      }

      if (selectedAddress == null &&
          addresses.isNotEmpty) {
        selectedAddress = addresses.first;

        await AddressStorage
            .saveSelectedAddressId(
          selectedAddress.id,
        );
      }

      if (selectedAddress != null) {
        appState.setAddress(
          selectedAddress,
        );
      }

      if (!_mounted) {
        return;
      }

      selectedApiAddress =
          selectedAddress;

      isLoadingAddress = false;

      debugPrint(
        'HOME SELECTED ADDRESS ID: '
            '${selectedAddress?.id}',
      );

      debugPrint(
        'HOME ADDRESS LABEL: '
            '${selectedAddress?.label}',
      );

      debugPrint(
        'HOME FULL ADDRESS: '
            '${selectedAddress?.fullAddress}',
      );

      notify();
    } catch (e) {
      debugPrint(
        'HOME ADDRESS API ERROR: $e',
      );

      if (!_mounted) {
        return;
      }

      selectedApiAddress = null;
      isLoadingAddress = false;

      notify();
    }
  }

  // ============================================================
  // LOAD RESTAURANTS - PAGE 1
  // ============================================================

  Future<void> loadNearbyRestaurants() async {
    if (!_mounted) {
      return;
    }

    isLoadingRestaurants = true;
    restaurantError = null;
    nearbyRestaurants = [];

    currentRestaurantPage = 0;
    lastRestaurantPage = 1;
    totalRestaurants = 0;
    recordsLoaded = 0;

    hasMoreRestaurantPages = true;
    isLoadingMoreRestaurants = false;
    selectedCategory = '';

    notify();

    try {
      final String? token =
      await AuthStorage.token;

      if (token == null ||
          token.trim().isEmpty) {
        throw Exception(
          'Authentication token is missing.',
        );
      }

      final int? addressId =
          AddressStorage.selectedAddressId;

      if (addressId == null ||
          addressId <= 0) {
        throw Exception(
          'Please select an address first.',
        );
      }

      final response =
      await restaurantApi
          .fetchNearbyRestaurantsPage(
        token: token,
        addressId: addressId,
        page: 1,
        perPage: restaurantPerPage,
        openNow: false,
        includeMenus: true,
      );

      final List<MilestoneApp6Restaurant>
      restaurants =
      response.data
          .map(
            (json) =>
            MilestoneApp6Restaurant
                .fromJson(json),
      )
          .toList();

      if (!_mounted) {
        return;
      }

      nearbyRestaurants = restaurants;

      currentRestaurantPage =
          response.currentPage;

      lastRestaurantPage =
          response.lastPage;

      totalRestaurants =
          response.total;

      recordsLoaded =
          response.recordsLoaded;

      hasMoreRestaurantPages =
          response.hasMorePages;

      isLoadingRestaurants = false;

      restaurantError = null;

      debugPrint(
        'RESTAURANT PAGE: '
            '${response.currentPage}',
      );

      debugPrint(
        'RESTAURANT PER PAGE: '
            '${response.perPage}',
      );

      debugPrint(
        'RESTAURANT COUNT: '
            '${response.count}',
      );

      debugPrint(
        'RESTAURANT TOTAL: '
            '${response.total}',
      );

      debugPrint(
        'RESTAURANT HAS MORE: '
            '${response.hasMorePages}',
      );

      notify();
    } catch (e) {
      debugPrint(
        'LOAD RESTAURANTS ERROR: $e',
      );

      if (!_mounted) {
        return;
      }

      isLoadingRestaurants = false;

      restaurantError = e.toString();

      nearbyRestaurants = [];

      hasMoreRestaurantPages = false;

      notify();
    }
  }

  // ============================================================
  // LOAD NEXT RESTAURANT PAGE
  // ============================================================

  Future<void> loadNextRestaurantPage() async {
    if (isLoadingMoreRestaurants ||
        !hasMoreRestaurantPages) {
      return;
    }

    if (!_mounted) {
      return;
    }

    isLoadingMoreRestaurants = true;

    notify();

    try {
      final String? token =
      await AuthStorage.token;

      final int? addressId =
          AddressStorage.selectedAddressId;

      if (token == null ||
          token.trim().isEmpty ||
          addressId == null ||
          addressId <= 0) {
        return;
      }

      final int nextPage =
          currentRestaurantPage + 1;

      if (nextPage > lastRestaurantPage) {
        if (_mounted) {
          hasMoreRestaurantPages = false;
          notify();
        }

        return;
      }

      final response =
      await restaurantApi
          .fetchNearbyRestaurantsPage(
        token: token,
        addressId: addressId,
        page: nextPage,
        perPage: restaurantPerPage,
        openNow: false,
        includeMenus: true,
      );

      final List<MilestoneApp6Restaurant>
      newRestaurants =
      response.data
          .map(
            (json) =>
            MilestoneApp6Restaurant
                .fromJson(json),
      )
          .toList();

      if (!_mounted) {
        return;
      }

      nearbyRestaurants.addAll(
        newRestaurants,
      );

      currentRestaurantPage =
          response.currentPage;

      lastRestaurantPage =
          response.lastPage;

      totalRestaurants =
          response.total;

      recordsLoaded =
          response.recordsLoaded;

      hasMoreRestaurantPages =
          response.hasMorePages;

      debugPrint(
        'RESTAURANT PAGE: '
            '$currentRestaurantPage / '
            '$lastRestaurantPage',
      );

      debugPrint(
        'RESTAURANTS LOADED: '
            '$recordsLoaded / '
            '$totalRestaurants',
      );

      notify();
    } catch (e) {
      debugPrint(
        'LOAD NEXT RESTAURANT PAGE ERROR: $e',
      );
    } finally {
      if (_mounted) {
        isLoadingMoreRestaurants = false;
        notify();
      }
    }
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  List<String> get apiCategories {
    final Map<String, String>
    categoryNames = {};

    for (final restaurant
    in nearbyRestaurants) {
      for (final menu
      in restaurant.menus) {
        if (menu.menuItems.isEmpty) {
          continue;
        }

        final String name =
        menu.name.trim();

        if (name.isEmpty) {
          continue;
        }

        categoryNames.putIfAbsent(
          name.toLowerCase(),
              () => name,
        );
      }
    }

    return categoryNames.values.toList();
  }

  MilestoneApp6Menu? findCategoryMenu(
      String categoryName,
      ) {
    for (final restaurant
    in nearbyRestaurants) {
      for (final menu
      in restaurant.menus) {
        if (menu.name
            .trim()
            .toLowerCase() ==
            categoryName
                .trim()
                .toLowerCase() &&
            menu.menuItems.isNotEmpty) {
          return menu;
        }
      }
    }

    return null;
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void onSearchChanged() {
    if (!_mounted) {
      return;
    }

    notify();
  }

  void clearSearch() {
    searchController.clear();
  }

  // ============================================================
  // SPEECH INITIALIZATION
  // ============================================================

  Future<void> initializeSpeech({
    required VoidCallback onUnavailable,
  }) async {
    final bool available =
    await speech.initialize(
      onStatus: (status) {
        if (!_mounted) {
          return;
        }

        if (status == 'done' ||
            status == 'notListening') {
          isListening = false;
          notify();
        }
      },
      onError: (error) {
        if (!_mounted) {
          return;
        }

        isListening = false;

        debugPrint(
          'SPEECH ERROR: $error',
        );

        notify();
      },
    );

    if (!_mounted) {
      return;
    }

    speechAvailable = available;

    notify();
  }

  // ============================================================
  // SPEECH TO TEXT
  // ============================================================

  Future<void> toggleListening({
    required VoidCallback onUnavailable,
  }) async {
    if (!speechAvailable) {
      await initializeSpeech(
        onUnavailable: onUnavailable,
      );

      if (!speechAvailable) {
        if (!_mounted) {
          return;
        }

        onUnavailable();

        return;
      }
    }

    if (isListening) {
      await speech.stop();

      if (!_mounted) {
        return;
      }

      isListening = false;

      notify();

      return;
    }

    isListening = true;

    notify();

    await speech.listen(
      listenMode: stt.ListenMode.search,
      partialResults: true,
      onResult: (result) {
        if (!_mounted) {
          return;
        }

        final String words =
            result.recognizedWords;

        searchController.value =
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

  // ============================================================
  // CATEGORY SELECTION
  // ============================================================

  void selectCategory(
      String? category,
      ) {
    selectedCategory =
        category ?? '';

    notify();
  }

  // ============================================================
  // UPDATE STATE
  // ============================================================

  void notify() {
    if (_mounted) {
      onChanged();
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  Future<void> dispose() async {
    _mounted = false;

    searchHintTimer?.cancel();

    homeScrollController.removeListener(
      onHomeScroll,
    );

    searchController.removeListener(
      onSearchChanged,
    );

    homeScrollController.dispose();

    searchController.dispose();

    if (isListening) {
      await speech.stop();
    }
  }
}