import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/milestone_app_6_food.dart';
import '../data/milestone_app_6_order.dart';
import '../data/milestone_app_6_restaurants_data.dart';

import '../state/milestone_app_6_state.dart';
import '../theme/milestone_app_6_colors.dart';

class MilestoneApp6ProfileScreen
    extends StatelessWidget {
  final MilestoneApp6State state;

  const MilestoneApp6ProfileScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (
          context,
          child,
          ) {
        final dark =
            state.themeMode ==
                ThemeMode.dark;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.go('/home');
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: const Text(
              'Profile',
            ),
          ),

          body: ListView(
            padding:
            const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              30,
            ),
            children: [
              // ==========================================================
              // PROFILE
              // ==========================================================

              const CircleAvatar(
                radius: 44,
                backgroundColor:
                Color(0xFFFFE1D7),
                child: Icon(
                  Icons.person,
                  size: 54,
                  color:
                  MilestoneApp6Colors
                      .orange,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              const Text(
                'Sakshi Darji',
                textAlign:
                TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              Text(
                'sakshi@example.com',
                textAlign:
                TextAlign.center,
                style: TextStyle(
                  color:
                  Theme.of(context)
                      .hintColor,
                  fontSize: 12,
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              // ==========================================================
              // MY ORDERS
              // ==========================================================

              _item(
                context,
                Icons.receipt_long_outlined,
                'My Orders',
                trailingText:
                state.orders.isNotEmpty
                    ? '${state.orders.length}'
                    : null,
                onTap: () {
                  _showOrders(context);
                },
              ),

              // ==========================================================
              // FAVORITE PRODUCTS
              // ==========================================================

              _item(
                context,
                Icons.favorite_border,
                'Favorite Products',
                trailingText:
                state.saved.isNotEmpty
                    ? '${state.saved.length}'
                    : null,
                onTap: () {
                  _showFavoriteProducts(
                    context,
                  );
                },
              ),

              // ==========================================================
              // SAVED RESTAURANTS
              // ==========================================================

              _item(
                context,
                Icons.restaurant_outlined,
                'Saved Restaurants',
                trailingText:
                state.savedRestaurants
                    .isNotEmpty
                    ? '${state.savedRestaurants.length}'
                    : null,
                onTap: () {
                  _showFavoriteRestaurants(
                    context,
                  );
                },
              ),

              // ==========================================================
              // PAYMENT METHODS
              // ==========================================================

              _item(
                context,
                Icons.credit_card_outlined,
                'Payment Methods',
                onTap: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Payment Methods coming soon.',
                      ),
                    ),
                  );
                },
              ),

              // ==========================================================
              // THEME
              // ==========================================================

              SwitchListTile(
                contentPadding:
                EdgeInsets.zero,

                secondary:
                const Icon(
                  Icons.dark_mode_outlined,
                ),

                title: const Text(
                  'Theme',
                ),

                subtitle: Text(
                  dark
                      ? 'Dark'
                      : 'Light',
                ),

                value: dark,

                onChanged:
                state.setDarkMode,
              ),

              // ==========================================================
              // SETTINGS
              // ==========================================================

              _item(
                context,
                Icons.settings_outlined,
                'Settings',
                onTap: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Settings coming soon.',
                      ),
                    ),
                  );
                },
              ),

              // ==========================================================
              // LOGOUT
              // ==========================================================

              _item(
                context,
                Icons.logout,
                'Logout',
                onTap: () {
                  _showLogoutDialog(
                    context,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================================================================
  // PROFILE ITEM
  // ================================================================

  Widget _item(
      BuildContext context,
      IconData icon,
      String title, {
        VoidCallback? onTap,
        String? trailingText,
      }) {
    return ListTile(
      contentPadding:
      EdgeInsets.zero,

      leading: Icon(
        icon,
        color:
        MilestoneApp6Colors.orange,
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight:
          FontWeight.w500,
        ),
      ),

      trailing: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 3,
              ),
              decoration:
              BoxDecoration(
                color:
                MilestoneApp6Colors
                    .orange
                    .withOpacity(0.12),
                borderRadius:
                BorderRadius.circular(
                  10,
                ),
              ),
              child: Text(
                trailingText,
                style:
                const TextStyle(
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w700,
                  color:
                  MilestoneApp6Colors
                      .orange,
                ),
              ),
            ),

            const SizedBox(
              width: 8,
            ),
          ],

          const Icon(
            Icons.chevron_right,
            size: 20,
          ),
        ],
      ),

      onTap: onTap,
    );
  }

  // ================================================================
  // MY ORDERS
  // ================================================================

  void _showOrders(
      BuildContext context,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height:
            MediaQuery.of(context)
                .size
                .height *
                0.78,
            child: Padding(
              padding:
              const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                20,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  const Text(
                    'My Orders',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Expanded(
                    child: state
                        .orders
                        .isEmpty
                        ? _emptyState(
                      icon: Icons
                          .receipt_long_outlined,
                      title:
                      'No orders yet',
                      subtitle:
                      'Your confirmed orders will appear here.',
                    )
                        : ListView
                        .separated(
                      itemCount:
                      state.orders
                          .length,
                      separatorBuilder:
                          (
                          _,
                          __,
                          ) =>
                      const SizedBox(
                        height: 12,
                      ),
                      itemBuilder:
                          (
                          context,
                          index,
                          ) {
                        return _orderCard(
                          context,
                          state.orders[
                          index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ================================================================
  // ORDER CARD
  // ================================================================

  Widget _orderCard(
      BuildContext context,
      MilestoneApp6Order order,
      ) {
    final theme =
    Theme.of(context);

    return Container(
      padding:
      const EdgeInsets.all(12),
      decoration:
      BoxDecoration(
        color: theme.cardColor,
        borderRadius:
        BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color: theme.dividerColor
              .withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // IMAGE

          ClipRRect(
            borderRadius:
            BorderRadius.circular(
              12,
            ),
            child: Image.network(
              order.food.image,
              width: 78,
              height: 78,
              fit: BoxFit.cover,
              errorBuilder:
                  (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Container(
                  width: 78,
                  height: 78,
                  color:
                  theme.dividerColor,
                  child: const Icon(
                    Icons.restaurant,
                  ),
                );
              },
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          // DETAILS

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  order.food.name,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  const TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  order.food.restaurant,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color:
                    theme.hintColor,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  '${order.quantity} × \$${order.unitPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                    theme.hintColor,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  'Size: ${order.size}',
                  style: TextStyle(
                    fontSize: 11,
                    color:
                    theme.colorScheme
                        .primary,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 7,
                ),

                Row(
                  children: [
                    Container(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration:
                      BoxDecoration(
                        color: Colors.green
                            .withOpacity(
                          0.12,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          8,
                        ),
                      ),
                      child:
                      const Text(
                        'Confirmed',
                        style:
                        TextStyle(
                          color:
                          Colors.green,
                          fontSize: 10,
                          fontWeight:
                          FontWeight
                              .w700,
                        ),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      '\$${order.totalPrice.toStringAsFixed(2)}',
                      style:
                      const TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // FAVORITE PRODUCTS
  // ================================================================

  void _showFavoriteProducts(
      BuildContext context,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return AnimatedBuilder(
          animation: state,
          builder: (
              context,
              child,
              ) {
            final foods =
            milestoneApp6Foods
                .where(
                  (food) => state.saved
                  .contains(
                food.id,
              ),
            )
                .toList();

            return SafeArea(
              child: SizedBox(
                height:
                MediaQuery.of(
                  context,
                ).size.height *
                    0.72,
                child: Padding(
                  padding:
                  const EdgeInsets
                      .fromLTRB(
                    20,
                    10,
                    20,
                    20,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      const Text(
                        'Favorite Products',
                        style:
                        TextStyle(
                          fontSize: 22,
                          fontWeight:
                          FontWeight
                              .w800,
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      Expanded(
                        child: foods.isEmpty
                            ? _emptyState(
                          icon: Icons
                              .favorite_border,
                          title:
                          'No favorite products',
                          subtitle:
                          'Products you favorite will appear here.',
                        )
                            : ListView
                            .separated(
                          itemCount:
                          foods
                              .length,
                          separatorBuilder:
                              (
                              _,
                              __,
                              ) =>
                          const SizedBox(
                            height: 10,
                          ),
                          itemBuilder:
                              (
                              context,
                              index,
                              ) {
                            return _favoriteFoodCard(
                              context,
                              foods[
                              index],
                            );
                          },
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

  // ================================================================
  // FAVORITE PRODUCT CARD
  // ================================================================

  Widget _favoriteFoodCard(
      BuildContext context,
      MilestoneApp6Food food,
      ) {
    final theme =
    Theme.of(context);

    return Container(
      padding:
      const EdgeInsets.all(10),
      decoration:
      BoxDecoration(
        color: theme.cardColor,
        borderRadius:
        BorderRadius.circular(
          14,
        ),
        border: Border.all(
          color: theme.dividerColor
              .withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
            BorderRadius.circular(
              10,
            ),
            child: Image.network(
              food.image,
              width: 65,
              height: 65,
              fit: BoxFit.cover,
              errorBuilder:
                  (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Container(
                  width: 65,
                  height: 65,
                  color:
                  theme.dividerColor,
                  child: const Icon(
                    Icons.restaurant,
                  ),
                );
              },
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  food.name,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  food.restaurant,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color:
                    theme.hintColor,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color:
                      Colors.amber,
                      size: 15,
                    ),

                    const SizedBox(
                      width: 3,
                    ),

                    Text(
                      food.rating
                          .toString(),
                      style:
                      const TextStyle(
                        fontSize: 11,
                        fontWeight:
                        FontWeight
                            .w600,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      '\$${food.price.toStringAsFixed(2)}',
                      style:
                      const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight
                            .w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              state.toggleSaved(
                food.id,
              );

              Navigator.of(
                context,
              ).pop();
            },
            icon: const Icon(
              Icons.favorite_rounded,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SAVED RESTAURANTS
  // ================================================================

  void _showFavoriteRestaurants(
      BuildContext context,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return AnimatedBuilder(
          animation: state,
          builder: (
              context,
              child,
              ) {
            final savedRestaurants =
            restaurants.where(
                  (restaurant) {
                return state.isRestaurantSaved(
                  restaurant.name,
                );
              },
            ).toList();

            return SafeArea(
              child: SizedBox(
                height:
                MediaQuery.of(
                  context,
                ).size.height *
                    0.68,
                child: Padding(
                  padding:
                  const EdgeInsets
                      .fromLTRB(
                    20,
                    10,
                    20,
                    20,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      const Text(
                        'Saved Restaurants',
                        style:
                        TextStyle(
                          fontSize: 22,
                          fontWeight:
                          FontWeight
                              .w800,
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      Expanded(
                        child: savedRestaurants
                            .isEmpty
                            ? _emptyState(
                          icon: Icons
                              .restaurant_outlined,
                          title:
                          'No saved restaurants',
                          subtitle:
                          'Restaurants you favorite will appear here.',
                        )
                            : ListView
                            .separated(
                          itemCount:
                          savedRestaurants
                              .length,
                          separatorBuilder:
                              (
                              _,
                              __,
                              ) =>
                          const SizedBox(
                            height: 10,
                          ),
                          itemBuilder:
                              (
                              context,
                              index,
                              ) {
                            return _restaurantFavoriteCard(
                              context,
                              savedRestaurants[
                              index],
                            );
                          },
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

  // ================================================================
  // RESTAURANT FAVORITE CARD
  // ================================================================

  Widget _restaurantFavoriteCard(
      BuildContext context,
      MilestoneApp6Restaurant restaurant,
      ) {
    final theme =
    Theme.of(context);

    return Container(
      padding:
      const EdgeInsets.all(12),
      decoration:
      BoxDecoration(
        color: theme.cardColor,
        borderRadius:
        BorderRadius.circular(
          14,
        ),
        border: Border.all(
          color: theme.dividerColor
              .withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
            BorderRadius.circular(
              12,
            ),
            child: Image.network(
              restaurant.image,
              width: 62,
              height: 62,
              fit: BoxFit.cover,
              errorBuilder:
                  (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Container(
                  width: 62,
                  height: 62,
                  color:
                  theme.dividerColor,
                  child: const Icon(
                    Icons.restaurant,
                  ),
                );
              },
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  restaurant.name,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  const TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  restaurant.cuisine,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color:
                    theme.hintColor,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color:
                      Colors.amber,
                      size: 15,
                    ),

                    const SizedBox(
                      width: 3,
                    ),

                    Text(
                      restaurant.rating,
                      style:
                      const TextStyle(
                        fontSize: 11,
                        fontWeight:
                        FontWeight
                            .w600,
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Text(
                      restaurant.time,
                      style: TextStyle(
                        fontSize: 11,
                        color:
                        theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              state.toggleRestaurantSaved(
                restaurant.name,
              );

              Navigator.of(
                context,
              ).pop();
            },
            icon: const Icon(
              Icons.favorite_rounded,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // EMPTY STATE
  // ================================================================

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 60,
              color: Colors.grey,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              title,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontSize: 17,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            Text(
              subtitle,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // LOGOUT
  // ================================================================

  void _showLogoutDialog(
      BuildContext context,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight:
              FontWeight.w800,
            ),
          ),

          content: const Text(
            'Are you sure you want to logout?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Logout functionality coming soon.',
                    ),
                  ),
                );
              },
              child: const Text(
                'Logout',
              ),
            ),
          ],
        );
      },
    );
  }
}