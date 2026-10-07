import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Home/data/milestone_app_6_restaurants_data.dart';
import '../../core/constants/api_constants.dart';
import '../Login/auth_storage/auth_storage.dart';
import '../Home/models/restaurant_menu_model.dart';

class MilestoneApp6RestaurantDetailScreen
    extends StatefulWidget {
  final MilestoneApp6Restaurant restaurant;

  const MilestoneApp6RestaurantDetailScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<MilestoneApp6RestaurantDetailScreen> createState() =>
      _MilestoneApp6RestaurantDetailScreenState();
}

class _MilestoneApp6RestaurantDetailScreenState
    extends State<MilestoneApp6RestaurantDetailScreen> {
  bool _isLoading = true;

  String? _error;

  List<RestaurantMenu> _menus = [];

  @override
  void initState() {
    super.initState();

    _loadRestaurantMenu();
  }

  // ============================================================
  // LOAD RESTAURANT MENU API
  // ============================================================

  Future<void> _loadRestaurantMenu() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final String? token =
      await AuthStorage.token;

      if (token == null ||
          token.trim().isEmpty) {
        throw Exception(
          'Authentication token is missing.',
        );
      }

      if (widget.restaurant.id <= 0) {
        throw Exception(
          'Invalid restaurant ID.',
        );
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}'
            '${ApiConstants.restaurantMenus(
          widget.restaurant.id,
        )}',
      );

      debugPrint(
        '==========================================',
      );

      debugPrint(
        'RESTAURANT MENU API',
      );

      debugPrint(
        'Restaurant ID: ${widget.restaurant.id}',
      );

      debugPrint(
        'Restaurant Name: ${widget.restaurant.name}',
      );

      debugPrint(
        'URL: $uri',
      );

      debugPrint(
        '==========================================',
      );

      final http.Response response =
      await http
          .get(
        uri,
        headers: {
          'Authorization':
          'Bearer $token',

          'Accept':
          'application/json',

          'Content-Type':
          'application/json',
        },
      )
          .timeout(
        const Duration(
          seconds: 30,
        ),
      );

      debugPrint(
        'MENU API STATUS: ${response.statusCode}',
      );

      debugPrint(
        'MENU API RESPONSE: ${response.body}',
      );

      if (response.statusCode == 401) {
        throw Exception(
          'Unauthorized. Please login again.',
        );
      }

      if (response.statusCode == 404) {
        throw Exception(
          'Restaurant menu not found.',
        );
      }

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          'Menu API failed with status '
              '${response.statusCode}.',
        );
      }

      if (response.body.trim().isEmpty) {
        setState(() {
          _menus = [];
          _isLoading = false;
        });

        return;
      }

      final dynamic decoded =
      jsonDecode(response.body);

      if (decoded
      is! Map<String, dynamic>) {
        throw Exception(
          'Invalid menu API response.',
        );
      }

      final RestaurantMenuResponse
      menuResponse =
      RestaurantMenuResponse.fromJson(
        decoded,
      );

      if (!mounted) return;

      setState(() {
        _menus = menuResponse.data;
        _isLoading = false;
      });

      // ========================================================
      // DEBUG
      // ========================================================

      for (final menu in _menus) {
        debugPrint(
          'CATEGORY: ${menu.name}',
        );

        for (final item
        in menu.menuItems) {
          debugPrint(
            'FOOD: ${item.name} '
                '- ${item.price} '
                '- available: '
                '${item.availability}',
          );
        }
      }
    } catch (e) {
      debugPrint(
        'RESTAURANT MENU ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshMenu() async {
    await _loadRestaurantMenu();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
    Theme.of(context);

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,

      body: RefreshIndicator(
        onRefresh: _refreshMenu,

        child: CustomScrollView(
          physics:
          const AlwaysScrollableScrollPhysics(),

          slivers: [
            // ==================================================
            // HEADER
            // ==================================================

            SliverToBoxAdapter(
              child:
              _buildRestaurantHeader(
                context,
              ),
            ),

            // ==================================================
            // CONTENT
            // ==================================================

            if (_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child:
                  CircularProgressIndicator(),
                ),
              )
            else if (_error != null)
              SliverFillRemaining(
                child:
                _buildErrorState(
                  context,
                ),
              )
            else if (_menus.isEmpty)
                SliverFillRemaining(
                  child:
                  _buildEmptyState(
                    context,
                  ),
                )
              else
                SliverList(
                  delegate:
                  SliverChildBuilderDelegate(
                        (
                        context,
                        index,
                        ) {
                      final RestaurantMenu
                      menu =
                      _menus[index];

                      return _buildMenuSection(
                        context,
                        menu,
                      );
                    },
                    childCount:
                    _menus.length,
                  ),
                ),

            // ==================================================
            // BOTTOM SPACE
            // ==================================================

            const SliverToBoxAdapter(
              child: SizedBox(
                height: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // RESTAURANT HEADER
  // ============================================================

  Widget _buildRestaurantHeader(
      BuildContext context,
      ) {
    final ThemeData theme =
    Theme.of(context);

    final bool isDark =
        theme.brightness ==
            Brightness.dark;

    final Color white =
        Colors.white;

    final bool isOpen =
        widget.restaurant.isOpen;

    return Stack(
      children: [
        SizedBox(
          height: 330,
          width: double.infinity,

          child: _buildImage(
            widget.restaurant.image,
          ),
        ),

        Container(
          height: 330,

          decoration:
          const BoxDecoration(
            gradient:
            LinearGradient(
              begin:
              Alignment.topCenter,
              end:
              Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black87,
              ],
            ),
          ),
        ),

        // ======================================================
        // BACK BUTTON
        // ======================================================

        Positioned(
          top: 45,
          left: 16,

          child: CircleAvatar(
            backgroundColor:
            Colors.white.withOpacity(
              .90,
            ),

            child: IconButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pop();
              },

              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
        ),

        // ======================================================
        // RESTAURANT INFO
        // ======================================================

        Positioned(
          left: 20,
          right: 20,
          bottom: 22,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              Text(
                widget.restaurant.name,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,

                style: TextStyle(
                  color: white,
                  fontSize: 28,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),

              const SizedBox(
                height: 7,
              ),

              Row(
                children: [
                  Icon(
                    isOpen
                        ? Icons
                        .check_circle
                        : Icons
                        .cancel,

                    size: 16,

                    color: isOpen
                        ? Colors.greenAccent
                        : Colors.redAccent,
                  ),

                  const SizedBox(
                    width: 6,
                  ),

                  Text(
                    isOpen
                        ? 'Open'
                        : 'Closed',

                    style: TextStyle(
                      color: isOpen
                          ? Colors
                          .greenAccent
                          : Colors
                          .redAccent,

                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),

                  if (widget
                      .restaurant
                      .distance
                      .trim()
                      .isNotEmpty) ...[
                    const SizedBox(
                      width: 8,
                    ),

                    Text(
                      '•',
                      style: TextStyle(
                        color: white,
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Text(
                      widget
                          .restaurant
                          .distance,

                      style:
                      TextStyle(
                        color: white,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(
                height: 7,
              ),

              if (widget.restaurant.cuisine
                  .trim()
                  .isNotEmpty)
                Text(
                  widget.restaurant.cuisine,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,

                  style: TextStyle(
                    color: white,
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),

              const SizedBox(
                height: 5,
              ),

              if (widget.restaurant.address
                  .trim()
                  .isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 16,
                    ),

                    const SizedBox(
                      width: 4,
                    ),

                    Expanded(
                      child: Text(
                        widget
                            .restaurant
                            .address,

                        maxLines: 1,

                        overflow:
                        TextOverflow
                            .ellipsis,

                        style:
                        TextStyle(
                          color: white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MENU SECTION
  // ============================================================

  Widget _buildMenuSection(
      BuildContext context,
      RestaurantMenu menu,
      ) {
    final ThemeData theme =
    Theme.of(context);

    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        0,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // ====================================================
          // CATEGORY TITLE
          // ====================================================

          Row(
            children: [
              const Icon(
                Icons.restaurant_menu,
                size: 22,
              ),

              const SizedBox(
                width: 8,
              ),

              Expanded(
                child: Text(
                  menu.name,

                  style: TextStyle(
                    color:
                    theme.colorScheme
                        .onSurface,

                    fontSize: 21,

                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 5,
          ),

          Text(
            '${menu.menuItems.length} Food Items',

            style: TextStyle(
              color: theme
                  .colorScheme
                  .onSurface
                  .withOpacity(.60),

              fontSize: 13,
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          // ====================================================
          // FOOD GRID
          // ====================================================

          GridView.builder(
            shrinkWrap: true,

            physics:
            const NeverScrollableScrollPhysics(),

            itemCount:
            menu.menuItems.length,

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,

              crossAxisSpacing: 14,

              mainAxisSpacing: 14,

              childAspectRatio:
              .68,
            ),

            itemBuilder: (
                context,
                index,
                ) {
              final RestaurantMenuItem
              item =
              menu.menuItems[index];

              return _buildFoodCard(
                context,
                item,
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FOOD CARD
  // ============================================================

  Widget _buildFoodCard(
      BuildContext context,
      RestaurantMenuItem item,
      ) {
    final ThemeData theme =
    Theme.of(context);

    final bool isAvailable =
        item.availability;

    final Color cardColor =
        theme.colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
        BorderRadius.circular(
          18,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(.07),

            blurRadius: 10,

            offset:
            const Offset(0, 4),
          ),
        ],
      ),

      clipBehavior:
      Clip.antiAlias,

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // ==================================================
          // IMAGE
          // ==================================================

          SizedBox(
            height: 145,
            width: double.infinity,

            child: _buildImage(
              item.imageUrl,
            ),
          ),

          // ==================================================
          // DETAILS
          // ==================================================

          Expanded(
            child: Padding(
              padding:
              const EdgeInsets
                  .fromLTRB(
                12,
                10,
                12,
                10,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [
                  Text(
                    item.name,

                    maxLines: 2,

                    overflow:
                    TextOverflow
                        .ellipsis,

                    style: TextStyle(
                      color: theme
                          .colorScheme
                          .onSurface,

                      fontSize: 15,

                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),

                  const Spacer(),

                  // ========================================
                  // PRICE
                  // ========================================

                  Text(
                    '₹${item.price}',

                    style: TextStyle(
                      color: theme
                          .colorScheme
                          .primary,

                      fontSize: 17,

                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  // ========================================
                  // AVAILABILITY
                  // ========================================

                  if (isAvailable)
                    Container(
                      width: double.infinity,

                      height: 34,

                      decoration:
                      BoxDecoration(
                        color: theme
                            .colorScheme
                            .primary,

                        borderRadius:
                        BorderRadius
                            .circular(
                          10,
                        ),
                      ),

                      child: Center(
                        child: Text(
                          'Add to cart',

                          style:
                          const TextStyle(
                            color:
                            Colors.white,

                            fontSize: 12,

                            fontWeight:
                            FontWeight
                                .w700,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,

                      height: 34,

                      decoration:
                      BoxDecoration(
                        color: Colors
                            .grey
                            .withOpacity(
                          .25,
                        ),

                        borderRadius:
                        BorderRadius
                            .circular(
                          10,
                        ),
                      ),

                      child: const Center(
                        child: Text(
                          'Currently unavailable',

                          style:
                          TextStyle(
                            color:
                            Colors.grey,

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
    );
  }

  // ============================================================
  // IMAGE
  // ============================================================

  Widget _buildImage(
      String url,
      ) {
    if (url.trim().isEmpty) {
      return Container(
        color: Colors.grey.shade200,

        child: const Center(
          child: Icon(
            Icons.restaurant,
            size: 45,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Image.network(
      url,

      fit: BoxFit.cover,

      errorBuilder: (
          context,
          error,
          stackTrace,
          ) {
        return Container(
          color: Colors.grey.shade200,

          child: const Center(
            child: Icon(
              Icons.restaurant,
              size: 45,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyState(
      BuildContext context,
      ) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(
          30,
        ),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            Icon(
              Icons
                  .restaurant_menu_outlined,

              size: 60,

              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),

            const SizedBox(
              height: 15,
            ),

            const Text(
              'No menu available',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            const Text(
              'This restaurant has no food items available right now.',
              textAlign:
              TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildErrorState(
      BuildContext context,
      ) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(
          30,
        ),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.error_outline,
              size: 55,
              color: Colors.red,
            ),

            const SizedBox(
              height: 15,
            ),

            const Text(
              'Unable to load menu',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              _error ?? '',
              textAlign:
              TextAlign.center,
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed:
              _loadRestaurantMenu,

              child:
              const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}