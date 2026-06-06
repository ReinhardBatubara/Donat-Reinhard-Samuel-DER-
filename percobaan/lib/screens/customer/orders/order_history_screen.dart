import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/order_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../widgets/empty_state.dart';

/// Halaman riwayat pesanan customer
class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.waiting:   return AppColors.statusWaiting;
      case OrderStatus.process:   return AppColors.statusProcess;
      case OrderStatus.ready:     return AppColors.statusReady;
      case OrderStatus.delivery:  return AppColors.statusDelivery;
      case OrderStatus.done:      return AppColors.statusDone;
      case OrderStatus.cancelled: return AppColors.statusCancelled;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final orderState = ref.watch(orderProvider);
    final userId = authState.user?.id ?? '';
    final myOrders = orderState.orders.where((o) => o.userId == userId).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Saya'),
        automaticallyImplyLeading: false,
      ),
      body: orderState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : myOrders.isEmpty
              ? EmptyState(
                  emoji: '📦',
                  title: AppStrings.emptyOrder,
                  description: AppStrings.emptyOrderDesc,
                  buttonLabel: 'Mulai Belanja',
                  onButtonPressed: () {},
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: myOrders.length,
                  itemBuilder: (context, index) {
                    final order = myOrders[index];
                    return _OrderCard(
                      order: order,
                      statusColor: _statusColor(order.status),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.orderStatus,
                        arguments: order,
                      ),
                      onReorder: () => _reorder(context, ref, order),
                    );
                  },
                ),
    );
  }

  void _reorder(BuildContext context, WidgetRef ref, OrderModel order) {
    final cartNotifier = ref.read(cartProvider.notifier);
    for (final item in order.items) {
      cartNotifier.addItem(item.product, quantity: item.quantity);
    }
    Navigator.pushNamed(context, AppRoutes.cart);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item ditambahkan ke keranjang 🛒')),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final Color statusColor;
  final VoidCallback onTap;
  final VoidCallback onReorder;

  const _OrderCard({
    required this.order,
    required this.statusColor,
    required this.onTap,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(Icons.receipt_long_rounded, size: 16, color: statusColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.id,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.status.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Isi pesanan
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // Produk preview
                  Row(
                    children: [
                      Wrap(
                        spacing: 4,
                        children: order.items.take(3).map((item) {
                          return Text(item.product.imageUrl, style: const TextStyle(fontSize: 28));
                        }).toList(),
                      ),
                      if (order.items.length > 3) ...[
                        const SizedBox(width: 4),
                        Text(
                          '+${order.items.length - 3}',
                          style: const TextStyle(color: AppColors.textHint, fontSize: 13),
                        ),
                      ],
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            CurrencyFormatter.format(order.total),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '${order.totalItems} item',
                            style: const TextStyle(fontSize: 12, color: AppColors.textHint),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.formatDateTime(order.createdAt),
                        style: const TextStyle(fontSize: 12, color: AppColors.textHint),
                      ),
                      const Spacer(),
                      // Tombol pesan lagi
                      if (order.status == OrderStatus.done)
                        TextButton.icon(
                          onPressed: onReorder,
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: const Text('Pesan Lagi', style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                        ),
                      // Tombol lihat detail
                      TextButton(
                        onPressed: onTap,
                        child: const Text('Detail', style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
