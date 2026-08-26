import 'package:flutter/material.dart';
import '../data/product_catalogue_data.dart';
import '../product_cataloge_screen.dart';
import '../theme/product_catalogue_colors.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'product_cataloge_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  // Search controller
  final TextEditingController searchController =
  TextEditingController();

  // Search text
  String searchText = '';

  // Show / hide search
  bool isSearching = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedScreen(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,

        selectedItemColor: AppColors1.primary,

        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // SCREEN SELECTION
  // ----------------------------------------------------------

  Widget _getSelectedScreen() {
    switch (selectedIndex) {
      case 0:
        return _homeScreen();

      case 1:
        return const CategoriesScreen();

      case 2:
        return const FavoritesScreen();

      case 3:
        return _cartScreen();

      case 4:
        return const ProfileScreen();

      default:
        return _homeScreen();
    }
  }

  // ----------------------------------------------------------
  // HOME SCREEN
  // ----------------------------------------------------------

  Widget _homeScreen() {
    // SEARCH LOGIC
    final filteredProducts =
    productCatalogueData.where((product) {
      return product.name
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors1.background,

      // ------------------------------------------------------
      // ONLY ONE APP BAR
      // ------------------------------------------------------

      appBar: AppBar(
        backgroundColor: AppColors1.background,

        title: isSearching
            ? TextField(
          controller: searchController,

          autofocus: true,

          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),

          onChanged: (value) {
            setState(() {
              searchText = value;
            });
          },
        )
            : const Text(
          'Product Catalogue',
        ),


        actions: [
          IconButton(
            icon: Icon(
              isSearching
                  ? Icons.close
                  : Icons.search,
            ),

            onPressed: () {
              setState(() {
                if (isSearching) {
                  // Close search
                  isSearching = false;

                  searchText = '';

                  searchController.clear();
                } else {
                  // Open search
                  isSearching = true;
                }
              });
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // --------------------------------------------------
          // PRODUCT TITLE
          // --------------------------------------------------

          if (!isSearching)
            const Padding(
              padding: EdgeInsets.fromLTRB(
                1, 1, 1, 1,
              ),



            ),
          // ======================================================
          // CATEGORIES HEADER
          // ======================================================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  'Categories',

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const CategoriesScreen(),
                      ),
                    );
                  },

                  child: const Text(
                    'View all',
                  ),
                ),
              ],
            ),
          ),

// ======================================================
// HORIZONTAL CATEGORIES
// ======================================================

          SizedBox(
            height: 105,

            child: ListView(
              scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              children: [
                _categoryItem(
                  icon: Icons.grid_view_rounded,
                  title: 'All',
                ),

                _categoryItem(
                  icon: Icons.phone_android,
                  title: 'Electronics',
                ),

                _categoryItem(
                  icon: Icons.checkroom,
                  title: 'Fashion',
                ),

                _categoryItem(
                  icon: Icons.home_outlined,
                  title: 'Home',
                ),

                _categoryItem(
                  icon: Icons.spa_outlined,
                  title: 'Beauty',
                ),
                _categoryItem(
                  icon: Icons.sports_cricket,
                  title: 'Sports',
                ),
              ],
            ),
          ),

          // --------------------------------------------------
          // PRODUCT GRID
          // --------------------------------------------------

          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
              child: Text(
                'No products found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(16),

              itemCount:
              filteredProducts.length,

              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,

                crossAxisSpacing: 12,

                mainAxisSpacing: 12,

                childAspectRatio: 0.70,
              ),

              itemBuilder: (
                  context,
                  index,
                  ) {
                final product =
                filteredProducts[index];

                return ProductCard(
                  product: product,

                  // ------------------------------------------------
                  // ❤️ FAVORITE
                  // ------------------------------------------------

                  onFavoriteTap: () {
                    setState(() {
                      product.isFavorite =
                      !product.isFavorite;
                    });

                    if (product.isFavorite) {
                      _showSnackBar(
                        'Added to favorites ❤️',
                      );
                    } else {
                      _showSnackBar(
                        'Removed from favorites',
                      );
                    }
                  },

                  // ------------------------------------------------
                  // 📱 PRODUCT DETAILS
                  // ------------------------------------------------

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) {
                          return ProductDetailsScreen(
                            product: product,
                          );
                        },
                      ),
                    );
                  },

                  // ------------------------------------------------
                  // 🛒 ADD TO CART
                  // ------------------------------------------------

                  onAddToCart: () {
                    setState(() {
                      product.quantity = 1;
                    });

                    _showSnackBar(
                      '${product.name} added to cart 🛒',
                    );
                  },

                  // ------------------------------------------------
                  // ➕ INCREASE
                  // ------------------------------------------------

                  onIncreaseQuantity: () {
                    setState(() {
                      product.quantity++;
                    });
                  },

                  // ------------------------------------------------
                  // ➖ DECREASE
                  // ------------------------------------------------

                  onDecreaseQuantity: () {
                    setState(() {
                      if (product.quantity > 1) {
                        product.quantity--;
                      } else {
                        product.quantity = 0;
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _categoryItem({
    required IconData icon,
    required String title,
  }) {
    return Container(
      width: 75,

      margin: const EdgeInsets.only(
        right: 12,
      ),

      child: Column(
        children: [
          CircleAvatar(
            radius: 28,

            backgroundColor:
            AppColors1.primary.withOpacity(0.10),

            child: Icon(
              icon,

              color:
              AppColors1.primary,

              size: 25,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            title,

            maxLines: 1,

            overflow:
            TextOverflow.ellipsis,

            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // SNACK BAR
  // ----------------------------------------------------------

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),

          duration: const Duration(
            seconds: 2,
          ),

          behavior: SnackBarBehavior.floating,

          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
  }

  // ----------------------------------------------------------
  // CART SCREEN
  // ----------------------------------------------------------

  Widget _cartScreen() {
    final cartProducts =
    productCatalogueData
        .where(
          (product) =>
      product.quantity > 0,
    )
        .toList();

    double total = 0;

    for (final product in cartProducts) {
      total +=
          product.price *
              product.quantity;
    }

    return Scaffold(
      backgroundColor:
      AppColors1.background,

      appBar: AppBar(
        title: const Text('Cart'),

        backgroundColor:
        AppColors1.primary,

        foregroundColor:
        Colors.white,
      ),

      body: cartProducts.isEmpty
          ? const Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      )
          : ListView.builder(
        padding:
        const EdgeInsets.all(16),

        itemCount:
        cartProducts.length,

        itemBuilder: (
            context,
            index,
            ) {
          final product =
          cartProducts[index];

          return Card(
            margin:
            const EdgeInsets.only(
              bottom: 12,
            ),

            child: Padding(
              padding:
              const EdgeInsets.all(12),

              child: Row(
                children: [
                  // IMAGE
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(
                      8,
                    ),

                    child:
                    Image.network(
                      product.image,

                      width: 70,

                      height: 70,

                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  // INFORMATION
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [
                        Text(
                          product.name,

                          style:
                          const TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        Text(
                          '₹${product.price.toStringAsFixed(2)}',
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (product
                                      .quantity >
                                      1) {
                                    product
                                        .quantity--;
                                  } else {
                                    product
                                        .quantity = 0;
                                  }
                                });
                              },

                              icon:
                              const Icon(
                                Icons
                                    .remove_circle_outline,
                              ),
                            ),

                            Text(
                              '${product.quantity}',

                              style:
                              const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            IconButton(
                              onPressed: () {
                                setState(() {
                                  product
                                      .quantity++;
                                });
                              },

                              icon:
                              const Icon(
                                Icons
                                    .add_circle_outline,
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
      ),

      bottomNavigationBar:
      cartProducts.isEmpty
          ? null
          : Padding(
        padding:
        const EdgeInsets.all(16),

        child: Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,

          children: [
            const Text(
              'Total',

              style: TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            Text(
              '₹${total.toStringAsFixed(2)}',

              style:
              const TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}