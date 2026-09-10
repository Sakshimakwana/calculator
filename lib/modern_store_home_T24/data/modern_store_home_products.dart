class ModernStoreProduct {
  final int id;
  final String name;
  final String category;
  final String image;
  final double price;
  final double oldPrice;
  final int discount;

  const ModernStoreProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.discount,
  });
}

class ModernStoreCategory {
  final String name;
  final String image;

  const ModernStoreCategory({
    required this.name,
    required this.image,
  });
}

class ModernStoreHomeProducts {
  static const categories = [
    ModernStoreCategory(
      name: 'Furniture',
      image: 'https://cdn-icons-png.flaticon.com/512/3082/3082031.png',
    ),
    ModernStoreCategory(
      name: 'Fashion',
      image: 'https://cdn-icons-png.flaticon.com/512/892/892458.png',
    ),
    ModernStoreCategory(
      name: 'Electronics',
      image: 'https://cdn-icons-png.flaticon.com/512/3659/3659898.png',
    ),
    ModernStoreCategory(
      name: 'Beauty',
      image: 'https://cdn-icons-png.flaticon.com/512/2965/2965567.png',
    ),
    ModernStoreCategory(
      name: 'Home',
      image: 'https://cdn-icons-png.flaticon.com/512/619/619153.png',
    ),
  ];

  static const products = [
    ModernStoreProduct(
      id: 1,
      name: 'Trendy Sneakers',
      category: 'Fashion',
      image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
      price: 2499,
      oldPrice: 3499,
      discount: 29,
    ),
    ModernStoreProduct(
      id: 2,
      name: 'Smart Watch',
      category: 'Electronics',
      image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
      price: 4999,
      oldPrice: 6999,
      discount: 29,
    ),
    ModernStoreProduct(
      id: 3,
      name: 'Classic Handbag',
      category: 'Fashion',
      image: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=600',
      price: 1799,
      oldPrice: 2499,
      discount: 28,
    ),
    ModernStoreProduct(
      id: 4,
      name: 'Wireless Headphones',
      category: 'Electronics',
      image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
      price: 3499,
      oldPrice: 4999,
      discount: 30,
    ),
    ModernStoreProduct(
      id: 5,
      name: 'Minimal Chair',
      category: 'Furniture',
      image: 'https://images.unsplash.com/photo-1503602642458-232111445657?w=600',
      price: 5499,
      oldPrice: 7999,
      discount: 31,
    ),
    ModernStoreProduct(
      id: 6,
      name: 'Modern Table',
      category: 'Furniture',
      image: 'https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?w=600',
      price: 6999,
      oldPrice: 9999,
      discount: 30,
    ),
    ModernStoreProduct(
      id: 7,
      name: 'Ceramic Lamp',
      category: 'Home',
      image: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=600',
      price: 1499,
      oldPrice: 1999,
      discount: 25,
    ),
    ModernStoreProduct(
      id: 8,
      name: 'Indoor Plant',
      category: 'Home',
      image: 'https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=600',
      price: 899,
      oldPrice: 1299,
      discount: 31,
    ),
    ModernStoreProduct(
      id: 9,
      name: 'Premium Backpack',
      category: 'Fashion',
      image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600',
      price: 2199,
      oldPrice: 2999,
      discount: 27,
    ),
    ModernStoreProduct(
      id: 10,
      name: 'Cotton T-Shirt',
      category: 'Fashion',
      image: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600',
      price: 799,
      oldPrice: 1199,
      discount: 33,
    ),
    ModernStoreProduct(
      id: 11,
      name: 'Perfume',
      category: 'Beauty',
      image: 'https://images.unsplash.com/photo-1541643600914-78b084683601?w=600',
      price: 1899,
      oldPrice: 2499,
      discount: 24,
    ),
    ModernStoreProduct(
      id: 12,
      name: 'Skincare Set',
      category: 'Beauty',
      image: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600',
      price: 1299,
      oldPrice: 1799,
      discount: 28,
    ),
    ModernStoreProduct(
      id: 13,
      name: 'Bluetooth Speaker',
      category: 'Electronics',
      image: 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=600',
      price: 2299,
      oldPrice: 2999,
      discount: 23,
    ),
    ModernStoreProduct(
      id: 14,
      name: 'Digital Camera',
      category: 'Electronics',
      image: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600',
      price: 18999,
      oldPrice: 22999,
      discount: 17,
    ),
    ModernStoreProduct(
      id: 15,
      name: 'Travel Bottle',
      category: 'Home',
      image: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600',
      price: 599,
      oldPrice: 899,
      discount: 33,
    ),
    ModernStoreProduct(
      id: 16,
      name: 'Throw Pillow',
      category: 'Home',
      image: 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600',
      price: 699,
      oldPrice: 999,
      discount: 30,
    ),
  ];
}