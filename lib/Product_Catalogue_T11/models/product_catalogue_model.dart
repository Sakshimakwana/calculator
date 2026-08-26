class ProductModel {
  final String name;
  final String image;
  final double price;
  final double rating;

  bool isFavorite;
  int quantity;

  ProductModel({
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    this.isFavorite = false,
    this.quantity = 0,
  });
}