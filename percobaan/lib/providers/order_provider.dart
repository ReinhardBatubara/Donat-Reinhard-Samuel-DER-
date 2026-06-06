import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/local_storage.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

const _uuid = Uuid();

/// State untuk pesanan
class OrderState {
  final List<OrderModel> orders;
  final bool isLoading;

  const OrderState({
    this.orders = const [],
    this.isLoading = false,
  });

  OrderState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier untuk mengelola pesanan
class OrderNotifier extends StateNotifier<OrderState> {
  OrderNotifier() : super(const OrderState()) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    state = state.copyWith(isLoading: true);
    final orders = await LocalStorage.getOrders();
    state = state.copyWith(orders: orders, isLoading: false);
  }

  /// Buat pesanan baru (dari checkout)
  Future<OrderModel> createOrder({
    required String userId,
    required List<CartItemModel> items,
    required int subtotal,
    required int discount,
    required int deliveryFee,
    required int total,
    required OrderMethod orderMethod,
    required PaymentMethod paymentMethod,
    required String customerName,
    required String phone,
    required String address,
    String? promoCode,
  }) async {
    final order = OrderModel(
      id: 'ORD-${_uuid.v4().substring(0, 8).toUpperCase()}',
      userId: userId,
      items: items,
      subtotal: subtotal,
      discount: discount,
      deliveryFee: deliveryFee,
      total: total,
      orderMethod: orderMethod,
      paymentMethod: paymentMethod,
      customerName: customerName,
      phone: phone,
      address: address,
      status: OrderStatus.waiting,
      createdAt: DateTime.now(),
      promoCode: promoCode,
    );

    await LocalStorage.addOrder(order);
    state = state.copyWith(orders: [order, ...state.orders]);
    return order;
  }

  /// Update status pesanan (admin)
  Future<void> updateStatus(String orderId, OrderStatus newStatus) async {
    final updated = state.orders.map((o) {
      return o.id == orderId ? o.copyWith(status: newStatus) : o;
    }).toList();

    await LocalStorage.updateOrder(
      updated.firstWhere((o) => o.id == orderId),
    );
    state = state.copyWith(orders: updated);
  }

  /// Batalkan pesanan
  Future<void> cancelOrder(String orderId) async {
    await updateStatus(orderId, OrderStatus.cancelled);
  }

  /// Ambil pesanan untuk user tertentu
  List<OrderModel> getOrdersByUser(String userId) {
    return state.orders.where((o) => o.userId == userId).toList();
  }

  /// Ambil pesanan berdasarkan status (admin)
  List<OrderModel> getOrdersByStatus(OrderStatus? status) {
    if (status == null) return state.orders;
    return state.orders.where((o) => o.status == status).toList();
  }

  /// Statistik untuk admin dashboard
  Map<String, dynamic> getStats() {
    final today = DateTime.now();
    final todayOrders = state.orders.where((o) =>
      o.createdAt.year == today.year &&
      o.createdAt.month == today.month &&
      o.createdAt.day == today.day
    ).toList();

    final waitingOrders = state.orders.where((o) => o.status == OrderStatus.waiting).length;
    final totalRevenue = state.orders
        .where((o) => o.status == OrderStatus.done)
        .fold(0, (sum, o) => sum + o.total);

    return {
      'todayOrders': todayOrders.length,
      'todayRevenue': todayOrders.fold(0, (sum, o) => sum + o.total),
      'totalRevenue': totalRevenue,
      'waitingOrders': waitingOrders,
      'totalOrders': state.orders.length,
    };
  }

  /// Reload dari storage
  Future<void> refresh() => _loadOrders();
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier();
});
