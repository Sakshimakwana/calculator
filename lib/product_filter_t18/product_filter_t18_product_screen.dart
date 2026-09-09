import 'package:app_matic_tech_flutter_app/product_filter_t18/theme/product_filter_t18_colors.dart';
import 'package:app_matic_tech_flutter_app/product_filter_t18/theme/product_filter_t18_typography.dart';
import 'package:app_matic_tech_flutter_app/product_filter_t18/widgets/product_filter_t18_delete_dialog.dart';
import 'package:app_matic_tech_flutter_app/product_filter_t18/widgets/product_filter_t18_filter_bottom_sheet.dart';
import 'package:app_matic_tech_flutter_app/product_filter_t18/widgets/product_filter_t18_logout_dialog.dart';
import 'package:app_matic_tech_flutter_app/product_filter_t18/widgets/product_filter_t18_product_card.dart';
import 'package:app_matic_tech_flutter_app/product_filter_t18/widgets/product_filter_t18_product_data.dart';
import 'package:app_matic_tech_flutter_app/product_filter_t18/widgets/product_filter_t18_product_model.dart';
import 'package:app_matic_tech_flutter_app/product_filter_t18/widgets/product_filter_t18_sort_dialog.dart';
import 'package:app_matic_tech_flutter_app/splash_screen.dart';
import 'package:flutter/material.dart';

class ProductFilterT18ProductScreen extends StatefulWidget {
  const ProductFilterT18ProductScreen({
    super.key,
    required this.favoriteProductIds,
    required this.onFavorite,
  });

  final Set<int> favoriteProductIds;

  final void Function(int productId) onFavorite;

  @override
  State<ProductFilterT18ProductScreen> createState() =>
      _ProductFilterT18ProductScreenState();
}

class _ProductFilterT18ProductScreenState
    extends State<ProductFilterT18ProductScreen> {

  final List<ProductFilterT18ProductModel> _products =
  List.from(ProductFilterT18ProductData.products);

  List<ProductFilterT18ProductModel> _visibleProducts = [];

  @override
  void initState() {
    super.initState();

    _visibleProducts = List.from(_products);
  }

  // =====================================================
  // FILTER
  // =====================================================

  Future<void> _openFilter() async {
    final result =
    await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return const ProductFilterT18FilterBottomSheet();
      },
    );

    if (result == null) {
      return;
    }

    final String category = result['category'];
    final double minPrice = result['minPrice'];
    final double maxPrice = result['maxPrice'];
    final int rating = result['rating'];
    final bool inStock = result['inStock'];

    setState(() {
      _visibleProducts = _products.where((product) {

        final categoryMatch =
            category == 'All' ||
                product.category == category;

        final priceMatch =
            product.price >= minPrice &&
                product.price <= maxPrice;

        final ratingMatch =
            product.rating >= rating;

        final stockMatch =
            !inStock || product.inStock;

        return categoryMatch &&
            priceMatch &&
            ratingMatch &&
            stockMatch;

      }).toList();
    });
  }

  // =====================================================
  // SORT
  // =====================================================

  Future<void> _openSortDialog() async {
    final String? selectedSort =
    await showDialog<String>(
      context: context,
      builder: (context) {
        return const ProductFilterT18SortDialog();
      },
    );

    if (selectedSort == null) {
      return;
    }

    setState(() {

      if (selectedSort == 'Price: Low to High') {
        _visibleProducts.sort(
              (a, b) => a.price.compareTo(b.price),
        );
      }

      if (selectedSort == 'Price: High to Low') {
        _visibleProducts.sort(
              (a, b) => b.price.compareTo(a.price),
        );
      }

      if (selectedSort == 'Rating: High to Low') {
        _visibleProducts.sort(
              (a, b) => b.rating.compareTo(a.rating),
        );
      }
    });
  }

  // =====================================================
  // DELETE
  // =====================================================

  Future<void> _deleteProduct(
      ProductFilterT18ProductModel product,
      ) async {

    final bool? shouldDelete =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return const ProductFilterT18DeleteDialog();
      },
    );

    if (shouldDelete == true) {
      setState(() {

        _products.remove(product);

        _visibleProducts.remove(product);

        widget.favoriteProductIds.remove(product.id);
      });
    }
  }

  // =====================================================
  // LOGOUT
  // =====================================================

  Future<void> _logout() async {

    final bool? shouldLogout =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return const ProductFilterT18LogoutDialog();
      },
    );

    if (shouldLogout == true && mounted) {

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
            (route) => false,
      );
    }
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      ProductFilterT18Colors.background,

      appBar: AppBar(
        backgroundColor:
        ProductFilterT18Colors.primary,

        foregroundColor: Colors.white,

        elevation: 0,

        titleSpacing: 16,

        title: const Text(
          'Products',
          style:
          ProductFilterT18Typography.appBarTitle,
        ),

        actions: [

          IconButton(
            onPressed: _openFilter,

            icon: const Icon(
              Icons.filter_alt_outlined,
              size: 21,
            ),
          ),

          IconButton(
            onPressed: _logout,

            icon: const Icon(
              Icons.logout_outlined,
              size: 20,
            ),
          ),
        ],
      ),

      body: Column(
        children: [

          // =================================================
          // PRODUCT COUNT + SORT
          // =================================================

          Container(
            height: 50,

            color: Colors.white,

            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),

            child: Row(
              children: [

                Expanded(
                  child: Text(
                    '${_visibleProducts.length} Products',

                    style:
                    ProductFilterT18Typography
                        .productName,
                  ),
                ),

                TextButton(
                  onPressed: _openSortDialog,

                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),

                  child: const Text(
                    'Sort',

                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,

                      color:
                      ProductFilterT18Colors
                          .textPrimary,
                    ),
                  ),
                ),

                const Icon(
                  Icons.swap_vert,
                  size: 14,
                ),
              ],
            ),
          ),

          // =================================================
          // PRODUCT LIST
          // =================================================

          Expanded(
            child: _visibleProducts.isEmpty

                ? const Center(
              child: Text(
                'No products found',

                style:
                ProductFilterT18Typography
                    .sectionTitle,
              ),
            )

                : ListView.builder(

              padding:
              const EdgeInsets.fromLTRB(
                8,
                8,
                8,
                12,
              ),

              itemCount:
              _visibleProducts.length,

              itemBuilder:
                  (context, index) {

                final product =
                _visibleProducts[index];

                return ProductFilterT18ProductCard(

                  product: product,

                  // Shared favorite status
                  isFavorite:
                  widget.favoriteProductIds
                      .contains(product.id),

                  // Shared favorite logic
                  onFavorite: () {
                    widget.onFavorite(
                      product.id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}