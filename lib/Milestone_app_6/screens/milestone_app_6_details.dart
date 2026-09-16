import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/milestone_app_6_food.dart';
import '../state/milestone_app_6_state.dart';
import '../widgets/milestone_app_6_button.dart';
import '../widgets/milestone_app_6_details_shimmer.dart';
import '../widgets/milestone_app_6_image.dart';

class MilestoneApp6FoodDetailsScreen extends StatefulWidget {
  final String id;
  final MilestoneApp6State state;

  const MilestoneApp6FoodDetailsScreen({
    super.key,
    required this.id,
    required this.state,
  });

  @override
  State<MilestoneApp6FoodDetailsScreen> createState() =>
      _MilestoneApp6FoodDetailsScreenState();
}

class _MilestoneApp6FoodDetailsScreenState
    extends State<MilestoneApp6FoodDetailsScreen> {
  // ================================================================
  // QUANTITY
  // ================================================================

  int quantity = 1;

  // ================================================================
  // SIZE
  // ================================================================

  String size = 'Small';

  // ================================================================
  // LOADING
  // ================================================================

  bool _isLoading = true;

  // ================================================================
  // INIT
  // ================================================================

  @override
  void initState() {
    super.initState();

    _loadDetails();
  }

  // ================================================================
  // LOAD DETAILS
  // ================================================================

  Future<void> _loadDetails() async {
    await Future.delayed(
      const Duration(
        milliseconds: 1000,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  // ================================================================
  // SIZE PRICE
  // ================================================================

  double _sizePrice(
      double basePrice,
      ) {
    switch (size) {
      case 'Medium':
        return basePrice + 2.00;

      case 'Large':
        return basePrice + 4.00;

      case 'Small':
      default:
        return basePrice;
    }
  }

  // ================================================================
  // SIZE OPTION
  // ================================================================

  Widget _buildSizeOption({
    required String label,
    required double price,
  }) {
    final theme = Theme.of(context);

    final isSelected = size == label;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            size = label;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 200,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.10)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.dividerColor.withOpacity(0.30),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : null,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(
                '\$${price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // QUANTITY BUTTON
  // ================================================================

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  // ================================================================
  // ADD TO CART
  // ================================================================

  void _addToCart(
      BuildContext context,
      MilestoneApp6Food food,
      double currentPrice,
      ) {
    widget.state.addToCart(
      food,
      size: size,
      unitPrice: currentPrice,
      quantity: quantity,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
            ),

            const SizedBox(
              width: 10,
            ),

            Expanded(
              child: Text(
                '${food.name} added to cart successfully!',
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(
          seconds: 2,
        ),
      ),
    );
  }

  // ================================================================
  // BUY NOW
  // ================================================================
  //
  // IMPORTANT:
  // This navigation is required.
  //
  // Food Details
  //      ↓
  //    Buy Now
  //      ↓
  //   Checkout
  //
  // Pay Now logic is NOT handled here.
  // ================================================================

  void _buyNow(
      BuildContext context,
      MilestoneApp6Food food,
      double currentPrice,
      ) {
    final checkoutUrl = Uri(
      path: '/checkout',
      queryParameters: {
        'foodId': food.id,
        'size': size,
        'unitPrice': currentPrice.toString(),
        'quantity': quantity.toString(),
      },
    ).toString();

    context.push(checkoutUrl);
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    // ================================================================
    // SHIMMER
    // ================================================================

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              elevation: 3,
              shadowColor: Colors.black.withOpacity(0.20),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  context.pop();
                },
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          title: const Text(
            'Food Details',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: const MilestoneApp6DetailsShimmer(),
      );
    }

    // ================================================================
    // FIND FOOD
    // ================================================================

    final food = milestoneApp6Foods.firstWhere(
          (item) => item.id == widget.id,
    );

    // ================================================================
    // CURRENT PRICE
    // ================================================================

    final currentPrice = _sizePrice(
      food.price,
    );

    // ================================================================
    // TOTAL PRICE
    // ================================================================

    final totalPrice = currentPrice * quantity;

    final theme = Theme.of(context);

    // ================================================================
    // SCREEN
    // ================================================================

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ============================================================
          // APP BAR
          // ============================================================

          SliverAppBar(
            pinned: true,
            expandedHeight: 330,

            backgroundColor:
            Theme.of(context).colorScheme.surface,

            leadingWidth: 64,

            // ==========================================================
            // BACK BUTTON
            // ==========================================================

            leading: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 8,
                bottom: 8,
              ),
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.25),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    context.pop();
                  },
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),

            // ==========================================================
            // FAVORITE
            // ==========================================================

            actions: [
              AnimatedBuilder(
                animation: widget.state,
                builder: (
                    context,
                    child,
                    ) {
                  final isSaved =
                  widget.state.saved.contains(
                    food.id,
                  );

                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 12,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Material(
                      color: Theme.of(context)
                          .colorScheme
                          .surface,
                      elevation: 4,
                      shadowColor:
                      Colors.black.withOpacity(0.25),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder:
                        const CircleBorder(),
                        onTap: () {
                          widget.state.toggleSaved(
                            food.id,
                          );
                        },
                        child: Padding(
                          padding:
                          const EdgeInsets.all(10),
                          child: Icon(
                            isSaved
                                ? Icons.favorite_rounded
                                : Icons
                                .favorite_border_rounded,
                            size: 22,
                            color: isSaved
                                ? Colors.red
                                : Theme.of(context)
                                .iconTheme
                                .color,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],

            // ==========================================================
            // HERO IMAGE
            // ==========================================================

            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'food-${food.id}',
                child: MilestoneApp6Image(
                  url: food.image,
                  width: double.infinity,
                  height: 330,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),

          // ============================================================
          // DETAILS
          // ============================================================

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // ======================================================
                  // FOOD NAME
                  // ======================================================

                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  // ======================================================
                  // RESTAURANT
                  // ======================================================

                  Text(
                    food.restaurant,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.hintColor,
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  // ======================================================
                  // RATING + CATEGORY
                  // ======================================================

                  Row(
                    children: [
                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber
                              .withOpacity(0.12),
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 17,
                              color: Colors.amber,
                            ),

                            const SizedBox(
                              width: 4,
                            ),

                            Text(
                              food.rating
                                  .toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Text(
                        food.category,
                        style: TextStyle(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  // ======================================================
                  // PRICE
                  // ======================================================

                  AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    child: Text(
                      '\$${currentPrice.toStringAsFixed(2)}',
                      key: ValueKey(
                        currentPrice,
                      ),
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        color:
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // ======================================================
                  // DESCRIPTION
                  // ======================================================

                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    food.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: theme.hintColor,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // ======================================================
                  // CHOOSE SIZE
                  // ======================================================

                  const Text(
                    'Choose Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Row(
                    children: [
                      _buildSizeOption(
                        label: 'Small',
                        price: food.price,
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      _buildSizeOption(
                        label: 'Medium',
                        price: food.price + 2,
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      _buildSizeOption(
                        label: 'Large',
                        price: food.price + 4,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // ======================================================
                  // QUANTITY
                  // ======================================================

                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Row(
                    children: [
                      _quantityButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.w800,
                          ),
                        ),
                      ),

                      _quantityButton(
                        icon: Icons.add,
                        onTap: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // ======================================================
                  // TOTAL
                  // ======================================================

                  Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const Spacer(),

                      AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                        child: Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          key: ValueKey(
                            totalPrice,
                          ),
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight:
                            FontWeight.w900,
                            color: theme
                                .colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // ======================================================
                  // ADD TO CART + BUY NOW
                  // ======================================================

                  Row(
                    children: [
                      // ==================================================
                      // ADD TO CART
                      // ==================================================

                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () {
                              _addToCart(
                                context,
                                food,
                                currentPrice,
                              );
                            },
                            style:
                            OutlinedButton.styleFrom(
                              minimumSize:
                              const Size(
                                double.infinity,
                                52,
                              ),
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                horizontal: 8,
                              ),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(14),
                              ),
                              side: BorderSide(
                                color: theme
                                    .colorScheme
                                    .primary,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              'Add to Cart',
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight:
                                FontWeight.w800,
                                color: theme
                                    .colorScheme
                                    .primary,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      // ==================================================
                      // BUY NOW
                      // ==================================================

                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: MilestoneApp6Button(
                            label: 'Buy Now',
                            onPressed: () {
                              _buyNow(
                                context,
                                food,
                                currentPrice,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}