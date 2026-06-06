import 'product_model.dart';

/// Model item di dalam keranjang belanja
class CartItemModel {
  final ProductModel product;
  final int quantity;
  final String note; // Catatan pesanan untuk item ini

  const CartItemModel({
    required this.product,
    required this.quantity,
    this.note = '',
  });

  /// Total harga item ini (harga x jumlah)
  int get totalPrice => product.price * quantity;

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
    String? note,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }
}
