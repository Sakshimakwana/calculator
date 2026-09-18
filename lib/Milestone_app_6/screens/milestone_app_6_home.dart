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
    return AnimatedBuilder(
      animation: widget.state,
      builder: (context, child) {
        final theme = Theme.of(context);

        final isFavorite =
        widget.state.isRestaurantSaved(
          restaurant.name,
        );

        return Container(
          margin: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            18,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
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
            onTap: () {
              context.push(
                '/restaurant/${Uri.encodeComponent(
                  restaurant.name,
                )}',
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====================================================
                // IMAGE
                // ====================================================

                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MilestoneApp6Image(
                        url: restaurant.image,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.zero,
                      ),

                      // Gradient
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(.05),
                                Colors.black.withOpacity(.70),
                              ],
                              stops: const [
                                0.30,
                                0.60,
                                1.0,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Rating
                      Positioned(
                        left: 14,
                        bottom: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: Color(0xFFFFB300),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                restaurant.rating,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Favorite
                      Positioned(
                        right: 14,
                        top: 14,
                        child: Material(
                          color: Colors.white.withOpacity(.95),
                          shape: const CircleBorder(),
                          elevation: 2,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              widget.state
                                  .toggleRestaurantSaved(
                                restaurant.name,
                              );
                            },
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons
                                      .favorite_border_rounded,
                                  color: isFavorite
                                      ? Colors.red
                                      : Colors.black87,
                                  size: 21,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ====================================================
                // RESTAURANT DETAILS
                // ====================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    14,
                    13,
                    14,
                    14,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              restaurant.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color:
                              MilestoneApp6Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Text(
                        restaurant.cuisine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.hintColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 9),

                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 15,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            restaurant.time,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: theme.hintColor,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            restaurant.price,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              'Free delivery',
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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
      },
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

        final isFavorite =
        widget.state.isRestaurantSaved(
          restaurant.name,
        );

        final restaurantFoods =
        _restaurantFoods(
          restaurant.name,
        );

        // ----------------------------------------------------------
        // SEARCH / CATEGORY
        // ----------------------------------------------------------

        if (restaurantFoods.isEmpty &&
            (_searchController.text.trim().isNotEmpty ||
                _selectedCategory != 'All')) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            24,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius:
            BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.07),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // ====================================================
              // RESTAURANT IMAGE
              // ====================================================

              GestureDetector(
                onTap: () {
                  context.push(
                    '/restaurant/${Uri.encodeComponent(
                      restaurant.name,
                    )}',
                  );
                },
                child: SizedBox(
                  height: 205,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // ------------------------------------------------
                      // IMAGE
                      // ------------------------------------------------

                      MilestoneApp6Image(
                        url: restaurant.image,
                        fit: BoxFit.cover,
                        borderRadius:
                        BorderRadius.zero,
                      ),

                      // ------------------------------------------------
                      // GRADIENT
                      // ------------------------------------------------

                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient:
                            LinearGradient(
                              begin:
                              Alignment.topCenter,
                              end:
                              Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black
                                    .withOpacity(.10),
                                Colors.black
                                    .withOpacity(.85),
                              ],
                              stops: const [
                                .20,
                                .55,
                                1.0,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // ------------------------------------------------
                      // RATING
                      // ------------------------------------------------

                      Positioned(
                        left: 14,
                        top: 14,
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: Row(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 16,
                                color:
                                Color(0xFFFFB300),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                restaurant.rating,
                                style:
                                const TextStyle(
                                  color:
                                  Colors.black87,
                                  fontSize: 12,
                                  fontWeight:
                                  FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ------------------------------------------------
                      // FAVORITE
                      // ------------------------------------------------

                      Positioned(
                        right: 14,
                        top: 14,
                        child: Material(
                          color: Colors.white
                              .withOpacity(.95),
                          shape:
                          const CircleBorder(),
                          elevation: 2,
                          child: InkWell(
                            customBorder:
                            const CircleBorder(),
                            onTap: () {
                              widget.state
                                  .toggleRestaurantSaved(
                                restaurant.name,
                              );
                            },
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                child:
                                AnimatedSwitcher(
                                  duration:
                                  const Duration(
                                    milliseconds: 220,
                                  ),
                                  transitionBuilder:
                                      (
                                      Widget child,
                                      Animation<double>
                                      animation,
                                      ) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
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
                                    color: isFavorite
                                        ? Colors.red
                                        : Colors.black87,
                                    size: 21,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ------------------------------------------------
                      // RESTAURANT INFORMATION
                      // ------------------------------------------------

                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 15,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style:
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight:
                                FontWeight.w800,
                                height: 1.1,
                              ),
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              restaurant.cuisine,
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white
                                    .withOpacity(.90),
                                fontSize: 12,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),

                            const SizedBox(
                              height: 7,
                            ),

                            Row(
                              children: [
                                const Icon(
                                  Icons
                                      .access_time_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),

                                const SizedBox(
                                  width: 4,
                                ),

                                Text(
                                  restaurant.time,
                                  style:
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(
                                  width: 9,
                                ),

                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration:
                                  const BoxDecoration(
                                    color:
                                    Colors.white70,
                                    shape:
                                    BoxShape.circle,
                                  ),
                                ),

                                const SizedBox(
                                  width: 9,
                                ),

                                Text(
                                  restaurant.price,
                                  style:
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(
                                  width: 9,
                                ),

                                const Flexible(
                                  child: Text(
                                    'Free delivery',
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow
                                        .ellipsis,
                                    style:
                                    TextStyle(
                                      color:
                                      Colors.white,
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

                      // ------------------------------------------------
                      // ARROW
                      // ------------------------------------------------

                      Positioned(
                        right: 14,
                        bottom: 14,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration:
                          const BoxDecoration(
                            color:
                            MilestoneApp6Colors
                                .green,
                            shape:
                            BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons
                                .arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ====================================================
              // POPULAR DISHES HEADER
              // ====================================================

              // Padding(
              //   padding:
              //   const EdgeInsets.fromLTRB(
              //     16,
              //     15,
              //     16,
              //     5,
              //   ),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Text(
              //           'Popular Dishes',
              //           style: theme
              //               .textTheme
              //               .titleMedium
              //               ?.copyWith(
              //             fontWeight:
              //             FontWeight.w800,
              //           ),
              //         ),
              //       ),
              //
              //       GestureDetector(
              //         onTap: () {
              //           context.push(
              //             '/restaurant/${Uri.encodeComponent(
              //               restaurant.name,
              //             )}',
              //           );
              //         },
              //         child: Text(
              //           'View Menu',
              //           style: TextStyle(
              //             color: theme
              //                 .colorScheme.primary,
              //             fontSize: 12,
              //             fontWeight:
              //             FontWeight.w700,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // ====================================================
              // OFFER
              // ====================================================

              Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  16,
                  7,
                  16,
                  10,
                ),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme
                        .colorScheme
                        .primary
                        .withOpacity(.08),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_offer_rounded,
                        size: 17,
                        color: theme
                            .colorScheme.primary,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '20% OFF up to ₹100',
                        style: TextStyle(
                          color: theme
                              .colorScheme.primary,
                          fontSize: 11,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ====================================================
              // FOOD CARDS
              // ====================================================

              if (showFoodCards && restaurantFoods.isNotEmpty)
                SizedBox(
                  height: 280,
                  child: ListView.separated(
                    padding:
                    const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      16,
                    ),
                    scrollDirection:
                    Axis.horizontal,
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
                          onTap: () {
                            context.push(
                              '/food/${food.id}',
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              if (showFoodCards && restaurantFoods.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    18,
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
        // RESTAURANT TITLE
        // ==========================================================

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
            height: 280,

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

