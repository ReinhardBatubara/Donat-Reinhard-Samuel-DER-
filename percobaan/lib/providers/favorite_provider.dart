import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local_storage.dart';
import '../models/product_model.dart';
import 'product_provider.dart';

/// Notifier untuk daftar favorit
class FavoriteNotifier extends StateNotifier<List<String>> {
  FavoriteNotifier() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final ids = await LocalStorage.getFavoriteIds();
    state = ids;
  }

  Future<void> toggle(String productId) async {
    if (state.contains(productId)) {
      state = state.where((id) => id != productId).toList();
    } else {
      state = [...state, productId];
    }
    await LocalStorage.saveFavoriteIds(state);
  }

  bool isFavorite(String productId) => state.contains(productId);
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<String>>((ref) {
  return FavoriteNotifier();
});

/// Provider untuk mendapatkan daftar produk favorit lengkap
final favoriteProductsProvider = Provider<List<ProductModel>>((ref) {
  final favoriteIds = ref.watch(favoriteProvider);
  final productState = ref.watch(productProvider);
  return productState.products
      .where((p) => favoriteIds.contains(p.id))
      .toList();
});
