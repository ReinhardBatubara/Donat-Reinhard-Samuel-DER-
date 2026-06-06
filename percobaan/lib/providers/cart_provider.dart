import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

/// State untuk keranjang belanja
class CartState {
  final List<CartItemModel> items;

  const CartState({this.items = const []});

  /// Total harga semua item di keranjang
  int get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  /// Jumlah total item
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Apakah keranjang kosong
  bool get isEmpty => items.isEmpty;

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }
}

/// Notifier untuk keranjang belanja
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  /// Tambah produk ke keranjang
  void addItem(ProductModel product, {int quantity = 1, String note = ''}) {
    final existingIndex = state.items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      // Produk sudah ada, tambah jumlahnya
      final existing = state.items[existingIndex];
      final newQuantity = existing.quantity + quantity;

      // Jangan melebihi stok
      if (newQuantity > product.stock) return;

      final updatedItems = [...state.items];
      updatedItems[existingIndex] = existing.copyWith(quantity: newQuantity);
      state = state.copyWith(items: updatedItems);
    } else {
      // Produk baru, tambahkan ke keranjang
      final newItem = CartItemModel(product: product, quantity: quantity, note: note);
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  /// Kurangi jumlah produk
  void decreaseItem(String productId) {
    final index = state.items.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;

    final item = state.items[index];
    if (item.quantity <= 1) {
      removeItem(productId); // Hapus jika jumlah sudah 1
    } else {
      final updatedItems = [...state.items];
      updatedItems[index] = item.copyWith(quantity: item.quantity - 1);
      state = state.copyWith(items: updatedItems);
    }
  }

  /// Tambah jumlah produk
  void increaseItem(String productId) {
    final index = state.items.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;

    final item = state.items[index];
    if (item.quantity >= item.product.stock) return; // Jangan melebihi stok

    final updatedItems = [...state.items];
    updatedItems[index] = item.copyWith(quantity: item.quantity + 1);
    state = state.copyWith(items: updatedItems);
  }

  /// Hapus produk dari keranjang
  void removeItem(String productId) {
    final updatedItems = state.items.where((item) => item.product.id != productId).toList();
    state = state.copyWith(items: updatedItems);
  }

  /// Update catatan produk
  void updateNote(String productId, String note) {
    final index = state.items.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;

    final updatedItems = [...state.items];
    updatedItems[index] = state.items[index].copyWith(note: note);
    state = state.copyWith(items: updatedItems);
  }

  /// Kosongkan keranjang (setelah checkout)
  void clearCart() {
    state = const CartState();
  }

  /// Cek apakah produk sudah ada di keranjang
  bool containsProduct(String productId) {
    return state.items.any((item) => item.product.id == productId);
  }

  /// Dapatkan jumlah item untuk produk tertentu
  int getQuantity(String productId) {
    try {
      return state.items.firstWhere((item) => item.product.id == productId).quantity;
    } catch (_) {
      return 0;
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
