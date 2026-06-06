/// Model data produk (donat dan minuman)
class ProductModel {
  final String id;
  final String name;
  final String category;
  final int price;
  final String description;
  final String composition;  // Komposisi bahan
  final String imageUrl;     // Placeholder emoji atau asset path
  final double rating;
  final int reviewCount;
  final int soldCount;
  final int stock;
  final bool isAvailable;
  final bool isHidden;       // Jika disembunyikan admin

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    this.composition = '',
    this.imageUrl = '',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.soldCount = 0,
    this.stock = 0,
    this.isAvailable = true,
    this.isHidden = false,
  });

  /// Apakah produk bisa dibeli (ada stok dan tersedia)
  bool get canBuy => isAvailable && stock > 0 && !isHidden;

  /// Label status stok
  String get stockLabel {
    if (isHidden) return 'Disembunyikan';
    if (stock == 0) return 'Habis';
    if (!isAvailable) return 'Tidak Tersedia';
    return 'Tersedia';
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    int? price,
    String? description,
    String? composition,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    int? soldCount,
    int? stock,
    bool? isAvailable,
    bool? isHidden,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      description: description ?? this.description,
      composition: composition ?? this.composition,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      soldCount: soldCount ?? this.soldCount,
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
      isHidden: isHidden ?? this.isHidden,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'composition': composition,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'soldCount': soldCount,
      'stock': stock,
      'isAvailable': isAvailable,
      'isHidden': isHidden,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: map['price'] ?? 0,
      description: map['description'] ?? '',
      composition: map['composition'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      soldCount: map['soldCount'] ?? 0,
      stock: map['stock'] ?? 0,
      isAvailable: map['isAvailable'] ?? true,
      isHidden: map['isHidden'] ?? false,
    );
  }
}
