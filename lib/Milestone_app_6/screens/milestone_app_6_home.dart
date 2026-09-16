import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../data/milestone_app_6_food.dart';
import '../state/milestone_app_6_state.dart';
import '../theme/milestone_app_6_colors.dart';
import '../widgets/milestone_app_6_category.dart';
import '../widgets/milestone_app_6_food_card.dart';
import '../widgets/milestone_app_6_image.dart';
import '../widgets/milestone_app_6_home_restaurant_card.dart';

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
  // CATEGORY STATE
  // ==============================================================

  String _selectedCategory = 'All';

  // ==============================================================
  // SEARCH
  // ==============================================================

  final TextEditingController _searchController =
  TextEditingController();

  // ==============================================================
  // SPEECH SEARCH
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

    _initializeSpeech();
  }

  // ==============================================================
  // SPEECH INITIALIZATION
  // ==============================================================

  Future<void> _initializeSpeech() async {
    final available = await _speech.initialize(
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


    if (_isListening) {
      await _speech.stop();

      if (!mounted) return;

      setState(() {
        _isListening = false;
      });

      return;
    }


    setState(() {
      _isListening = true;
    });

    await _speech.listen(
      listenMode: stt.ListenMode.search,
      partialResults: true,
      onResult: (result) {
        if (!mounted) return;

        setState(() {
          _searchController.text = result.recognizedWords;

          _searchController.selection =
              TextSelection.fromPosition(
                TextPosition(
                  offset: _searchController.text.length,
                ),
              );
        });
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


  List<MilestoneApp6Food> get _filteredFoods {
    Iterable<MilestoneApp6Food> result =
        milestoneApp6Foods;

    // ------------------------------------------------------------
    // CATEGORY FILTER
    // ------------------------------------------------------------

    if (_selectedCategory != 'All') {
      result = result.where(
            (food) =>
        food.category.toLowerCase() ==
            _selectedCategory.toLowerCase(),
      );
    }

    // ------------------------------------------------------------
    // SEARCH FILTER
    // ------------------------------------------------------------

    final query =
    _searchController.text.trim().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where(
            (food) {
          final name = food.name.toLowerCase();
          final category = food.category.toLowerCase();
          final restaurant = food.restaurant.toLowerCase();

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
    setState(() {
      _searchController.clear();
    });
  }

  // ==============================================================
  // RESTAURANT ITEM
  // ==============================================================

  Widget _restaurantItem({
    required String name,
    required String image,
    required String rating,
    required String time,
  }) {
    return AnimatedBuilder(
      animation: widget.state,
      builder: (context, child) {
        final theme = Theme.of(context);

        final isFavorite =
        widget.state.isRestaurantSaved(name);

        return SizedBox(
          width: 250,
          child: Stack(
            children: [
              // ====================================================
              // RESTAURANT CARD
              // ====================================================

              Positioned.fill(
                child: MilestoneApp6RestaurantCard(
                  name: name,
                  image: image,
                  rating: rating,
                  time: time,
                ),
              ),

              // ====================================================
              // FAVORITE BUTTON
              // ====================================================

              Positioned(
                right: 8,
                top: 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      widget.state.toggleRestaurantSaved(
                        name,
                      );
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: AnimatedContainer(
                      duration:
                      const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: theme
                            .colorScheme
                            .surface
                            .withOpacity(0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                            Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration:
                        const Duration(milliseconds: 180),
                        transitionBuilder:
                            (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          key: ValueKey(isFavorite),
                          size: 15,
                          color: isFavorite
                              ? Colors.red
                              : theme
                              .iconTheme
                              .color
                              ?.withOpacity(0.75),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final isTablet = screenWidth >= 700;

    final foods = _filteredFoods;

    return CustomScrollView(
      slivers: [
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

        SliverPersistentHeader(
          pinned: true,
          delegate:
          MilestoneApp6HomeStickyHeaderDelegate(
            minHeight:
            MediaQuery.paddingOf(context).top + 151,
            maxHeight:
            MediaQuery.paddingOf(context).top + 151,
            child: Container(
              color:
              Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  SizedBox(
                    height:
                    55 +
                        MediaQuery.paddingOf(context).top,
                    child: SafeArea(
                      bottom: true,
                      child: _buildSearchBar(context),
                    ),
                  ),

                  SizedBox(
                    height: 94,
                    child: _buildCategoryRow(),
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


        SliverToBoxAdapter(
          child: _banner(context),
        ),

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
            height: 115,
            child: ListView(
              padding:
              const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _restaurantItem(
                  name: 'The Italian Bistro',
                  image:
                  'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500',
                  rating: '4.5',
                  time: '20-30 min',
                ),

                const SizedBox(width: 12),

                _restaurantItem(
                  name: 'Sushi World',
                  image:
                  'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=500',
                  rating: '4.7',
                  time: '25-35 min',
                ),

                const SizedBox(width: 12),

                _restaurantItem(
                  name: 'Burger Hub',
                  image:
                  'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
                  rating: '4.6',
                  time: '15-25 min',
                ),

                const SizedBox(width: 12),

                _restaurantItem(
                  name: 'Green Bowl',
                  image:
                  'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500',
                  rating: '4.8',
                  time: '15-25 min',
                ),

                const SizedBox(width: 12),

                _restaurantItem(
                  name: 'Pasta Corner',
                  image:
                  'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=500',
                  rating: '4.5',
                  time: '20-30 min',
                ),

                const SizedBox(width: 12),

                _restaurantItem(
                  name: 'Fresh Bites',
                  image:
                  'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=500',
                  rating: '4.7',
                  time: '15-25 min',
                ),

                const SizedBox(width: 12),

                _restaurantItem(
                  name: 'Morning Cafe',
                  image:
                  'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500',
                  rating: '4.6',
                  time: '10-20 min',
                ),

                const SizedBox(width: 12),

                _restaurantItem(
                  name: 'Asian Kitchen',
                  image:
                  'https://images.unsplash.com/photo-1515003197210-e0cd71810b5f?w=500',
                  rating: '4.8',
                  time: '25-35 min',
                ),
              ],
            ),
          ),
        ),


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

        if (foods.isEmpty)
          SliverToBoxAdapter(
            child: _buildEmptyFoodState(context),
          ),


        if (foods.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              24,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final food = foods[index];

                  return AnimatedBuilder(
                    animation: widget.state,
                    builder: (
                        context,
                        child,
                        ) {
                      return MilestoneApp6FoodCard(
                        food: food,
                        state: widget.state,
                        onTap: () {
                          context.push(
                            '/food/${food.id}',
                          );
                        },
                      );
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

  Widget _buildCategoryRow() {
    // Create "All" using the SAME category model
    // as every other category.
    final allCategory = MilestoneApp6Category(
      'All',
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=500',
    );

    final categories = [
      allCategory,
      ...milestoneApp6Categories,
    ];

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
        final category = categories[index];

        final isSelected =
            _selectedCategory == category.name;

        return MilestoneApp6CategoryChip(
          category: category,
          selected: isSelected,
          onTap: () {
            _selectCategory(category.name);
          },
        );
      },
    );
  }


  Widget _buildEmptyFoodState(
      BuildContext context,
      ) {
    final theme = Theme.of(context);

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
              color: theme
                  .colorScheme
                  .primary
                  .withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 36,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'No food found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            _searchController.text.isNotEmpty
                ? 'Try another search or category.'
                : 'No items are available in this category.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
            ),
          ),

          const SizedBox(height: 18),

          if (_searchController.text.isNotEmpty)
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

  Widget _banner(BuildContext context) {
    final width =
        MediaQuery.sizeOf(context).width;

    final isTablet = width >= 700;

    final bannerHeight =
    isTablet ? 150.0 : 140.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
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

              Container(
                decoration:
                const BoxDecoration(
                  gradient: LinearGradient(
                    begin:
                    Alignment.centerLeft,
                    end:
                    Alignment.centerRight,
                    colors: [
                      MilestoneApp6Colors.orangeDark,
                      Color(0xFF9E260D),
                    ],
                  ),
                ),
              ),

              // ====================================================
              // FOOD IMAGE
              // ====================================================

              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: isTablet
                    ? width * 0.48
                    : width * 0.52,
                child: MilestoneApp6Image(
                  url:
                  'https://images.unsplash.com/photo-1550547660-d9450f859349?w=1000',
                  fit: BoxFit.cover,
                ),
              ),

              // ====================================================
              // IMAGE GRADIENT
              // ====================================================

              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration:
                    BoxDecoration(
                      gradient: LinearGradient(
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
                          MilestoneApp6Colors
                              .orangeDark,
                          MilestoneApp6Colors
                              .orangeDark
                              .withOpacity(.98),
                          MilestoneApp6Colors
                              .orangeDark
                              .withOpacity(.35),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ====================================================
              // CONTENT
              // ====================================================

              Positioned(
                left: 18,
                top: 15,
                bottom: 15,
                child: SizedBox(
                  width: isTablet
                      ? width * 0.42
                      : width * 0.43,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // ==================================================
                      // TITLE
                      // ==================================================

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

                      // ==================================================
                      // BUTTON
                      // ==================================================

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
                                .orange,
                            borderRadius:
                            BorderRadius
                                .circular(10),
                          ),
                          child: const Text(
                            'Order Now',
                            style: TextStyle(
                              color: Colors.white,
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
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        12,
      ),
      child: Row(
        children: [
          // ========================================================
          // TITLE
          // ========================================================

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

          // ========================================================
          // SEE ALL
          // ========================================================

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

  Widget _buildSearchBar(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final isDark =
        theme.brightness ==
            Brightness.dark;

    final hasSearch =
        _searchController.text
            .trim()
            .isNotEmpty;

    return Container(
      color:
      theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(
        14,
        0,
        14,
        7,
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF242424)
              : Colors.white,
          borderRadius:
          BorderRadius.circular(13),
          border: Border.all(
            color: isDark
                ? Colors.white
                .withOpacity(.08)
                : const Color(0xFFE5E5E5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(.08),
              blurRadius: 12,
              offset:
              const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // ======================================================
            // SEARCH ICON
            // ======================================================

            Padding(
              padding:
              const EdgeInsets.only(
                left: 13,
                right: 9,
              ),
              child: Icon(
                Icons.search_rounded,
                size: 23,
                color: isDark
                    ? Colors.white70
                    : const Color(
                  0xFF198754,
                ),
              ),
            ),

            // ======================================================
            // TEXT FIELD
            // ======================================================

            Expanded(
              child: TextField(
                controller:
                _searchController,
                textInputAction:
                TextInputAction.search,
                textAlignVertical:
                TextAlignVertical.center,
                onChanged: (value) {
                  setState(() {});
                },
                onSubmitted: (value) {
                  setState(() {});
                },
                decoration:
                InputDecoration(
                  hintText:
                  _isListening
                      ? 'Listening...'
                      : 'Search "comfort food"',
                  hintStyle:
                  TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w400,
                    color: isDark
                        ? Colors.white54
                        : const Color(
                      0xFF777777,
                    ),
                  ),
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
              ),
            ),

            // ======================================================
            // CLEAR SEARCH
            // ======================================================

            if (hasSearch)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _clearSearch,
                  borderRadius:
                  BorderRadius.circular(
                    30,
                  ),
                  child: const SizedBox(
                    width: 36,
                    height: 42,
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                    ),
                  ),
                ),
              ),

            // ======================================================
            // DIVIDER
            // ======================================================

            Container(
              width: 1,
              height: 28,
              color: isDark
                  ? Colors.white12
                  : const Color(
                0xFFE6E6E6,
              ),
            ),

            // ======================================================
            // MICROPHONE
            // ======================================================

            Padding(
              padding:
              const EdgeInsets.only(
                left: 4,
                right: 4,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap:
                  _toggleListening,
                  borderRadius:
                  BorderRadius.circular(
                    30,
                  ),
                  child:
                  AnimatedContainer(
                    duration:
                    const Duration(
                      milliseconds: 200,
                    ),
                    width: 42,
                    height: 42,
                    decoration:
                    BoxDecoration(
                      color: _isListening
                          ? MilestoneApp6Colors
                          .orange
                          .withOpacity(
                        .12,
                      )
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child:
                    AnimatedSwitcher(
                      duration:
                      const Duration(
                        milliseconds: 180,
                      ),
                      child: Icon(
                        _isListening
                            ? Icons.mic
                            : Icons
                            .mic_none_rounded,
                        key: ValueKey(
                          _isListening,
                        ),
                        size: 22,
                        color: _isListening
                            ? MilestoneApp6Colors
                            .orange
                            : isDark
                            ? Colors
                            .white70
                            : const Color(
                          0xFF198754,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 3),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// STICKY SEARCH + CATEGORY HEADER
// ============================================================================

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
        color: Theme.of(context)
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