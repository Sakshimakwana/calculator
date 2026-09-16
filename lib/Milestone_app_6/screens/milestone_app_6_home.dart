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

class _MilestoneApp6HomeScreenState extends State<MilestoneApp6HomeScreen> {
  int categoryIndex = 0;

  final TextEditingController _searchController = TextEditingController();

  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;
  bool _speechAvailable = false;

  final Set<String> _favoriteRestaurants = <String>{};

  bool _isRestaurantFavorite(String name) {
    return _favoriteRestaurants.contains(name);
  }

  void _toggleRestaurantFavorite(String name) {
    setState(() {
      if (_favoriteRestaurants.contains(name)) {
        _favoriteRestaurants.remove(name);
      } else {
        _favoriteRestaurants.add(name);
      }
    });
  }
  Widget _restaurantItem({
    required String name,
    required String image,
    required String rating,
    required String time,
  }) {
    final isFavorite = _isRestaurantFavorite(name);

    return SizedBox(
      width: 250,
      child: Stack(
        children: [
          // Restaurant card
          Positioned.fill(
            child: MilestoneApp6RestaurantCard(
              name: name,
              image: image,
              rating: rating,
              time: time,
            ),
          ),

          // Favorite button - bottom right
          Positioned(
            right: 8,
            top: 8,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _toggleRestaurantFavorite(name);
                },
                borderRadius: BorderRadius.circular(30),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surface
                        .withOpacity(0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, animation) {
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
                          : Theme.of(context)
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
  }

  @override
  void initState() {
    super.initState();

    _initializeSpeech();
  }

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

          _searchController.selection = TextSelection.fromPosition(
            TextPosition(
              offset: _searchController.text.length,
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = categoryIndex == 0
        ? null
        : milestoneApp6Categories[categoryIndex - 1].name;

    final foods = selectedCategory == null
        ? milestoneApp6Foods
        : milestoneApp6Foods
            .where(
              (food) => food.category == selectedCategory,
            )
            .toList();

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = screenWidth >= 700;

    return CustomScrollView(
      slivers: [
// AppBar scrolls away
        SliverAppBar(
          pinned: false,
          floating: false,
          snap: false,
          expandedHeight: 135,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Foodie',
            style: TextStyle(

              fontWeight: FontWeight.w700,
            ),
          ),centerTitle: true,

          flexibleSpace: FlexibleSpaceBar(
            background: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  5,
                  20,
                  5,
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
                    const SizedBox(height: 3),
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
          delegate: MilestoneApp6SearchHeaderDelegate(
            child: _buildSearchBar(context),
            topSafeArea: MediaQuery.paddingOf(context).top,
          ),
        ),

        SliverToBoxAdapter(
          child: _banner(context),
        ),

        SliverToBoxAdapter(
          child: _sectionTitle(
            context,
            'Categories',
            () {
              context.go('/categories');
            },
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 88,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: milestoneApp6Categories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {

                if (index == 0) {
                  final isSelected = categoryIndex == 0;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        categoryIndex = 0;
                      });
                    },
                    child: SizedBox(
                      width: 72,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: isSelected ? 1.05 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              width: 58,
                              height: 58,
                              padding: EdgeInsets.all(
                                isSelected ? 2.5 : 1.5,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? MilestoneApp6Colors.orange
                                    : Theme.of(context)
                                    .dividerColor
                                    .withOpacity(.25),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surface,
                                ),
                                child: const CircleAvatar(
                                  backgroundColor:
                                  MilestoneApp6Colors.orange,
                                  child: Icon(
                                    Icons.restaurant_menu_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            'All',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? MilestoneApp6Colors.orange
                                  : Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final category = milestoneApp6Categories[index - 1];

                return MilestoneApp6CategoryChip(
                  category: category,
                  selected: categoryIndex == index,
                  onTap: () {
                    setState(() {
                      categoryIndex = index;
                    });
                  },
                );
              },
            ),
          ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              scrollDirection: Axis.horizontal,
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
            selectedCategory ?? 'Popular Food',
            () {
              context.go('/categories');
            },
          ),
        ),


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
                  builder: (context, child) {
                    return MilestoneApp6FoodCard(
                      food: food,
                      state: widget.state,
                      onTap: () {
                        context.push('/food/${food.id}');
                      },
                    );
                  },
                );
              },
              childCount: foods.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 4 : 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,


              mainAxisExtent: isTablet ? 300 : 245,
            ),
          ),
        ),
      ],
    );
  }

  Widget _banner(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final isTablet = width >= 700;

    final bannerHeight = isTablet ? 150.0 : 140.0;

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
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
// ============================================================
// BACKGROUND
// ============================================================

              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      MilestoneApp6Colors.orangeDark,
                      Color(0xFF9E260D),
                    ],
                  ),
                ),
              ),

// ============================================================
// FOOD IMAGE
// ============================================================

              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: isTablet ? width * 0.48 : width * 0.52,
                child: MilestoneApp6Image(
                  url:
                      'https://images.unsplash.com/photo-1550547660-d9450f859349?w=1000',
                  fit: BoxFit.cover,
                ),
              ),

// ============================================================
// IMAGE GRADIENT OVERLAY
// ============================================================

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
                          MilestoneApp6Colors.orangeDark,
                          MilestoneApp6Colors.orangeDark.withOpacity(0.98),
                          MilestoneApp6Colors.orangeDark.withOpacity(0.35),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

// ============================================================
// CONTENT
// ============================================================

              Positioned(
                left: 18,
                top: 15,
                bottom: 15,
                child: SizedBox(
                  width: isTablet ? width * 0.42 : width * 0.43,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
// ----------------------------------------------------
// TITLE
// ----------------------------------------------------

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

// ----------------------------------------------------
// BUTTON
// ----------------------------------------------------

                      GestureDetector(
                        onTap: () {
                          context.go('/categories');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: MilestoneApp6Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Order Now',
                            style: TextStyle(
                              color: Colors.white,
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

// ---------------------------------------------------------------------
// SECTION TITLE
// ---------------------------------------------------------------------

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
          const SizedBox(width: 12),
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

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: theme.scaffoldBackgroundColor,
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
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(.08)
                : const Color(0xFFE5E5E5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // SEARCH ICON
            Padding(
              padding: const EdgeInsets.only(
                left: 13,
                right: 9,
              ),
              child: Icon(
                Icons.search_rounded,
                size: 23,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF198754),
              ),
            ),

            // TEXT FIELD
            Expanded(
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) {
                  setState(() {});
                },
                onSubmitted: (value) {
                  // Search action can be added here.
                },
                decoration: InputDecoration(
                  hintText: _isListening
                      ? 'Listening...'
                      : 'Search "comfort food"',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? Colors.white54
                        : const Color(0xFF777777),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),

            // DIVIDER
            Container(
              width: 1,
              height: 28,
              color: isDark
                  ? Colors.white12
                  : const Color(0xFFE6E6E6),
            ),

            // MICROPHONE
            Padding(
              padding: const EdgeInsets.only(
                left: 4,
                right: 4,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _toggleListening,
                  borderRadius: BorderRadius.circular(30),
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _isListening
                          ? MilestoneApp6Colors.orange
                          .withOpacity(.12)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 180,
                      ),
                      child: Icon(
                        _isListening
                            ? Icons.mic
                            : Icons.mic_none_rounded,
                        key: ValueKey(_isListening),
                        size: 22,
                        color: _isListening
                            ? MilestoneApp6Colors.orange
                            : isDark
                            ? Colors.white70
                            : const Color(0xFF198754),
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
class MilestoneApp6SearchHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double topSafeArea;

  MilestoneApp6SearchHeaderDelegate({
    required this.child,
    required this.topSafeArea,
  });

  @override
  double get minExtent =>
      55 + topSafeArea;

  @override
  double get maxExtent =>
      55 + topSafeArea;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return SafeArea(
      top: true,
      bottom: false,
      child: child,
    );
  }

  @override
  bool shouldRebuild(
      covariant MilestoneApp6SearchHeaderDelegate
      oldDelegate,
      ) {
    return oldDelegate.topSafeArea !=
        topSafeArea ||
        oldDelegate.child != child;
  }
}
