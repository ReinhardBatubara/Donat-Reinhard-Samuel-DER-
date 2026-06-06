import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dummy_data.dart';
import '../data/local_storage.dart';
import '../models/product_model.dart';
import '../core/constants/app_strings.dart';

/// State untuk produk
class ProductState {
  final List<ProductModel> products;
  final String selectedCategory;
  final String searchQuery;
  final String sortBy; // 'cheapest', 'expensive', 'bestseller', 'rating'
  final bool isLoading;

  const ProductState({
    this.products = const [],
    this.selectedCategory = AppStrings.catAll,
    this.searchQuery = '',
    this.sortBy = 'default',
    this.isLoading = false,
  });

  /// Produk yang sudah difilter dan disortir
  List<ProductModel> get filteredProducts {
    var result = products.where((p) => !p.isHidden).toList();

    // Filter kategori
    if (selectedCategory != AppStrings.catAll) {
      result = result.where((p) => p.category == selectedCategory).toList();
    }

    // Filter pencarian
    if (searchQuery.isNotEmpty) {
      result = result
          .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    // Sorting
    switch (sortBy) {
      case 'cheapest':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'expensive':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'bestseller':
        result.sort((a, b) => b.soldCount.compareTo(a.soldCount));
        break;
      case 'rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return result;
  }

  /// Produk terlaris (top 5)
  List<ProductModel> get bestsellers {
    final available = products.where((p) => !p.isHidden && p.canBuy).toList();
    available.sort((a, b) => b.soldCount.compareTo(a.soldCount));
    return available.take(5).toList();
  }

  /// Produk rekomendasi (rating tertinggi)
  List<ProductModel> get recommended {
    final available = products.where((p) => !p.isHidden && p.canBuy).toList();
    available.sort((a, b) => b.rating.compareTo(a.rating));
    return available.take(6).toList();
  }

  ProductState copyWith({
    List<ProductModel>? products,
    String? selectedCategory,
    String? searchQuery,
    String? sortBy,
    bool? isLoading,
  }) {
    return ProductState(
      products: products ?? this.products,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier untuk mengelola produk
class ProductNotifier extends StateNotifier<ProductState> {
  ProductNotifier() : super(const ProductState()) {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    state = state.copyWith(isLoading: true);

    // Coba load dari local storage (admin mungkin sudah edit)
    final savedProducts = await LocalStorage.getProducts();
    if (savedProducts != null) {
      final products = savedProducts.map((m) => ProductModel.fromMap(m)).toList();
      state = state.copyWith(products: products, isLoading: false);
    } else {
      // Gunakan dummy data
      state = state.copyWith(products: DummyData.products, isLoading: false);
    }
  }

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSort(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  // =============================================
  // ADMIN: CRUD Produk
  // =============================================

  Future<void> addProduct(ProductModel product) async {
    final updated = [...state.products, product];
    state = state.copyWith(products: updated);
    await _saveProducts(updated);
  }

  Future<void> updateProduct(ProductModel updatedProduct) async {
    final updated = state.products.map((p) {
      return p.id == updatedProduct.id ? updatedProduct : p;
    }).toList();
    state = state.copyWith(products: updated);
    await _saveProducts(updated);
  }

  Future<void> deleteProduct(String productId) async {
    final updated = state.products.where((p) => p.id != productId).toList();
    state = state.copyWith(products: updated);
    await _saveProducts(updated);
  }

  Future<void> updateStock(String productId, int newStock) async {
    final updated = state.products.map((p) {
      return p.id == productId ? p.copyWith(stock: newStock) : p;
    }).toList();
    state = state.copyWith(products: updated);
    await _saveProducts(updated);
  }

  Future<void> _saveProducts(List<ProductModel> products) async {
    await LocalStorage.saveProducts(products.map((p) => p.toMap()).toList());
  }

  ProductModel? findById(String id) {
    try {
      return state.products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  return ProductNotifier();
});
