class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final int stock;
  final String thumbnail;
  final bool favorite;

  const Product({
    required this.id,
    required this.title,
    this.description = '',
    this.category = '',
    required this.price,
    this.rating = 0,
    this.stock = 0,
    String? thumbnail,
    String? image,
    this.favorite = false,
  }) : thumbnail = thumbnail ?? image ?? '';

  String get image => thumbnail;

  Product copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    double? price,
    double? rating,
    int? stock,
    String? thumbnail,
    bool? favorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      thumbnail: thumbnail ?? this.thumbnail,
      favorite: favorite ?? this.favorite,
    );
  }
}
