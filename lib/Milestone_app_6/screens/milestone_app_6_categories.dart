import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/milestone_app_6_food.dart';
import '../state/milestone_app_6_state.dart';
import '../widgets/milestone_app_6_category.dart';
import '../widgets/milestone_app_6_food_card.dart';

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
  // ==========================================================================
  // CATEGORY
  // ==========================================================================

  int selected = 0;

  // ==========================================================================
  // FILTER VALUES
  // ==========================================================================

  String selectedSort = 'Recommended';

  double? selectedRating;

  String selectedPrice = 'All';

  // ==========================================================================
  // FILTER COUNT
  // ==========================================================================

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

  // ==========================================================================
  // FILTERED FOOD
  // ==========================================================================

  List<MilestoneApp6Food> _getFilteredFoods() {
    final category =
        milestoneApp6Categories[selected].name;

    // --------------------------------------------------------------
    // STEP 1: CATEGORY FILTER
    // --------------------------------------------------------------

    List<MilestoneApp6Food> filteredFoods =
    milestoneApp6Foods
        .where(
          (food) => food.category == category,
    )
        .toList();

    // --------------------------------------------------------------
    // STEP 2: RATING FILTER
    // --------------------------------------------------------------

    if (selectedRating != null) {
      filteredFoods = filteredFoods
          .where(
            (food) => food.rating >= selectedRating!,
      )
          .toList();
    }

    // --------------------------------------------------------------
    // STEP 3: PRICE FILTER
    // --------------------------------------------------------------

    switch (selectedPrice) {
      case 'Under \$10':
        filteredFoods = filteredFoods
            .where(
              (food) => food.price < 10,
        )
            .toList();
        break;

      case '\$10 - \$20':
        filteredFoods = filteredFoods
            .where(
              (food) =>
          food.price >= 10 &&
              food.price <= 20,
        )
            .toList();
        break;

      case '\$20+':
        filteredFoods = filteredFoods
            .where(
              (food) => food.price > 20,
        )
            .toList();
        break;
    }

    // --------------------------------------------------------------
    // STEP 4: SORT
    // --------------------------------------------------------------

    switch (selectedSort) {
      case 'Rating: High to Low':
        filteredFoods.sort(
              (a, b) => b.rating.compareTo(a.rating),
        );
        break;

      case 'Price: Low to High':
        filteredFoods.sort(
              (a, b) => a.price.compareTo(b.price),
        );
        break;

      case 'Price: High to Low':
        filteredFoods.sort(
              (a, b) => b.price.compareTo(a.price),
        );
        break;

      case 'Recommended':
      default:
      // Recommended:
      // Higher rating first.
      // If ratings are same, lower price first.
        filteredFoods.sort(
              (a, b) {
            final ratingComparison =
            b.rating.compareTo(a.rating);

            if (ratingComparison != 0) {
              return ratingComparison;
            }

            return a.price.compareTo(b.price);
          },
        );
        break;
    }

    return filteredFoods;
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final category =
        milestoneApp6Categories[selected].name;

    final foods = _getFilteredFoods();

    final isTablet =
        MediaQuery.sizeOf(context).width >= 700;

    final columns = isTablet ? 4 : 2;

    return CustomScrollView(
      slivers: [
        // =====================================================================
        // APP BAR
        // =====================================================================

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
        ),

        // =====================================================================
        // CATEGORY LIST
        // =====================================================================

        SliverToBoxAdapter(
          child: SizedBox(
            height: 112,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                14,
              ),
              scrollDirection: Axis.horizontal,
              itemCount:
              milestoneApp6Categories.length,
              separatorBuilder: (_, __) =>
              const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final category =
                milestoneApp6Categories[index];

                return MilestoneApp6CategoryChip(
                  category: category,
                  selected: selected == index,
                  onTap: () {
                    setState(() {
                      selected = index;
                    });
                  },
                );
              },
            ),
          ),
        ),

        // =====================================================================
        // TITLE + FILTER BUTTON
        // =====================================================================

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              4,
              20,
              12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$category Food',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // ------------------------------------------------------------
                // FILTER BUTTON
                // ------------------------------------------------------------

                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _showFilterBottomSheet(context);
                    },
                    borderRadius:
                    BorderRadius.circular(20),
                    child: Padding(
                      padding:
                      const EdgeInsets.all(6),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.tune,
                            size: 21,
                          ),

                          if (activeFilterCount > 0)
                            Positioned(
                              right: -5,
                              top: -5,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration:
                                BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  )
                                      .colorScheme
                                      .primary,
                                  shape:
                                  BoxShape.circle,
                                ),
                                alignment:
                                Alignment.center,
                                child: Text(
                                  '$activeFilterCount',
                                  style:
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight:
                                    FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // =====================================================================
        // FILTER RESULT INFO
        // =====================================================================

        if (activeFilterCount > 0)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                12,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt_outlined,
                    size: 16,
                    color:
                    Theme.of(context)
                        .colorScheme
                        .primary,
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      '$activeFilterCount filter${activeFilterCount == 1 ? '' : 's'} applied',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        Theme.of(context)
                            .colorScheme
                            .primary,
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedSort =
                        'Recommended';
                        selectedRating = null;
                        selectedPrice = 'All';
                      });
                    },
                    child: const Text(
                      'Reset',
                    ),
                  ),
                ],
              ),
            ),
          ),

        // =====================================================================
        // NO RESULTS
        // =====================================================================

        if (foods.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _emptyFilterResult(
              context,
              category,
            ),
          )
        else
        // ================================================================
        // FOOD GRID
        // ================================================================

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              20,
              0,
              20,
              30,
            ),
            sliver: SliverGrid(
              delegate:
              SliverChildBuilderDelegate(
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
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent:
                isTablet ? 300 : 245,
              ),
            ),
          ),
      ],
    );
  }

  // ==========================================================================
  // FILTER BOTTOM SHEET
  // ==========================================================================

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
      Theme.of(context).colorScheme.surface,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (
              context,
              setSheetState,
              ) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  4,
                  20,
                  20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // ======================================================
                      // HEADER
                      // ======================================================

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Filter',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight:
                                FontWeight.w800,
                              ),
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              setSheetState(() {
                                tempSort =
                                'Recommended';
                                tempRating = null;
                                tempPrice = 'All';
                              });
                            },
                            child: const Text(
                              'Reset',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ======================================================
                      // SORT BY
                      // ======================================================

                      const Text(
                        'Sort By',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 8),

                      _radioOption(
                        context,
                        title: 'Recommended',
                        value: 'Recommended',
                        groupValue: tempSort,
                        onChanged: (value) {
                          setSheetState(() {
                            tempSort = value;
                          });
                        },
                      ),

                      _radioOption(
                        context,
                        title:
                        'Rating: High to Low',
                        value:
                        'Rating: High to Low',
                        groupValue: tempSort,
                        onChanged: (value) {
                          setSheetState(() {
                            tempSort = value;
                          });
                        },
                      ),

                      _radioOption(
                        context,
                        title:
                        'Price: Low to High',
                        value:
                        'Price: Low to High',
                        groupValue: tempSort,
                        onChanged: (value) {
                          setSheetState(() {
                            tempSort = value;
                          });
                        },
                      ),

                      _radioOption(
                        context,
                        title:
                        'Price: High to Low',
                        value:
                        'Price: High to Low',
                        groupValue: tempSort,
                        onChanged: (value) {
                          setSheetState(() {
                            tempSort = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // ======================================================
                      // RATING
                      // ======================================================

                      const Text(
                        'Rating',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 8),

                      _ratingOption(
                        context,
                        title: 'Any Rating',
                        rating: null,
                        selected:
                        tempRating == null,
                        onTap: () {
                          setSheetState(() {
                            tempRating = null;
                          });
                        },
                      ),

                      _ratingOption(
                        context,
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
                        context,
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
                        context,
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

                      const SizedBox(height: 20),

                      // ======================================================
                      // PRICE
                      // ======================================================

                      const Text(
                        'Price Range',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _priceChip(
                            context,
                            label: 'All',
                            selected:
                            tempPrice == 'All',
                            onTap: () {
                              setSheetState(() {
                                tempPrice = 'All';
                              });
                            },
                          ),

                          _priceChip(
                            context,
                            label: 'Under \$10',
                            selected:
                            tempPrice ==
                                'Under \$10',
                            onTap: () {
                              setSheetState(() {
                                tempPrice =
                                'Under \$10';
                              });
                            },
                          ),

                          _priceChip(
                            context,
                            label: '\$10 - \$20',
                            selected:
                            tempPrice ==
                                '\$10 - \$20',
                            onTap: () {
                              setSheetState(() {
                                tempPrice =
                                '\$10 - \$20';
                              });
                            },
                          ),

                          _priceChip(
                            context,
                            label: '\$20+',
                            selected:
                            tempPrice == '\$20+',
                            onTap: () {
                              setSheetState(() {
                                tempPrice = '\$20+';
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ======================================================
                      // APPLY BUTTON
                      // ======================================================

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
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
                            style: TextStyle(
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

  // ==========================================================================
  // RADIO OPTION
  // ==========================================================================

  Widget _radioOption(
      BuildContext context, {
        required String title,
        required String value,
        required String groupValue,
        required ValueChanged<String> onChanged,
      }) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
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

  // ==========================================================================
  // RATING OPTION
  // ==========================================================================

  Widget _ratingOption(
      BuildContext context, {
        required String title,
        required double? rating,
        required bool selected,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 7,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              .withOpacity(0.08)
              : Colors.transparent,
          borderRadius:
          BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.dividerColor
                .withOpacity(0.25),
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              size: 20,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.hintColor,
            ),

            const SizedBox(width: 10),

            if (rating != null) ...[
              const Icon(
                Icons.star_rounded,
                size: 18,
                color: Colors.amber,
              ),

              const SizedBox(width: 5),
            ],

            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: selected
                    ? theme.colorScheme.primary
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // PRICE CHIP
  // ==========================================================================

  Widget _priceChip(
      BuildContext context, {
        required String label,
        required bool selected,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              .withOpacity(0.10)
              : theme.colorScheme.surface,
          borderRadius:
          BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
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
                ? theme.colorScheme.primary
                : null,
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // EMPTY FILTER RESULT
  // ==========================================================================

  Widget _emptyFilterResult(
      BuildContext context,
      String category,
      ) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary
                    .withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.filter_alt_off_outlined,
                size: 42,
                color:
                theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'No food found',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'No $category food matches your selected filters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 13,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 18),

            OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedSort =
                  'Recommended';
                  selectedRating = null;
                  selectedPrice = 'All';
                });
              },
              child: const Text(
                'Reset Filters',
              ),
            ),
          ],
        ),
      ),
    );
  }
}