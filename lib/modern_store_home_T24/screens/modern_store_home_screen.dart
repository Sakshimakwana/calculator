import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/modern_store_home_products.dart';
import '../theme/modern_store_home_colors.dart';
import '../widgets/modern_store_home_bottom_nav.dart';
import '../widgets/modern_store_home_category_item.dart';
import '../widgets/modern_store_home_product_card.dart';

class ModernStoreHomeScreen extends StatefulWidget {
  const ModernStoreHomeScreen({super.key});

  @override
  State<ModernStoreHomeScreen> createState() =>
      _ModernStoreHomeScreenState();
}

class _ModernStoreHomeScreenState
    extends State<ModernStoreHomeScreen> {
  Future<void> _refresh() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Store refreshed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = ModernStoreHomeProducts.products;

    return Scaffold(
      backgroundColor:
      ModernStoreHomeColors.background,

      body: RefreshIndicator(
        color: ModernStoreHomeColors.primary,
        onRefresh: _refresh,

        child: CustomScrollView(
          physics:
          const AlwaysScrollableScrollPhysics(),

          slivers: [

            // =================================================
            // HERO + APP BAR
            // =================================================

            SliverAppBar(
              expandedHeight: 305,
              pinned: true,
              stretch: true,

              automaticallyImplyLeading: false,

              backgroundColor:
              ModernStoreHomeColors.primaryDark,

              foregroundColor: Colors.white,

              flexibleSpace: FlexibleSpaceBar(
                collapseMode:
                CollapseMode.parallax,

                background: Stack(
                  fit: StackFit.expand,
                  children: [

                    // =========================================
                    // HERO IMAGE
                    // =========================================

                    Image.network(
                      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=1200',
                      fit: BoxFit.cover,

                      loadingBuilder:
                          (context, child, progress) {
                        if (progress == null) {
                          return child;
                        }

                        return Container(
                          color:
                          ModernStoreHomeColors.primaryDark,
                          alignment: Alignment.center,
                          child:
                          const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      },

                      errorBuilder:
                          (context, error, stackTrace) {
                        return Container(
                          color:
                          ModernStoreHomeColors.primaryDark,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_outlined,
                            color: Colors.white,
                            size: 45,
                          ),
                        );
                      },
                    ),

                    // =========================================
                    // IMAGE GRADIENT
                    // =========================================

                    Container(
                      decoration:
                      const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xE6073B34),
                            Color(0x88073B34),
                            Color(0x15073B34),
                          ],
                        ),
                      ),
                    ),

                    // =========================================
                    // CONTENT
                    // =========================================

                    SafeArea(
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            // ===============================
                            // TOP BAR
                            // ===============================

                            SizedBox(
                              height: 58,
                              child: Row(
                                children: [

                                  IconButton(
                                    onPressed: () {},
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                      size: 23,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 4,
                                  ),

                                  const Text(
                                    'ShopEase',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                  ),

                                  const Spacer(),

                                  IconButton(
                                    onPressed: () {},
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 23,
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      context.go(
                                        '/modern-store-home/wishlist',
                                      );
                                    },
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),

                                  Stack(
                                    clipBehavior:
                                    Clip.none,
                                    children: [

                                      IconButton(
                                        onPressed: () {
                                          context.push(
                                            '/modern-store-home/cart',
                                          );
                                        },
                                        padding:
                                        EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons
                                              .shopping_cart_outlined,
                                          color: Colors.white,
                                          size: 23,
                                        ),
                                      ),

                                      Positioned(
                                        right: 0,
                                        top: -1,
                                        child: Container(
                                          width: 17,
                                          height: 17,
                                          alignment:
                                          Alignment.center,
                                          decoration:
                                          const BoxDecoration(
                                            color: Colors.red,
                                            shape:
                                            BoxShape.circle,
                                          ),
                                          child: const Text(
                                            '3',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight:
                                              FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          SizedBox(height: 40,),

                            // ===============================
                            // HERO TEXT
                            // ===============================

                            const Text(
                              'NEW COLLECTION',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                letterSpacing: 1.5,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),

                            const SizedBox(
                              height: 7,
                            ),

                            const Text(
                              'Make Your\nHome Beautiful',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                height: 1.08,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            const Text(
                              'Stylish products for a better living',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            // ===============================
                            // SHOP NOW
                            // ===============================

                            SizedBox(
                              height: 35,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.go(
                                    '/modern-store-home/deals',
                                  );
                                },
                                style:
                                ElevatedButton.styleFrom(
                                  backgroundColor:
                                  Colors.white,
                                  foregroundColor:
                                  ModernStoreHomeColors
                                      .primaryDark,
                                  elevation: 0,
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    horizontal: 17,
                                  ),
                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                      22,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Shop Now →',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            // ===============================
                            // DOTS
                            // ===============================

                            const Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                _HeroDot(active: true),
                                _HeroDot(),
                                _HeroDot(),
                                _HeroDot(),
                                _HeroDot(),
                              ],
                            ),

                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =================================================
            // CATEGORIES
            // =================================================

            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child: Column(
                  children: [

                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(
                        20,
                        10,
                        10,
                        10,
                      ),
                      child: Row(
                        children: [

                          const Expanded(
                            child: Text(
                              'Shop by Category',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight:
                                FontWeight.w700,
                                color:
                                ModernStoreHomeColors
                                    .text,
                              ),
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              context.go(
                                '/modern-store-home/categories',
                              );
                            },
                            child: const Row(
                              children: [
                                Text('View All'),
                                Icon(
                                  Icons.chevron_right,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 118,
                      child: ListView.separated(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        scrollDirection:
                        Axis.horizontal,
                        itemCount:
                        ModernStoreHomeProducts
                            .categories
                            .length,
                        separatorBuilder:
                            (_, __) {
                          return const SizedBox(
                            width: 13,
                          );
                        },
                        itemBuilder:
                            (context, index) {
                          final category =
                          ModernStoreHomeProducts
                              .categories[index];

                          return ModernStoreHomeCategoryItem(
                            category: category,
                            index: index,
                            onTap: () {
                              context.go(
                                '/modern-store-home/categories',
                                extra: category.name,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),


            SliverToBoxAdapter(
              child: Container(
                color:
                ModernStoreHomeColors.background,
                padding:
                const EdgeInsets.fromLTRB(
                  24,
                  24,
                  18,
                  14,
                ),
                child: Row(
                  children: [

                    const Expanded(
                      child: Text(
                        'Featured Products',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight:
                          FontWeight.w700,
                          color:
                          ModernStoreHomeColors.text,
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        context.go(
                          '/modern-store-home/deals',
                        );
                      },
                      child: const Row(
                        children: [
                          Text('View All'),
                          Icon(
                            Icons.chevron_right,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =================================================
            // FEATURED PRODUCTS
            // =================================================

            SliverPadding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              sliver: SliverGrid(
                delegate:
                SliverChildBuilderDelegate(
                      (context, index) {
                    return ModernStoreHomeProductCard(
                      product: products[index],
                    );
                  },
                  childCount: products.length,
                ),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: .68,
                ),
              ),
            ),

            // =================================================
            // BIG SAVINGS
            // =================================================

            SliverToBoxAdapter(
              child: Container(
                height: 190,
                margin: const EdgeInsets.fromLTRB(
                  20,
                  28,
                  20,
                  10,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color:
                  ModernStoreHomeColors.peach,
                  borderRadius:
                  BorderRadius.circular(22),
                ),
                child: Stack(
                  children: [

                    const Positioned(
                      left: 25,
                      top: 27,
                      child: Text(
                        'Big Savings\nOn Fashion',
                        style: TextStyle(
                          fontSize: 25,
                          height: 1.1,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),

                    const Positioned(
                      left: 25,
                      top: 92,
                      child: Text(
                        'Up to 50% OFF',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),

                    Positioned(
                      left: 25,
                      bottom: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go(
                            '/modern-store-home/deals',
                          );
                        },
                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          ModernStoreHomeColors
                              .primaryDark,
                          foregroundColor:
                          Colors.white,
                          elevation: 0,
                        ),
                        child:
                        const Text(
                          'Shop Now →',
                        ),
                      ),
                    ),

                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: 190,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=600',
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) {
                          return const Icon(
                            Icons.image_outlined,
                            size: 50,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =================================================
            // POPULAR HEADER
            // =================================================

            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding:
                const EdgeInsets.fromLTRB(
                  24,
                  22,
                  18,
                  14,
                ),
                child: const Text(
                  'Popular This Week',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ),

            // =================================================
            // POPULAR PRODUCTS
            // =================================================

            SliverPadding(
              padding:
              const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                30,
              ),
              sliver: SliverGrid(
                delegate:
                SliverChildBuilderDelegate(
                      (context, index) {
                    return ModernStoreHomeProductCard(
                      product: products[
                      (index + 5) %
                          products.length],
                    );
                  },
                  childCount: 8,
                ),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: .68,
                ),
              ),
            ),
          ],
        ),
      ),

      // =====================================================
      // BOTTOM NAVIGATION
      // =====================================================

      bottomNavigationBar:
      const ModernStoreHomeBottomNav(
        currentIndex: 0,
      ),
    );
  }
}

class _HeroDot extends StatelessWidget {
  final bool active;

  const _HeroDot({
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      const EdgeInsets.symmetric(
        horizontal: 3,
      ),
      width: active ? 8 : 6,
      height: active ? 8 : 6,
      decoration: BoxDecoration(
        color: active
            ? Colors.white
            : Colors.white54,
        shape: BoxShape.circle,
      ),
    );
  }
}