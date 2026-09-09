import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/shoppingflow_T20_data.dart';
import 'theme/shoppingflow_T20_colors.dart';
import 'theme/shoppingflow_T20_typography.dart';
import 'widgets/shoppingflow_T20_category_item.dart';
import 'widgets/shoppingflow_T20_product_card.dart';
import 'widgets/shoppingflow_T20_section_title.dart';

class ShoppingFlowT20HomeScreen
    extends StatelessWidget {
  const ShoppingFlowT20HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style:
          ShoppingFlowT20Typography.heading,
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/search');
            },
            icon: const Icon(Icons.search),
          ),
          const Icon(Icons.notifications_none),
          const SizedBox(width: 12),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // SALE BANNER
          Container(
            height: 145,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7650E8),
                  Color(0xFF8D69EF),
                ],
              ),
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Summer\nSale',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          height: 1,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Up to 50% Off',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 30,
                        child: FilledButton(
                          style:
                          FilledButton.styleFrom(
                            backgroundColor:
                            Colors.white,
                            foregroundColor:
                            ShoppingFlowT20Colors
                                .primary,
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 12,
                            ),
                            minimumSize:
                            Size.zero,
                            tapTargetSize:
                            MaterialTapTargetSize
                                .shrinkWrap,
                          ),
                          onPressed: () {
                            context.go(
                              '/categories',
                            );
                          },
                          child: const Text(
                            'Shop Now',
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                  size: 70,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const ShoppingFlowT20SectionTitle(
            title: 'Categories',
            action: 'See all',
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              ShoppingFlowT20CategoryItem(
                name: 'Men',
                icon: Icons.man,
                onTap: () {
                  context.go('/categories/Men');
                },
              ),
              ShoppingFlowT20CategoryItem(
                name: 'Women',
                icon: Icons.woman,
                onTap: () {
                  context.go('/categories/Women');
                },
              ),
              ShoppingFlowT20CategoryItem(
                name: 'Shoes',
                icon: Icons.sports_soccer,
                onTap: () {
                  context.go('/categories/Shoes');
                },
              ),
              ShoppingFlowT20CategoryItem(
                name: 'Bags',
                icon: Icons.shopping_bag,
                onTap: () {
                  context.go('/categories/Bags');
                },
              ),
              ShoppingFlowT20CategoryItem(
                name: 'Watch',
                icon: Icons.watch,
                onTap: () {
                  context.go('/categories/Watches');
                },
              ),
            ],
          ),

          const SizedBox(height: 22),

          const ShoppingFlowT20SectionTitle(
            title: 'Best Selling',
            action: 'See all',
          ),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            itemCount: 3,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: .64,
            ),
            itemBuilder: (_, index) {
              return ShoppingFlowT20ProductCard(
                product:
                shoppingFlowT20Products[index],
              );
            },
          ),
        ],
      ),
    );
  }
}