import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../data/milestone_app_6_food.dart';
import '../data/milestone_app_6_restaurants_data.dart';
import '../state/milestone_app_6_state.dart';
import '../theme/milestone_app_6_colors.dart';
import '../widgets/milestone_app_6_category.dart';
import '../widgets/milestone_app_6_food_card.dart';
import '../widgets/milestone_app_6_image.dart';

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
  // CATEGORY
  // ==============================================================

  String _selectedCategory = 'All';

  // ==============================================================
  // SEARCH
  // ==============================================================

  final TextEditingController _searchController =
  TextEditingController();

  final List<String> _searchHints = const [
    'pizza',
    'burger',
    'sushi',
    'dessert',
    'pasta',
    'salad',
    'tacos',
    'drinks',
    'breakfast',
    'sandwich',
  ];

  int _searchHintIndex = 0;
  Timer? _searchHintTimer;

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

    _searchController.addListener(_onSearchChanged);

    _searchHintTimer = Timer.periodic(
      const Duration(seconds: 3),
          (_) {
        if (!mounted) return;

        if (_searchController.text.trim().isNotEmpty) {
          return;
        }

        if (_isListening) {
          return;
        }

        setState(() {
          _searchHintIndex =
              (_searchHintIndex + 1) % _searchHints.length;
        });
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

    _speech.stop();

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

        ScaffoldMessenger.of(context).showSnackBar(
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

    setState(() {
      _isListening = true;
    });

    await _speech.listen(
      listenMode: stt.ListenMode.search,
      partialResults: true,
      onResult: (result) {
        if (!mounted) return;

        final words = result.recognizedWords;

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
  // FILTERED FOOD
  // ==============================================================

  List<MilestoneApp6Food> get _filteredFoods {
    Iterable<MilestoneApp6Food> result =
        milestoneApp6Foods;

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

    final query = _searchController.text
        .trim()
        .toLowerCase();

    if (query.isNotEmpty) {
      result = result.where(
            (food) {
          final name =
          food.name.toLowerCase();

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
  }

  // ==============================================================
  // RESTAURANT ITEM
  // ==============================================================

  Widget _restaurantItem({
    required String name,
    required String image,
    required String rating,
    required String time,
    required String cuisine,
  }) {
    return AnimatedBuilder(
      animation: widget.state,
      builder: (context, child) {
        final theme = Theme.of(context);

        final isFavorite =
        widget.state.isRestaurantSaved(name);

        return SizedBox(
          width: 285,
          height: 165,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),

              // ======================================================
              // OPEN RESTAURANT
              // ======================================================

              onTap: () {
                context.push(
                  '/restaurant/${Uri.encodeComponent(name)}',
                );
              },

              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                  BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black.withOpacity(.08),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ==================================================
                    // IMAGE
                    // ==================================================

                    MilestoneApp6Image(
                      url: image,
                      fit: BoxFit.cover,
                      borderRadius:
                      BorderRadius.zero,
                    ),

                    // ==================================================
                    // IMAGE GRADIENT
                    // ==================================================

                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin:
                            Alignment.topCenter,
                            end:
                            Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(.12),
                              Colors.black.withOpacity(.82),
                            ],
                            stops: const [
                              0.20,
                              0.50,
                              1.0,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ==================================================
                    // RATING
                    // ==================================================

                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 15,
                              color: Color(0xFFFFB300),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating,
                              style:
                              const TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                                fontWeight:
                                FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ==================================================
                    // FAVORITE
                    // ==================================================

                    Positioned(
                      right: 12,
                      top: 12,
                      child: Material(
                        color:
                        Colors.white.withOpacity(.95),
                        shape:
                        const CircleBorder(),
                        elevation: 2,
                        child: InkWell(
                          customBorder:
                          const CircleBorder(),
                          onTap: () {
                            widget.state
                                .toggleRestaurantSaved(
                              name,
                            );
                          },
                          child: SizedBox(
                            width: 36,
                            height: 36,
                            child: Center(
                              child: AnimatedSwitcher(
                                duration:
                                const Duration(
                                  milliseconds: 220,
                                ),
                                transitionBuilder:
                                    (
                                    child,
                                    animation,
                                    ) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child:
                                    FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Icon(
                                  isFavorite
                                      ? Icons
                                      .favorite_rounded
                                      : Icons
                                      .favorite_border_rounded,
                                  key: ValueKey(
                                    isFavorite,
                                  ),
                                  size: 19,
                                  color: isFavorite
                                      ? Colors.red
                                      : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ==================================================
                    // ARROW
                    // ==================================================

                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration:
                        const BoxDecoration(
                          color:
                          MilestoneApp6Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons
                              .arrow_forward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),

                    // ==================================================
                    // INFORMATION
                    // ==================================================

                    Positioned(
                      left: 14,
                      right: 55,
                      bottom: 13,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight:
                              FontWeight.w800,
                              height: 1.1,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            cuisine,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white
                                  .withOpacity(.88),
                              fontSize: 11.5,
                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 7),

                          Row(
                            children: [
                              const Icon(
                                Icons
                                    .access_time_rounded,
                                size: 14,
                                color: Colors.white,
                              ),

                              const SizedBox(width: 4),

                              Flexible(
                                child: Text(
                                  time,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style:
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              Container(
                                width: 4,
                                height: 4,
                                decoration:
                                const BoxDecoration(
                                  color: Colors.white70,
                                  shape: BoxShape.circle,
                                ),
                              ),

                              const SizedBox(width: 8),

                              const Flexible(
                                child: Text(
                                  'Free delivery',
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style:
                                  TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight:
                                    FontWeight.w600,
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
    final width =
        MediaQuery.sizeOf(context).width;

    final isTablet = width >= 700;

    final foods = _filteredFoods;

    return CustomScrollView(
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
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Foodie',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          flexibleSpace: FlexibleSpaceBar(
            background: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  2,
                  20,
                  3,
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
                    const SizedBox(height: 2),
                    Text(
                      'What would you like to eat today?',
                      style: TextStyle(
                        fontSize: 11,
                        color:
                        Theme.of(context)
                            .hintColor,
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
            MediaQuery.paddingOf(context).top +
                150,
            maxHeight:
            MediaQuery.paddingOf(context).top +
                150,
            child: Container(
              color:
              Theme.of(context)
                  .scaffoldBackgroundColor,
              child: Column(
                children: [
                  // ==================================================
                  // SEARCH
                  // ==================================================

                  SizedBox(
                    height:
                    55 +
                        MediaQuery.paddingOf(
                          context,
                        ).top,
                    child: SafeArea(
                      bottom: false,
                      child: _buildSearchBar(),
                    ),
                  ),

                  // ==================================================
                  // CATEGORY
                  // ==================================================

                  SizedBox(
                    height: 94,
                    child:
                    _buildCategoryRow(),
                  ),

                  // ==================================================
                  // DIVIDER
                  // ==================================================

                  Container(
                    height: 1,
                    color:
                    Theme.of(context)
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
        // RESTAURANTS TITLE
        // ==========================================================

        SliverToBoxAdapter(
          child: _sectionTitle(
            context,
            'Popular Restaurants',
                () {
              context.push('/restaurants');
            },
          ),
        ),

        // ==========================================================
        // RESTAURANTS
        // ==========================================================

        SliverToBoxAdapter(
          child: SizedBox(
            height: 183,
            child: ListView(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              scrollDirection: Axis.horizontal,
              physics:
              const BouncingScrollPhysics(),
              children: [
                _restaurantItem(
                  name: 'The Italian Bistro',
                  image:
                  'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=700',
                  rating: '4.5',
                  time: '20-30 min',
                  cuisine:
                  'Italian • Pizza • Pasta',
                ),

                const SizedBox(width: 14),

                _restaurantItem(
                  name: 'Sushi World',
                  image:
                  'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=700',
                  rating: '4.7',
                  time: '25-35 min',
                  cuisine:
                  'Japanese • Sushi • Asian',
                ),

                const SizedBox(width: 14),

                _restaurantItem(
                  name: 'Burger Hub',
                  image:
                  'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=700',
                  rating: '4.6',
                  time: '15-25 min',
                  cuisine:
                  'Burgers • Fast Food',
                ),

                const SizedBox(width: 14),

                _restaurantItem(
                  name: 'Green Bowl',
                  image:
                  'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=700',
                  rating: '4.5',
                  time: '20-30 min',
                  cuisine:
                  'Healthy • Salads • Veg',
                ),

                const SizedBox(width: 14),

                _restaurantItem(
                  name: 'Pasta Corner',
                  image:
                  'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=700',
                  rating: '4.6',
                  time: '20-30 min',
                  cuisine:
                  'Italian • Pasta',
                ),

                const SizedBox(width: 14),

                _restaurantItem(
                  name: 'Fresh Bites',
                  image:
                  'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=700',
                  rating: '4.4',
                  time: '15-25 min',
                  cuisine:
                  'Sandwiches • Veg • Cafe',
                ),

                const SizedBox(width: 14),

                _restaurantItem(
                  name: 'Morning Cafe',
                  image:
                  'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=700',
                  rating: '4.7',
                  time: '15-25 min',
                  cuisine:
                  'Breakfast • Cafe • Veg',
                ),

                const SizedBox(width: 14),

                _restaurantItem(
                  name: 'Asian Kitchen',
                  image:
                  'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=700',
                  rating: '4.6',
                  time: '25-35 min',
                  cuisine:
                  'Asian • Noodles • Rice',
                ),
              ],
            ),
          ),
        ),

        // ==========================================================
        // FOOD TITLE
        // ==========================================================

        SliverToBoxAdapter(
          child: _sectionTitle(
            context,
            _selectedCategory == 'All'
                ? 'Popular Food'
                : _selectedCategory,
                () {
              context.go('/categories');
            },
          ),
        ),

        // ==========================================================
        // EMPTY
        // ==========================================================

        if (foods.isEmpty)
          SliverToBoxAdapter(
            child:
            _buildEmptyFoodState(context),
          ),

        // ==========================================================
        // FOOD GRID
        // ==========================================================

        if (foods.isNotEmpty)
          SliverPadding(
            padding:
            const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              24,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final food = foods[index];

                  return MilestoneApp6FoodCard(
                    food: food,
                    state: widget.state,
                    onTap: () {
                      context.push('/food/${food.id}');
                    },
                  );
                },
                childCount: foods.length,
              ),
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                isTablet ? 4 : 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent:
                isTablet ? 300 : 245,
              ),
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
      scrollDirection: Axis.horizontal,
      physics:
      const BouncingScrollPhysics(),
      itemCount: categories.length,
      separatorBuilder: (_, __) =>
      const SizedBox(width: 10),
      itemBuilder: (context, index) {
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
            decoration: BoxDecoration(
              color:
              theme.colorScheme.primary
                  .withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 36,
              color:
              theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 16),

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

          const SizedBox(height: 6),

          Text(
            hasSearch
                ? 'Try another search or category.'
                : 'No items are available in this category.',
            textAlign: TextAlign.center,
            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color: theme.hintColor,
            ),
          ),

          const SizedBox(height: 18),

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
    final width =
        MediaQuery.sizeOf(context).width;

    final isTablet = width >= 700;

    final bannerHeight =
    isTablet ? 150.0 : 140.0;

    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        15,
        0,
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
              // ========================================================
              // BACKGROUND
              // ========================================================

              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin:
                    Alignment.centerLeft,
                    end:
                    Alignment.centerRight,
                    colors: [
                      MilestoneApp6Colors.green,
                      Color(0xFFFCE4EC),
                    ],
                  ),
                ),
              ),

              // ========================================================
              // FOOD IMAGE
              // ========================================================

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

              // ========================================================
              // IMAGE OVERLAY
              // ========================================================

              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
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
                              .withOpacity(.40),
                          Colors.black
                              .withOpacity(.25),
                          Colors.black
                              .withOpacity(.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ========================================================
              // CONTENT
              // ========================================================

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
                        style: TextStyle(
                          color: Colors.white,
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
                          child: const Text(
                            'Order Now',
                            style: TextStyle(
                              color:
                              Colors.black54,
                              fontSize: 10,
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
        10,
        20,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight:
                FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: onTap,
            child: Text(
              'See All',
              style: TextStyle(
                color:
                Theme.of(context)
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
    final isEmpty =
        _searchController.text
            .trim()
            .isEmpty;

    final currentHint =
    _searchHints[_searchHintIndex];

    return Container(
      height: 52,
      margin:
      const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color:
        Theme.of(context).brightness ==
            Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),

          // ========================================================
          // SEARCH ICON
          // ========================================================

          Icon(
            Icons.search_rounded,
            size: 23,
            color: Colors.grey.shade400,
          ),

          const SizedBox(width: 10),

          // ========================================================
          // SEARCH FIELD
          // ========================================================

          Expanded(
            child: Stack(
              alignment:
              Alignment.centerLeft,
              children: [
                TextField(
                  controller:
                  _searchController,
                  textInputAction:
                  TextInputAction.search,
                  decoration:
                  const InputDecoration(
                    border:
                    InputBorder.none,
                    enabledBorder:
                    InputBorder.none,
                    focusedBorder:
                    InputBorder.none,
                    isDense: true,
                    contentPadding:
                    EdgeInsets.zero,
                  ),
                  style:
                  const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),

                // ==================================================
                // ANIMATED HINT
                // ==================================================

                if (isEmpty)
                  Positioned.fill(
                    child: IgnorePointer(
                      child:
                      AnimatedSwitcher(
                        duration:
                        const Duration(
                          milliseconds: 600,
                        ),
                        reverseDuration:
                        const Duration(
                          milliseconds: 450,
                        ),
                        switchInCurve:
                        Curves.easeOutCubic,
                        switchOutCurve:
                        Curves.easeInCubic,
                        transitionBuilder:
                            (
                            child,
                            animation,
                            ) {
                          final offset =
                          Tween<Offset>(
                            begin:
                            const Offset(
                              0,
                              .30,
                            ),
                            end:
                            Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve:
                              Curves.easeOutCubic,
                            ),
                          );

                          return FadeTransition(
                            opacity: animation,
                            child:
                            SlideTransition(
                              position: offset,
                              child: child,
                            ),
                          );
                        },
                        child: Align(
                          alignment:
                          Alignment.centerLeft,
                          child: Text(
                            'Search "$currentHint"',
                            key: ValueKey(
                              currentHint,
                            ),
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors
                                  .grey
                                  .shade500,
                              fontWeight:
                              FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ========================================================
          // CLEAR
          // ========================================================

          if (!isEmpty)
            IconButton(
              onPressed:
              _clearSearch,
              padding: EdgeInsets.zero,
              constraints:
              const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              icon: Icon(
                Icons.close_rounded,
                size: 20,
                color:
                Colors.grey.shade500,
              ),
            ),

          // ========================================================
          // DIVIDER
          // ========================================================

          Container(
            width: 1,
            height: 27,
            color:
            Colors.grey.withOpacity(.18),
          ),

          // ========================================================
          // MICROPHONE
          // ========================================================

          IconButton(
            onPressed:
            _toggleListening,
            padding: EdgeInsets.zero,
            constraints:
            const BoxConstraints(
              minWidth: 45,
              minHeight: 45,
            ),
            icon:
            AnimatedSwitcher(
              duration:
              const Duration(
                milliseconds: 250,
              ),
              transitionBuilder:
                  (
                  child,
                  animation,
                  ) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Icon(
                _isListening
                    ? Icons.mic_rounded
                    : Icons.mic_none_rounded,
                key: ValueKey(
                  _isListening,
                ),
                size: 21,
                color: _isListening
                    ? Colors.redAccent
                    : MilestoneApp6Colors
                    .green,
              ),
            ),
          ),

          const SizedBox(width: 5),
        ],
      ),
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
        color:
        Theme.of(context)
            .scaffoldBackgroundColor,
        elevation:
        overlapsContent ? 3 : 0,
        shadowColor:
        Colors.black.withOpacity(.12),
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