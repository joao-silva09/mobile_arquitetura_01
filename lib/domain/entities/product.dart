class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final bool favorite;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.favorite = false,
  });

  Product copyWith({bool? favorite}) {
    return Product(
      id: id,
      title: title,
      price: price,
      image: image,
      favorite: favorite ?? this.favorite,
    );
  }
}
