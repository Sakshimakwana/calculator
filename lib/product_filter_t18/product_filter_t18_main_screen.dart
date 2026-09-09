import 'package:app_matic_tech_flutter_app/product_filter_t18/widgets/product_filter_t18_profile_screen.dart';
import 'package:flutter/material.dart';

import '../../product_filter_t18/product_filter_t18_product_screen.dart';
import '../shoppingflow_T20/screens/shoppingflow_T20_categories_screen.dart';
import 'widgets/product_filter_t18_Favorites_screen.dart';

class ProductFilterT18MainScreen extends StatefulWidget {
  const ProductFilterT18MainScreen({
    super.key,
    this.name,
    this.email,
    this.phone,
  });

  final String? name;
  final String? email;
  final String? phone;

  @override
  State<ProductFilterT18MainScreen> createState() =>
      _ProductFilterT18MainScreenState();
}

class _ProductFilterT18MainScreenState
    extends State<ProductFilterT18MainScreen> {

  int _currentIndex = 0;

  // Shared favorite products
  final Set<int> _favoriteProductIds = {};

  // Add / remove favorite
  void _toggleFavorite(int productId) {
    setState(() {
      if (_favoriteProductIds.contains(productId)) {
        _favoriteProductIds.remove(productId);
      } else {
        _favoriteProductIds.add(productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      // HOME
      ProductFilterT18ProductScreen(
        favoriteProductIds: _favoriteProductIds,
        onFavorite: _toggleFavorite,
      ),

      // CATEGORIES
      const ShoppingFlowT20CategoriesScreen(),

      // WISHLIST
      Productfiltert18FavouritesScreen(
        favoriteProductIds: _favoriteProductIds,
        onFavorite: _toggleFavorite,
      ),

      // PROFILE
      const Produuctfiltert18ProfileScreen(

      ),
    ];

    return PopScope(
      // Home = allow normal back
      // Other tabs = don't pop the MainScreen
      canPop: _currentIndex == 0,

      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        // Categories / Wishlist / Profile
        // Back → Home
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },

      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,

          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },

          type: BottomNavigationBarType.fixed,

          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Categories',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}