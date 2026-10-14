
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../Address/data/address_storage/address_storage.dart';
import '../../Login/auth_storage/auth_storage.dart';
import '../data/service/milestone_app_6_restaurant_api.dart';
import '../data/milestone_app_6_restaurants_data.dart';
import '../../state/milestone_app_6_state.dart';
import '../widgets/RestaurantShimmerCard.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Home/widgets/milestone_app_6_home_restaurant_card.dart';

class MilestoneApp6RestaurantsScreen extends StatefulWidget {
  final MilestoneApp6State state;

  const MilestoneApp6RestaurantsScreen({
    super.key,
    required this.state,
  });

  @override
  State<MilestoneApp6RestaurantsScreen> createState() =>
      _MilestoneApp6RestaurantsScreenState();
}

class _MilestoneApp6RestaurantsScreenState
    extends State<MilestoneApp6RestaurantsScreen> {
// ================================================================
// API
// ================================================================

  final MilestoneApp6RestaurantApi _restaurantApi =
  MilestoneApp6RestaurantApi();

// ================================================================
// RESTAURANTS
// ================================================================

  final List<MilestoneApp6Restaurant> _restaurants =
  <MilestoneApp6Restaurant>[];

// ================================================================
// LOADING
// ================================================================

  bool _isLoadingRestaurants = true;

  bool _isLoadingMoreRestaurants = false;

  String? _restaurantError;

// ================================================================
// PAGINATION
// ================================================================

  static const int _restaurantPerPage = 10;

  int _currentRestaurantPage = 0;

  int _lastRestaurantPage = 1;

  int _totalRestaurants = 0;

  int _recordsLoaded = 0;

  bool _hasMoreRestaurantPages = true;

// ================================================================
// SCROLL
// ================================================================

  final ScrollController _scrollController = ScrollController();

// ================================================================
// INIT
// ================================================================

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(
      _onScroll,
    );

    _loadRestaurants();
  }

// ================================================================
// DISPOSE
// ================================================================

  @override
  void dispose() {
    _scrollController.removeListener(
      _onScroll,
    );

    _scrollController.dispose();

    super.dispose();
  }

// ================================================================
// SCROLL LISTENER
// ================================================================

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

// Load next page when user is close to bottom.
    if (position.pixels >= position.maxScrollExtent - 300) {
      _loadNextRestaurantPage();
    }
  }

// ================================================================
// LOAD FIRST PAGE
// ================================================================

  Future<void> _loadRestaurants() async {
    if (!mounted) {
      return;
    }

    setState(() {
// --------------------------------------------------------------
// FIRST LOAD SHIMMER
// --------------------------------------------------------------

      _isLoadingRestaurants = true;
      _restaurantError = null;

      _restaurants.clear();

      _currentRestaurantPage = 0;
      _lastRestaurantPage = 1;

      _totalRestaurants = 0;
      _recordsLoaded = 0;

      _hasMoreRestaurantPages = true;
      _isLoadingMoreRestaurants = false;
    });

    try {
// --------------------------------------------------------------
// TOKEN
// --------------------------------------------------------------

      final String? token = await AuthStorage.token;

      if (token == null || token.trim().isEmpty) {
        throw Exception(
          'Authentication token is missing. Please login again.',
        );
      }

// --------------------------------------------------------------
// ADDRESS
// --------------------------------------------------------------

      final int? addressId = await AddressStorage.selectedAddressId;

      if (addressId == null || addressId <= 0) {
        throw Exception(
          'Please select an address first.',
        );
      }

// --------------------------------------------------------------
// API
// --------------------------------------------------------------

      debugPrint(
        '========================================',
      );

      debugPrint(
        'RESTAURANTS SCREEN API',
      );

      debugPrint(
        'ADDRESS ID: $addressId',
      );

      debugPrint(
        'PAGE: 1',
      );

      debugPrint(
        '========================================',
      );

      final response = await _restaurantApi.fetchNearbyRestaurantsPage(
        token: token,
        addressId: addressId,
        page: 1,
        perPage: _restaurantPerPage,
        openNow: false,
        includeMenus: true,
      );

// --------------------------------------------------------------
// CONVERT API DATA
// --------------------------------------------------------------

      final List<MilestoneApp6Restaurant> apiRestaurants = response.data
          .map(
            (json) => MilestoneApp6Restaurant.fromJson(
          json,
        ),
      )
          .toList();

      if (!mounted) {
        return;
      }

// --------------------------------------------------------------
// UPDATE FIRST PAGE
// --------------------------------------------------------------

      setState(() {
        _restaurants.addAll(
          apiRestaurants,
        );

        _currentRestaurantPage = response.currentPage;

        _lastRestaurantPage = response.lastPage;

        _totalRestaurants = response.total;

        _recordsLoaded = response.recordsLoaded;

        _hasMoreRestaurantPages = response.hasMorePages;

// ------------------------------------------------------------
// HIDE FIRST-LOAD SHIMMER
// ------------------------------------------------------------

        _isLoadingRestaurants = false;

        _restaurantError = null;
      });

      debugPrint(
        'RESTAURANTS LOADED: ${apiRestaurants.length}',
      );

      debugPrint(
        'PAGE: ${response.currentPage}',
      );

      debugPrint(
        'LAST PAGE: ${response.lastPage}',
      );

      debugPrint(
        'TOTAL: ${response.total}',
      );

      debugPrint(
        'RECORDS LOADED: ${response.recordsLoaded}',
      );

      debugPrint(
        'HAS MORE: ${response.hasMorePages}',
      );
    } catch (e) {
      debugPrint(
        'RESTAURANT API ERROR: $e',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingRestaurants = false;

        _restaurantError = e.toString();

        _restaurants.clear();

        _hasMoreRestaurantPages = false;
      });
    }
  }

// ================================================================
// LOAD NEXT PAGE
// ================================================================

  Future<void> _loadNextRestaurantPage() async {
    if (_isLoadingMoreRestaurants ||
        !_hasMoreRestaurantPages ||
        _isLoadingRestaurants) {
      return;
    }

    setState(() {
// --------------------------------------------------------------
// PAGINATION SHIMMER
// --------------------------------------------------------------

      _isLoadingMoreRestaurants = true;
    });

    try {
// --------------------------------------------------------------
// TOKEN
// --------------------------------------------------------------

      final String? token = await AuthStorage.token;

// --------------------------------------------------------------
// ADDRESS
// --------------------------------------------------------------

      final int? addressId = await AddressStorage.selectedAddressId;

      if (token == null ||
          token.trim().isEmpty ||
          addressId == null ||
          addressId <= 0) {
        if (!mounted) {
          return;
        }

        setState(() {
          _isLoadingMoreRestaurants = false;
          _hasMoreRestaurantPages = false;
        });

        return;
      }

      final int nextPage = _currentRestaurantPage + 1;

// --------------------------------------------------------------
// LAST PAGE CHECK
// --------------------------------------------------------------

      if (nextPage > _lastRestaurantPage) {
        if (!mounted) {
          return;
        }

        setState(() {
          _hasMoreRestaurantPages = false;
          _isLoadingMoreRestaurants = false;
        });

        return;
      }

// --------------------------------------------------------------
// DEBUG
// --------------------------------------------------------------

      debugPrint(
        '========================================',
      );

      debugPrint(
        'LOADING NEXT RESTAURANT PAGE',
      );

      debugPrint(
        'PAGE: $nextPage',
      );

      debugPrint(
        '========================================',
      );

// --------------------------------------------------------------
// API
// --------------------------------------------------------------

      final response = await _restaurantApi.fetchNearbyRestaurantsPage(
        token: token,
        addressId: addressId,
        page: nextPage,
        perPage: _restaurantPerPage,
        openNow: false,
        includeMenus: true,
      );

// --------------------------------------------------------------
// CONVERT API DATA
// --------------------------------------------------------------

      final List<MilestoneApp6Restaurant> newRestaurants = response.data
          .map(
            (json) => MilestoneApp6Restaurant.fromJson(
          json,
        ),
      )
          .toList();

      if (!mounted) {
        return;
      }

// --------------------------------------------------------------
// ADD NEW RESTAURANTS
// --------------------------------------------------------------

      setState(() {
        _restaurants.addAll(
          newRestaurants,
        );

        _currentRestaurantPage = response.currentPage;

        _lastRestaurantPage = response.lastPage;

        _totalRestaurants = response.total;

        _recordsLoaded = response.recordsLoaded;

        _hasMoreRestaurantPages = response.hasMorePages;

// ------------------------------------------------------------
// HIDE PAGINATION SHIMMER
// ------------------------------------------------------------

        _isLoadingMoreRestaurants = false;
      });

      debugPrint(
        'NEW RESTAURANTS: ${newRestaurants.length}',
      );

      debugPrint(
        'CURRENT PAGE: $_currentRestaurantPage',
      );

      debugPrint(
        'LAST PAGE: $_lastRestaurantPage',
      );

      debugPrint(
        'TOTAL: $_totalRestaurants',
      );

      debugPrint(
        'HAS MORE: $_hasMoreRestaurantPages',
      );
    } catch (e) {
      debugPrint(
        'NEXT PAGE ERROR: $e',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingMoreRestaurants = false;
      });
    }
  }

// ================================================================
// REFRESH
// ================================================================

  Future<void> _refreshRestaurants() async {
    await _loadRestaurants();
  }

// ================================================================
// OPEN RESTAURANT
// ================================================================

  void _openRestaurant(
      BuildContext context,
      MilestoneApp6Restaurant restaurant,
      ) {
// IMPORTANT:
// Pass the actual API restaurant object.
//
// Do NOT navigate using restaurant name.
// Do NOT search a static restaurants list.

    context.push(
      '/restaurant-info',
      extra: <String, dynamic>{
        'restaurant': restaurant,
      },
    );
  }

// ================================================================
// BUILD
// ================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final width = MediaQuery.sizeOf(context).width;

    final isTablet = width >= 700;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Popular Restaurants',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _buildBody(
        context,
        theme,
        isTablet,
      ),
    );
  }

// ================================================================
// BODY
// ================================================================

  Widget _buildBody(
      BuildContext context,
      ThemeData theme,
      bool isTablet,
      ) {
// --------------------------------------------------------------
// INITIAL LOADING
// --------------------------------------------------------------

    if (_isLoadingRestaurants && _restaurants.isEmpty) {
      return const MilestoneApp6RestaurantShimmer(
        itemCount: 6,
      );
    }

// --------------------------------------------------------------
// ERROR
// --------------------------------------------------------------

    if (_restaurantError != null && _restaurants.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshRestaurants,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.65,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 56,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Unable to load restaurants',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        _restaurantError!.replaceFirst(
                          'Exception: ',
                          '',
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.hintColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FilledButton(
                        onPressed: _loadRestaurants,
                        child: const Text(
                          'Retry',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

// --------------------------------------------------------------
// EMPTY
// --------------------------------------------------------------

    if (_restaurants.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshRestaurants,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.65,
              child: const Center(
                child: Text(
                  'No restaurants found.',
                ),
              ),
            ),
          ],
        ),
      );
    }

// --------------------------------------------------------------
// API RESTAURANTS
// --------------------------------------------------------------

    return RefreshIndicator(
      onRefresh: _refreshRestaurants,
      child: GridView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          childAspectRatio: 0.76,
        ),
        itemCount: _restaurants.length + (_isLoadingMoreRestaurants ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _restaurants.length) {
            return const MilestoneApp6RestaurantShimmer();
          }

          final restaurant = _restaurants[index];

          final categories = restaurant.menus
              .where((menu) => menu.menuItems.isNotEmpty)
              .map((menu) => menu.name.trim())
              .where((name) => name.isNotEmpty)
              .toSet()
              .take(2)
              .join(' • ');

          return MilestoneApp6RestaurantCard(
            name: restaurant.name,
            image: restaurant.image,
            rating: restaurant.rating.toString(),
            time: '',
            isOpen: restaurant.isOpen,
            distance: restaurant.distance,
            address: restaurant.address,
            categories: categories,
            onTap: () => _openRestaurant(context, restaurant),
          );
        },
      ),
    );
  }

}
