import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/order_model.dart';
import '../../../providers/order_provider.dart';
import '../../../widgets/empty_state.dart';

/// Halaman manajemen pesanan untuk admin
class AdminOrderScreen extends ConsumerStatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  ConsumerState<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends ConsumerState<AdminOrderScreen> {
  OrderStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final filteredOrders = _filterStatus == null
        ? orderState.orders
        : orderState.orders.where((o) => o.status == _filterStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Pesanan'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Filter status
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _FilterChip(
                  label: 'Semua',
                  isSelected: _filterStatus == null,
                  onTap: () => setState(() => _filterStatus = null),
                ),
                ...OrderStatus.values.map((status) => _FilterChip(
                      label: status.label,
                      isSelected: _filterStatus == status,
                      onTap: () => setState(() => _filterStatus = status),
                      color: _getStatusColor(status),
                    )),
              ],
            ),
          ),

          // Jumlah pesanan
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(children: [
              Text('${filteredOrders.length} pesanan', style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
            ]),
          ),

          // Daftar pesanan
          Expanded(
            child: orderState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredOrders.isEmpty
                    ? const EmptyState(
                        emoji: '📋',
                        title: 'Tidak ada pesanan',
                        description: 'Belum ada pesanan dengan status ini.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return _AdminOrderTile(
                            order: order,
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.adminOrderDetail,
                              arguments: order,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.waiting:   return AppColors.statusWaiting;
      case OrderStatus.process:   return AppColors.statusProcess;
      case OrderStatus.ready:     return AppColors.statusReady;
      case OrderStatus.delivery:  return AppColors.statusDelivery;
      case OrderStatus.done:      return AppColors.statusDone;
      case OrderStatus.cancelled: return AppColors.statusCancelled;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? c : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? c : const Color(0xFFEEE0D5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _AdminOrderTile extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const _AdminOrderTile({required this.order, required this.onTap});

  Color _getStatusColor(OrderStatus status) {
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
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.softShadow,
          border: Border(left: BorderSide(color: statusColor, width: 4)),
        ),
        child: Row(
          children: [
            Text(order.items.first.product.imageUrl, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.id, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(order.customerName, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                  Text(DateFormatter.formatDateTime(order.createdAt),
                      style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(CurrencyFormatter.format(order.total),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status.label,
                    style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
