import 'package:app_matic_tech_flutter_app/core/storage/address_storage.dart';
import 'package:app_matic_tech_flutter_app/core/storage/auth_storage.dart';
import 'package:app_matic_tech_flutter_app/services/milestone_app_6_restaurant_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/milestone_app_6_restaurants_data.dart';
import '../state/milestone_app_6_state.dart';

class MilestoneApp6CategoriesScreen extends StatefulWidget {
  final MilestoneApp6State state;

  const MilestoneApp6CategoriesScreen({
    super.key,
    required this.state,
  });

  @override
  State<MilestoneApp6CategoriesScreen> createState() =>
      _MilestoneApp6CategoriesScreenState();
}

class _MilestoneApp6CategoriesScreenState
    extends State<MilestoneApp6CategoriesScreen> {
  // ==============================================================
  // API
  // ==============================================================

  final MilestoneApp6RestaurantApi _restaurantApi =
  MilestoneApp6RestaurantApi();

  List<MilestoneApp6Restaurant> _restaurants = [];

  bool _isLoading = true;

  String? _error;

  // ==============================================================
  // CATEGORY
  // ==============================================================

  String _selectedCategory = '';

  // ==============================================================
  // FILTER
  // ==============================================================

  String selectedSort = 'Recommended';

  double? selectedRating;

  String selectedPrice = 'All';

  // ==============================================================
  // INIT
  // ==============================================================

  @override
  void initState() {
    super.initState();

    _loadCategoriesData();
  }

  // ==============================================================
  // LOAD API DATA
  // ==============================================================

  Future<void> _loadCategoriesData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // ------------------------------------------------------------
      // AUTH TOKEN
      // ------------------------------------------------------------

      final String? token = await AuthStorage.token;

      if (token == null || token.trim().isEmpty) {
        if (!mounted) return;

        context.go('/login');
        return;
      }

      // ------------------------------------------------------------
      // SELECTED ADDRESS
      // ------------------------------------------------------------

      final int? addressId =
      await AddressStorage.selectedAddressId;

      if (addressId == null || addressId <= 0) {
        if (!mounted) return;

        context.go('/select-address');
        return;
      }

      // ------------------------------------------------------------
      // API
      // ------------------------------------------------------------

      final List<Map<String, dynamic>> response =
      await _restaurantApi.fetchNearbyRestaurants(
        token: token,
        addressId: addressId,
        page: 1,
        openNow: false,
        includeMenus: true,
      );

      // ------------------------------------------------------------
      // PARSE RESTAURANTS
      // ------------------------------------------------------------

      final List<MilestoneApp6Restaurant> restaurants =
      response
          .map(
            (json) =>
            MilestoneApp6Restaurant.fromJson(json),
      )
          .toList();

      if (!mounted) return;

      setState(() {
        _restaurants = restaurants;

        final List<String> categories =
            _apiCategories;

        if (categories.isNotEmpty) {
          _selectedCategory = categories.first;
        } else {
          _selectedCategory = '';
        }

        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      debugPrint(
        'CATEGORIES API ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        _restaurants = [];
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  // ==============================================================
  // API CATEGORIES
  // ==============================================================

  List<String> get _apiCategories {
    final Set<String> categoryNames = {};

    for (final restaurant in _restaurants) {
      for (final menu in restaurant.menus) {
        final String name = menu.name.trim();

        if (name.isNotEmpty) {
          categoryNames.add(name);
        }
      }
    }

    return categoryNames.toList();
  }

  // ==============================================================
  // API FOOD ITEMS
  // ==============================================================

  List<_ApiFoodEntry> get _apiFoodItems {
    final List<_ApiFoodEntry> items = [];

    for (final restaurant in _restaurants) {
      for (final menu in restaurant.menus) {
        for (final item in menu.menuItems) {
          items.add(
            _ApiFoodEntry(
              restaurant: restaurant,
              menu: menu,
              item: item,
            ),
          );
        }
      }
    }

    return items;
  }

  // ==============================================================
  // FILTERED API FOOD
  // ==============================================================

  List<_ApiFoodEntry> get _filteredFoods {
    final String selected =
    _selectedCategory.trim().toLowerCase();

    Iterable<_ApiFoodEntry> result =
        _apiFoodItems;

    // ------------------------------------------------------------
    // CATEGORY
    // ------------------------------------------------------------

    if (selected.isNotEmpty) {
      result = result.where(
            (entry) =>
        entry.menu.name.trim().toLowerCase() ==
            selected,
      );
    }

    // ------------------------------------------------------------
    // RATING
    // ------------------------------------------------------------

    if (selectedRating != null) {
      result = result.where((entry) {
        final double rating =
            double.tryParse(
              entry.restaurant.rating,
            ) ??
                0;

        return rating >= selectedRating!;
      });
    }

    // ------------------------------------------------------------
    // PRICE
    // ------------------------------------------------------------

    switch (selectedPrice) {
      case 'Under \$10':
        result = result.where((entry) {
          final double price =
              double.tryParse(entry.item.price) ?? 0;

          return price < 10;
        });
        break;

      case '\$10 - \$20':
        result = result.where((entry) {
          final double price =
              double.tryParse(entry.item.price) ?? 0;

          return price >= 10 && price <= 20;
        });
        break;

      case '\$20+':
        result = result.where((entry) {
          final double price =
              double.tryParse(entry.item.price) ?? 0;

          return price > 20;
        });
        break;
    }

    // ------------------------------------------------------------
    // SORT
    // ------------------------------------------------------------

    final List<_ApiFoodEntry> filtered =
    result.toList();

    switch (selectedSort) {
      case 'Rating: High to Low':
        filtered.sort((a, b) {
          final double ratingA =
              double.tryParse(a.restaurant.rating) ?? 0;

          final double ratingB =
              double.tryParse(b.restaurant.rating) ?? 0;

          return ratingB.compareTo(ratingA);
        });
        break;

      case 'Price: Low to High':
        filtered.sort((a, b) {
          final double priceA =
              double.tryParse(a.item.price) ?? 0;

          final double priceB =
              double.tryParse(b.item.price) ?? 0;

          return priceA.compareTo(priceB);
        });
        break;

      case 'Price: High to Low':
        filtered.sort((a, b) {
          final double priceA =
              double.tryParse(a.item.price) ?? 0;

          final double priceB =
              double.tryParse(b.item.price) ?? 0;

          return priceB.compareTo(priceA);
        });
        break;
    }

    return filtered;
  }

  // ==============================================================
  // FILTER COUNT
  // ==============================================================

  int get activeFilterCount {
    int count = 0;

    if (selectedSort != 'Recommended') {
      count++;
    }

    if (selectedRating != null) {
      count++;
    }

    if (selectedPrice != 'All') {
      count++;
    }

    return count;
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
    Theme.of(context);

    final bool isTablet =
        MediaQuery.sizeOf(context).width >= 700;

    final int columns =
    isTablet ? 4 : 2;

    return Scaffold(
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _error != null
          ? _buildErrorState()
          : CustomScrollView(
        slivers: [
          // ------------------------------------------------
          // APP BAR
          // ------------------------------------------------

          SliverAppBar(
            pinned: true,
            title: const Text(
              'Categories',
            ),
            leading: IconButton(
              onPressed: () {
                context.go('/home');
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            actions: [
              if (_apiCategories.isNotEmpty)
                IconButton(
                  onPressed: () {
                    _showFilterBottomSheet(
                      context,
                    );
                  },
                  icon: Stack(
                    clipBehavior:
                    Clip.none,
                    children: [
                      const Icon(
                        Icons.tune,
                      ),
                      if (activeFilterCount >
                          0)
                        Positioned(
                          right: -5,
                          top: -5,
                          child:
                          Container(
                            width: 16,
                            height: 16,
                            decoration:
                            BoxDecoration(
                              color: theme
                                  .colorScheme
                                  .primary,
                              shape:
                              BoxShape
                                  .circle,
                            ),
                            alignment:
                            Alignment
                                .center,
                            child: Text(
                              '$activeFilterCount',
                              style:
                              const TextStyle(
                                color:
                                Colors
                                    .white,
                                fontSize: 9,
                                fontWeight:
                                FontWeight
                                    .w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),

          // ------------------------------------------------
          // EMPTY CATEGORY
          // ------------------------------------------------

          if (_apiCategories.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child:
              _buildEmptyCategoryState(),
            )
          else ...[
            // ----------------------------------------------
            // CATEGORY LIST
            // ----------------------------------------------

            SliverToBoxAdapter(
              child: SizedBox(
                height: 112,
                child:
                ListView.separated(
                  padding:
                  const EdgeInsets
                      .fromLTRB(
                    20,
                    8,
                    20,
                    14,
                  ),
                  scrollDirection:
                  Axis.horizontal,
                  physics:
                  const BouncingScrollPhysics(),
                  itemCount:
                  _apiCategories
                      .length,
                  separatorBuilder:
                      (_, __) =>
                  const SizedBox(
                    width: 10,
                  ),
                  itemBuilder:
                      (context, index) {
                    final String category =
                    _apiCategories[
                    index];

                    final bool selected =
                        _selectedCategory
                            .toLowerCase() ==
                            category
                                .toLowerCase();

                    return _buildCategoryChip(
                      category,
                      selected,
                    );
                  },
                ),
              ),
            ),

            // ----------------------------------------------
            // TITLE
            // ----------------------------------------------

            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets
                    .fromLTRB(
                  20,
                  4,
                  20,
                  12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedCategory
                            .isEmpty
                            ? 'Food'
                            : '${_selectedCategory} Food',
                        maxLines: 1,
                        overflow:
                        TextOverflow
                            .ellipsis,
                        style:
                        const TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight
                              .w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ----------------------------------------------
            // FOOD
            // ----------------------------------------------

            if (_filteredFoods.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child:
                _buildEmptyFoodState(),
              )
            else
              SliverPadding(
                padding:
                const EdgeInsets
                    .fromLTRB(
                  20,
                  0,
                  20,
                  30,
                ),
                sliver: SliverGrid(
                  delegate:
                  SliverChildBuilderDelegate(
                        (context, index) {
                      final _ApiFoodEntry
                      entry =
                      _filteredFoods[
                      index];

                      return _buildApiFoodCard(
                        entry,
                      );
                    },
                    childCount:
                    _filteredFoods
                        .length,
                  ),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                    columns,
                    crossAxisSpacing:
                    12,
                    mainAxisSpacing:
                    12,
                    mainAxisExtent:
                    isTablet
                        ? 300
                        : 245,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ==============================================================
  // CATEGORY CHIP
  // ==============================================================

  Widget _buildCategoryChip(
      String category,
      bool selected,
      ) {
    final ThemeData theme =
    Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        width: 86,
        padding:
        const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              .withOpacity(0.12)
              : theme.colorScheme.surface,
          borderRadius:
          BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.dividerColor
                .withOpacity(0.25),
          ),
        ),
        child: Center(
          child: Text(
            category,
            maxLines: 2,
            overflow:
            TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: selected
                  ? theme.colorScheme.primary
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // API FOOD CARD
  // ==============================================================

  Widget _buildApiFoodCard(
      _ApiFoodEntry entry,
      ) {
    final ThemeData theme =
    Theme.of(context);

    final bool isDark =
        theme.brightness ==
            Brightness.dark;

    final MilestoneApp6MenuItem item =
        entry.item;

    final MilestoneApp6Restaurant restaurant =
        entry.restaurant;

    final bool available =
        item.availability &&
            restaurant.isOpen;

    final double price =
        double.tryParse(item.price) ?? 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: available
            ? () {
          context.push(
            '/food/${item.id}',
          );
        }
            : null,
        borderRadius:
        BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF202020)
                : Colors.white,
            borderRadius:
            BorderRadius.circular(16),
            border: isDark
                ? Border.all(
              color: Colors.white
                  .withOpacity(0.06),
            )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(
                  isDark ? 0.25 : 0.06,
                ),
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
              // --------------------------------
              // IMAGE
              // --------------------------------

              SizedBox(
                height: 130,
                width: double.infinity,
                child: item.image.isNotEmpty
                    ? Image.network(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      color: isDark
                          ? const Color(
                        0xFF2A2A2A,
                      )
                          : const Color(
                        0xFFF2F2F2,
                      ),
                      child: const Icon(
                        Icons
                            .restaurant_rounded,
                        size: 40,
                      ),
                    );
                  },
                )
                    : Container(
                  color: isDark
                      ? const Color(
                    0xFF2A2A2A,
                  )
                      : const Color(
                    0xFFF2F2F2,
                  ),
                  child: const Icon(
                    Icons
                        .restaurant_rounded,
                    size: 40,
                  ),
                ),
              ),

              // --------------------------------
              // DETAILS
              // --------------------------------

              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.all(
                    12,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(
                            0xFF171717,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        restaurant.name,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? const Color(
                            0xFFBDBDBD,
                          )
                              : const Color(
                            0xFF777777,
                          ),
                        ),
                      ),

                      const Spacer(),

                      Row(
                        children: [
                          Text(
                            '₹${price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.w800,
                              color: theme
                                  .colorScheme
                                  .primary,
                            ),
                          ),
                          const Spacer(),
                          if (!available)
                            Text(
                              restaurant.isOpen
                                  ? 'Unavailable'
                                  : 'Closed',
                              style:
                              const TextStyle(
                                fontSize: 11,
                                fontWeight:
                                FontWeight.w600,
                                color:
                                Colors.red,
                              ),
                            ),
                        ],
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
  // FILTER SHEET
  // ==============================================================

  void _showFilterBottomSheet(
      BuildContext context,
      ) {
    String tempSort = selectedSort;
    double? tempRating = selectedRating;
    String tempPrice = selectedPrice;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor:
      Theme.of(context)
          .colorScheme
          .surface,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder:
              (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  4,
                  20,
                  20,
                ),
                child:
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Filter',
                              style:
                              TextStyle(
                                fontSize: 22,
                                fontWeight:
                                FontWeight
                                    .w800,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setSheetState(
                                    () {
                                  tempSort =
                                  'Recommended';
                                  tempRating =
                                  null;
                                  tempPrice =
                                  'All';
                                },
                              );
                            },
                            child:
                            const Text(
                              'Reset',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      const Text(
                        'Sort By',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      _radioOption(
                        title: 'Recommended',
                        value:
                        'Recommended',
                        groupValue:
                        tempSort,
                        onChanged:
                            (value) {
                          setSheetState(
                                () {
                              tempSort =
                                  value;
                            },
                          );
                        },
                      ),

                      _radioOption(
                        title:
                        'Rating: High to Low',
                        value:
                        'Rating: High to Low',
                        groupValue:
                        tempSort,
                        onChanged:
                            (value) {
                          setSheetState(
                                () {
                              tempSort =
                                  value;
                            },
                          );
                        },
                      ),

                      _radioOption(
                        title:
                        'Price: Low to High',
                        value:
                        'Price: Low to High',
                        groupValue:
                        tempSort,
                        onChanged:
                            (value) {
                          setSheetState(
                                () {
                              tempSort =
                                  value;
                            },
                          );
                        },
                      ),

                      _radioOption(
                        title:
                        'Price: High to Low',
                        value:
                        'Price: High to Low',
                        groupValue:
                        tempSort,
                        onChanged:
                            (value) {
                          setSheetState(
                                () {
                              tempSort =
                                  value;
                            },
                          );
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      const Text(
                        'Rating',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      _ratingOption(
                        title: 'Any Rating',
                        rating: null,
                        selected:
                        tempRating == null,
                        onTap: () {
                          setSheetState(() {
                            tempRating =
                            null;
                          });
                        },
                      ),

                      _ratingOption(
                        title: '4.5+',
                        rating: 4.5,
                        selected:
                        tempRating == 4.5,
                        onTap: () {
                          setSheetState(() {
                            tempRating = 4.5;
                          });
                        },
                      ),

                      _ratingOption(
                        title: '4.0+',
                        rating: 4.0,
                        selected:
                        tempRating == 4.0,
                        onTap: () {
                          setSheetState(() {
                            tempRating = 4.0;
                          });
                        },
                      ),

                      _ratingOption(
                        title: '3.5+',
                        rating: 3.5,
                        selected:
                        tempRating == 3.5,
                        onTap: () {
                          setSheetState(() {
                            tempRating = 3.5;
                          });
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      const Text(
                        'Price Range',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _priceChip(
                            label: 'All',
                            selected:
                            tempPrice ==
                                'All',
                            onTap: () {
                              setSheetState(
                                    () {
                                  tempPrice =
                                  'All';
                                },
                              );
                            },
                          ),
                          _priceChip(
                            label:
                            'Under \$10',
                            selected:
                            tempPrice ==
                                'Under \$10',
                            onTap: () {
                              setSheetState(
                                    () {
                                  tempPrice =
                                  'Under \$10';
                                },
                              );
                            },
                          ),
                          _priceChip(
                            label:
                            '\$10 - \$20',
                            selected:
                            tempPrice ==
                                '\$10 - \$20',
                            onTap: () {
                              setSheetState(
                                    () {
                                  tempPrice =
                                  '\$10 - \$20';
                                },
                              );
                            },
                          ),
                          _priceChip(
                            label: '\$20+',
                            selected:
                            tempPrice ==
                                '\$20+',
                            onTap: () {
                              setSheetState(
                                    () {
                                  tempPrice =
                                  '\$20+';
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 28,
                      ),

                      SizedBox(
                        width:
                        double.infinity,
                        height: 52,
                        child:
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              selectedSort =
                                  tempSort;
                              selectedRating =
                                  tempRating;
                              selectedPrice =
                                  tempPrice;
                            });

                            Navigator.pop(
                              sheetContext,
                            );
                          },
                          child: const Text(
                            'Apply Filter',
                            style:
                            TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==============================================================
  // RADIO
  // ==============================================================

  Widget _radioOption({
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String> onChanged,
  }) {
    return RadioListTile<String>(
      contentPadding:
      EdgeInsets.zero,
      dense: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight:
          FontWeight.w500,
        ),
      ),
      value: value,
      groupValue: groupValue,
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }

  // ==============================================================
  // RATING
  // ==============================================================

  Widget _ratingOption({
    required String title,
    required double? rating,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final ThemeData theme =
    Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(12),
      child: Container(
        margin:
        const EdgeInsets.only(
          bottom: 7,
        ),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme
              .primary
              .withOpacity(0.08)
              : Colors.transparent,
          borderRadius:
          BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? theme.colorScheme
                .primary
                : theme.dividerColor
                .withOpacity(0.25),
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons
                  .radio_button_checked
                  : Icons
                  .radio_button_off,
              size: 20,
              color: selected
                  ? theme.colorScheme
                  .primary
                  : theme.hintColor,
            ),
            const SizedBox(
              width: 10,
            ),
            if (rating != null) ...[
              const Icon(
                Icons.star_rounded,
                size: 18,
                color: Colors.amber,
              ),
              const SizedBox(
                width: 5,
              ),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: selected
                    ? theme.colorScheme
                    .primary
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // PRICE CHIP
  // ==============================================================

  Widget _priceChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final ThemeData theme =
    Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(12),
      child: AnimatedContainer(
        duration:
        const Duration(
          milliseconds: 180,
        ),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme
              .primary
              .withOpacity(0.10)
              : theme.colorScheme
              .surface,
          borderRadius:
          BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? theme.colorScheme
                .primary
                : theme.dividerColor
                .withOpacity(0.30),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected
                ? FontWeight.w700
                : FontWeight.w500,
            color: selected
                ? theme.colorScheme
                .primary
                : null,
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // EMPTY CATEGORY
  // ==============================================================

  Widget _buildEmptyCategoryState() {
    final ThemeData theme =
    Theme.of(context);

    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons.category_outlined,
              size: 55,
              color:
              theme.colorScheme.primary,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'No categories found',
              style: TextStyle(
                fontSize: 19,
                fontWeight:
                FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'No menu categories are available for the selected address.',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                color:
                theme.hintColor,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            OutlinedButton(
              onPressed:
              _loadCategoriesData,
              child:
              const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // EMPTY FOOD
  // ==============================================================

  Widget _buildEmptyFoodState() {
    final ThemeData theme =
    Theme.of(context);

    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .restaurant_menu_outlined,
              size: 50,
              color:
              theme.colorScheme.primary,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'No food found',
              style: TextStyle(
                fontSize: 19,
                fontWeight:
                FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'No food items are available in this category.',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                color:
                theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // ERROR
  // ==============================================================

  Widget _buildErrorState() {
    final ThemeData theme =
    Theme.of(context);

    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 50,
              color:
              theme.colorScheme.primary,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Unable to load categories',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight:
                FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              _error ?? '',
              textAlign:
              TextAlign.center,
              maxLines: 4,
              overflow:
              TextOverflow.ellipsis,
              style: TextStyle(
                color:
                theme.hintColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            FilledButton(
              onPressed:
              _loadCategoriesData,
              child:
              const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// API FOOD ENTRY
// ============================================================================

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