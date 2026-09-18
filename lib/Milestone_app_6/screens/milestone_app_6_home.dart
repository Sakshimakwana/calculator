import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/milestone_app_6_food.dart';
import '../data/milestone_app_6_restaurants_data.dart';
import '../state/milestone_app_6_state.dart';
import '../theme/milestone_app_6_colors.dart';
import '../widgets/milestone_app_6_category.dart';
import '../widgets/milestone_app_6_food_card.dart';
import '../widgets/milestone_app_6_image.dart';
import '../widgets/milestone_app_6_animated_search_hint.dart';

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

  String _selectedAddress = '';

  Future<void> _loadSelectedAddress() async {
    final prefs = await SharedPreferences.getInstance();

    final address = prefs.getString('selected_address') ?? '';

    if (!mounted) return;

    setState(() {
      _selectedAddress = address;
    });
  }

  // ==============================================================
// NEW RESTAURANT - ZOMATO STYLE
// ==============================================================

  Widget _newRestaurantItem({
    required MilestoneApp6Restaurant restaurant,
  }) {
    final bool isClosed = !restaurant.isOpen;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        18,
      ),
      decoration: BoxDecoration(
        color: isClosed
            ? const Color(0xFFF5F5F5)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),

        onTap: () {
          context.push(
            '/restaurant/${Uri.encodeComponent(
              restaurant.name,
            )}',
          );
        },

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==========================================================
            // RESTAURANT IMAGE
            // ==========================================================

            AspectRatio(
              aspectRatio: 1.75,
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
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.zero,
                ),
              )
                  : MilestoneApp6Image(
                url: restaurant.image,
                width: double.infinity,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.zero,
              ),
            ),

            // ==========================================================
            // RESTAURANT INFORMATION
            // ==========================================================

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

                  // ======================================================
                  // RESTAURANT NAME
                  // ======================================================

                  Text(
                    restaurant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isClosed
                          ? const Color(0xFF555555)
                          : Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ======================================================
                  // OPEN / CLOSED + DISTANCE
                  // ======================================================

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Icon(
                        restaurant.isOpen
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 14,
                        color: restaurant.isOpen
                            ? const Color(0xFF00A651)
                            : const Color(0xFFE53935),
                      ),

                      const SizedBox(width: 4),

                      Text(
                        restaurant.isOpen
                            ? 'Open'
                            : 'Closed',
                        style: TextStyle(
                          color: restaurant.isOpen
                              ? const Color(0xFF00A651)
                              : const Color(0xFFE53935),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      if (restaurant.distance.isNotEmpty) ...[
                        const SizedBox(width: 7),

                        const Text(
                          '•',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(width: 7),

                        Text(
                          restaurant.distance,
                          style: TextStyle(
                            color: isClosed
                                ? const Color(0xFF888888)
                                : const Color(0xFF555555),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  // ======================================================
                  // CUISINE
                  // ======================================================

                  Text(
                    restaurant.cuisine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isClosed
                          ? const Color(0xFF888888)
                          : const Color(0xFF666666),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ======================================================
                  // ADDRESS
                  // ======================================================

                  if (restaurant.address.isNotEmpty)
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Icon(
                          Icons.location_on_rounded,
                          size: 15,
                          color: isClosed
                              ? const Color(0xFF999999)
                              : const Color(0xFF777777),
                        ),

                        const SizedBox(width: 4),

                        Expanded(
                          child: Text(
                            restaurant.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isClosed
                                  ? const Color(0xFF888888)
                                  : const Color(0xFF666666),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
  // CATEGORY
  // ==============================================================

  String _selectedCategory = 'All';

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

    _searchController.addListener(_onSearchChanged);

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
    final available = await _speech.initialize(
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
            ),
          );

        return;
      }
    }

    // --------------------------------------------------------------
    // STOP LISTENING
    // --------------------------------------------------------------

    if (_isListening) {
      await _speech.stop();

      if (!mounted) return;

      setState(() {
        _isListening = false;
      });

      return;
    }

    // --------------------------------------------------------------
    // START LISTENING
    // --------------------------------------------------------------

    FocusScope.of(context).unfocus();

    setState(() {
      _isListening = true;
    });

    await _speech.listen(
      listenMode: stt.ListenMode.search,
      partialResults: true,
      onResult: (result) {
        if (!mounted) return;

        final words = result.recognizedWords;

        _searchController.value =
            TextEditingValue(
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
  // FILTERED FOOD
  // ==============================================================

  List<MilestoneApp6Food> get _filteredFoods {
    Iterable<MilestoneApp6Food> result =
        milestoneApp6Foods;

    // --------------------------------------------------------------
    // CATEGORY
    // --------------------------------------------------------------

    if (_selectedCategory != 'All') {
      result = result.where(
            (food) =>
        food.category.toLowerCase() ==
            _selectedCategory.toLowerCase(),
      );
    }

    // --------------------------------------------------------------
    // SEARCH
    // --------------------------------------------------------------

    final query =
    _searchController.text.trim().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where(
            (food) {
          final name = food.name.toLowerCase();
          final category =
          food.category.toLowerCase();
          final restaurant =
          food.restaurant.toLowerCase();

          return name.contains(query) ||
              category.contains(query) ||
              restaurant.contains(query);
        },
      );
    }

    return result.toList();
  }

  // ==============================================================
  // RESTAURANT FOOD
  // ==============================================================

  List<MilestoneApp6Food> _restaurantFoods(
      String restaurantName,
      ) {
    Iterable<MilestoneApp6Food> result =
    milestoneApp6Foods.where(
          (food) =>
      food.restaurant.trim().toLowerCase() ==
          restaurantName.trim().toLowerCase(),
    );

    // --------------------------------------------------------------
    // CATEGORY FILTER
    // --------------------------------------------------------------

    if (_selectedCategory != 'All') {
      result = result.where(
            (food) =>
        food.category.toLowerCase() ==
            _selectedCategory.toLowerCase(),
      );
    }

    // --------------------------------------------------------------
    // SEARCH FILTER
    // --------------------------------------------------------------

    final query =
    _searchController.text.trim().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where(
            (food) {
          final name = food.name.toLowerCase();
          final category =
          food.category.toLowerCase();
          final restaurant =
          food.restaurant.toLowerCase();

          return name.contains(query) ||
              category.contains(query) ||
              restaurant.contains(query);
        },
      );
    }

    return result.toList();
  }

  // ==============================================================
  // CLEAR SEARCH
  // ==============================================================

  void _clearSearch() {
    _searchController.clear();

    FocusScope.of(context).unfocus();
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
        final theme = Theme.of(context);

        final restaurantFoods = _restaurantFoods(
          restaurant.name,
        );

        // ==========================================================
        // SEARCH / CATEGORY FILTER
        // ==========================================================

        if (restaurantFoods.isEmpty &&
            (_searchController.text.trim().isNotEmpty ||
                _selectedCategory != 'All')) {
          return const SizedBox.shrink();
        }

        final bool isClosed = !restaurant.isOpen;

        return Container(
          margin: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            24,
          ),
          decoration: BoxDecoration(
            color: isClosed
                ? const Color(0xFFF5F5F5)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.07),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,

          child: InkWell(
            borderRadius: BorderRadius.circular(20),

            onTap: () {
              context.push(
                '/restaurant/${Uri.encodeComponent(
                  restaurant.name,
                )}',
              );
            },

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ========================================================
                // RESTAURANT IMAGE
                // ========================================================

                SizedBox(
                  height: 200,
                  width: double.infinity,

                  child: isClosed
                      ? ColorFiltered(
                    colorFilter:
                    const ColorFilter.matrix([
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

                // ========================================================
                // RESTAURANT INFORMATION
                // ========================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    14,
                    11,
                    14,
                    14,
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      // ==================================================
                      // RESTAURANT NAME
                      // ==================================================

                      Text(
                        restaurant.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isClosed
                              ? const Color(0xFF555555)
                              : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // ==================================================
                      // OPEN / CLOSED + DISTANCE
                      // ==================================================

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Text(
                            restaurant.isOpen
                                ? 'Open'
                                : 'Closed',
                            style: TextStyle(
                              color: restaurant.isOpen
                                  ? const Color(0xFF00A651)
                                  : const Color(0xFFE53935),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(width: 6),

                          const Text(
                            '•',
                            style: TextStyle(
                              color: Colors.black54,
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
                                    : const Color(0xFF555555),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // ==================================================
                      // CUISINE
                      // ==================================================

                      Text(
                        restaurant.cuisine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isClosed
                              ? const Color(0xFF888888)
                              : const Color(0xFF666666),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 3),

                      // ==================================================
                      // ADDRESS
                      // ==================================================

                      if (restaurant.address.isNotEmpty)
                        Text(
                          restaurant.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isClosed
                                ? const Color(0xFF888888)
                                : const Color(0xFF666666),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      // ==================================================
                      // FOOD CARDS
                      // ==================================================

                      if (showFoodCards &&
                          restaurantFoods.isNotEmpty) ...[
                        const SizedBox(height: 14),

                        SizedBox(
                          height: 280,

                          child: ListView.separated(
                            padding: const EdgeInsets.only(
                              bottom: 5,
                            ),

                            scrollDirection: Axis.horizontal,

                            physics:
                            const BouncingScrollPhysics(),

                            itemCount:
                            restaurantFoods.length,

                            separatorBuilder:
                                (_, __) =>
                            const SizedBox(
                              width: 12,
                            ),

                            itemBuilder:
                                (context, index) {
                              final food =
                              restaurantFoods[index];

                              return SizedBox(
                                width: 190,

                                child:
                                MilestoneApp6FoodCard(
                                  food: food,
                                  state: widget.state,

                                  // IMPORTANT
                                  restaurantIsOpen:
                                  restaurant.isOpen,

                                  onTap: restaurant.isOpen
                                      ? () {
                                    context.push(
                                      '/food/${food.id}',
                                    );
                                  }
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      // ==================================================
                      // NO FOOD
                      // ==================================================

                      if (showFoodCards &&
                          restaurantFoods.isEmpty)
                        Padding(
                          padding:
                          const EdgeInsets.only(
                            top: 10,
                            bottom: 4,
                          ),

                          child: Text(
                            'Explore the menu to discover delicious dishes.',
                            style: theme
                                .textTheme
                                .bodySmall
                                ?.copyWith(
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
          Theme.of(context).scaffoldBackgroundColor,

          surfaceTintColor: Colors.transparent,

          title: const Text(
            'Foodie',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),


          // ============================================================
          // RIGHT SIDE - ADDRESS
          // ============================================================

          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () async {
                  await context.push('/profile/address');

                  _loadSelectedAddress();
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
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 17,
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                      ),

                      const SizedBox(width: 4),

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
                            color: Theme.of(context)
                                .colorScheme
                                .primary,
                          ),
                        ),
                      ),

                      const SizedBox(width: 2),

                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          // ============================================================
          // FLEXIBLE SPACE
          // ============================================================

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
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment:
                  MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Hi, Sakshi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'What would you like to eat today?',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).hintColor,
                      ),
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
            minHeight:
            MediaQuery.paddingOf(context)
                .top +
                150,
            maxHeight:
            MediaQuery.paddingOf(context)
                .top +
                150,
            child: Container(
              color: Theme.of(context)
                  .scaffoldBackgroundColor,
              child: Column(
                children: [
                  // --------------------------------------------------
                  // SEARCH
                  // --------------------------------------------------

                  SizedBox(
                    height: 50 +
                        MediaQuery.paddingOf(
                          context,
                        ).top,
                    child: SafeArea(
                      bottom: true,
                      child:
                      _buildSearchBar(),
                    ),
                  ),

                  // --------------------------------------------------
                  // CATEGORY
                  // --------------------------------------------------

                  SizedBox(
                    height: 94,
                    child:
                    _buildCategoryRow(),
                  ),

                  // --------------------------------------------------
                  // DIVIDER
                  // --------------------------------------------------

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
        // BANNER
        // ==========================================================

        SliverToBoxAdapter(
          child: _banner(context),
        ),


        // ==========================================================
        // POPULAR RESTAURANTS
        // ==========================================================

        // Popular Restaurants - OLD DATA - HORIZONTAL
        SliverToBoxAdapter(
          child: _sectionTitle(
            context,
            'Popular Restaurants',
                () {
              context.push('/restaurants');
            },
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 350,

            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                10,
                0,
                16,
                0,
              ),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: restaurants.length,
              separatorBuilder: (_, __) =>
              const SizedBox(width: 1),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 340,
                  child: _restaurantItem(
                    restaurant: restaurants[index],
                    showFoodCards: false,
                  ),
                );
              },
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: _sectionTitle(
            context,
            'All Restaurants',
                () {
              context.push('/restaurants');
            },
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return _newRestaurantItem(
                restaurant: newRestaurants[index],
              );
            },
            childCount: newRestaurants.length,
          ),
        ),


        // ==========================================================
        // FOOD SEARCH EMPTY STATE
        // ==========================================================

        if (_filteredFoods.isEmpty &&
            _searchController.text
                .trim()
                .isNotEmpty)
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
    final allCategory =
    MilestoneApp6Category(
      'All',
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=500',
    );

    final categories = [
      allCategory,
      ...milestoneApp6Categories,
    ];

    return ListView.separated(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      scrollDirection:
      Axis.horizontal,
      physics:
      const BouncingScrollPhysics(),
      itemCount: categories.length,
      separatorBuilder:
          (_, __) =>
      const SizedBox(width: 10),
      itemBuilder:
          (context, index) {
        final category =
        categories[index];

        final selected =
            _selectedCategory ==
                category.name;

        return MilestoneApp6CategoryChip(
          category: category,
          selected: selected,
          onTap: () {
            _selectCategory(
              category.name,
            );
          },
        );
      },
    );
  }

  // ==============================================================
  // EMPTY FOOD STATE
  // ==============================================================

  Widget _buildEmptyFoodState(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final hasSearch =
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
              shape: BoxShape.circle,
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
    final width =
        MediaQuery.sizeOf(context)
            .width;

    final isTablet =
        width >= 700;

    final bannerHeight =
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
          BorderRadius.circular(
            20,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ======================================================
              // BACKGROUND
              // ======================================================

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

              // ======================================================
              // FOOD IMAGE
              // ======================================================

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

              // ======================================================
              // IMAGE OVERLAY
              // ======================================================

              Positioned.fill(
                child:
                IgnorePointer(
                  child:
                  DecoratedBox(
                    decoration:
                    BoxDecoration(
                      gradient:
                      LinearGradient(
                        begin: Alignment
                            .centerLeft,
                        end: Alignment
                            .centerRight,
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

              // ======================================================
              // CONTENT
              // ======================================================

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
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delicious Food\nDelivered to You',
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        TextStyle(
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
                        child:
                        Container(
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
                              color:
                              Colors.black54,
                              fontSize:
                              10,
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
                color: Theme.of(
                  context,
                ).colorScheme.primary,
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
        child != oldDelegate.child;
  }
}

