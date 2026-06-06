import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/order_model.dart';
import '../../../providers/order_provider.dart';
import '../../../widgets/order_status_timeline.dart';

/// Halaman detail pesanan untuk admin dengan kontrol update status
class AdminOrderDetailScreen extends ConsumerWidget {
  const AdminOrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ModalRoute.of(context)!.settings.arguments as OrderModel;

    // Dapatkan order terbaru dari state (supaya update real-time)
    final orderState = ref.watch(orderProvider);
    final currentOrder = orderState.orders.firstWhere(
      (o) => o.id == order.id,
      orElse: () => order,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header pesanan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentOrder.id,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(DateFormatter.formatDateTime(currentOrder.createdAt),
                      style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.person_rounded, size: 14, color: Colors.white70),
                      const SizedBox(width: 6),
                      Text(currentOrder.customerName,
                          style: const TextStyle(fontSize: 13, color: Colors.white)),
                      const SizedBox(width: 16),
                      const Icon(Icons.phone_rounded, size: 14, color: Colors.white70),
                      const SizedBox(width: 6),
                      Text(currentOrder.phone,
                          style: const TextStyle(fontSize: 13, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Update status
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppColors.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Update Status Pesanan',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: OrderStatus.values
                        .where((s) => s != OrderStatus.cancelled)
                        .map((status) {
                      final isCurrentStatus = status == currentOrder.status;
                      return GestureDetector(
                        onTap: () async {
                          await ref.read(orderProvider.notifier).updateStatus(currentOrder.id, status);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Status diubah ke: ${status.label}')),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isCurrentStatus ? AppColors.primary : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                            border: isCurrentStatus ? null : Border.all(color: const Color(0xFFEEE0D5)),
                          ),
                          child: Text(
                            status.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isCurrentStatus ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  // Tombol batalkan
                  if (currentOrder.status != OrderStatus.done &&
                      currentOrder.status != OrderStatus.cancelled)
                    TextButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Batalkan Pesanan?'),
                            content: const Text('Pesanan akan dibatalkan.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Batalkan', style: TextStyle(color: AppColors.error)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await ref.read(orderProvider.notifier).cancelOrder(currentOrder.id);
                        }
                      },
                      icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.error),
                      label: const Text('Batalkan Pesanan', style: TextStyle(color: AppColors.error)),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Timeline status
            const Text('Riwayat Status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.softShadow),
              child: OrderStatusTimeline(currentStatus: currentOrder.status),
            ),

            const SizedBox(height: 16),

            // Detail item
            const Text('Item Pesanan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.softShadow),
              child: Column(
                children: [
                  ...currentOrder.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Text(item.product.imageUrl, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 10),
                            Expanded(child: Text('${item.product.name} (x${item.quantity})',
                                style: const TextStyle(fontSize: 13))),
                            Text(CurrencyFormatter.format(item.totalPrice),
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                  const Divider(),
                  _Row('Subtotal', CurrencyFormatter.format(currentOrder.subtotal)),
                  if (currentOrder.discount > 0)
                    _Row('Diskon', '- ${CurrencyFormatter.format(currentOrder.discount)}', color: AppColors.success),
                  _Row('Ongkir', currentOrder.deliveryFee == 0 ? 'Gratis' : CurrencyFormatter.format(currentOrder.deliveryFee)),
                  _Row('Total', CurrencyFormatter.format(currentOrder.total), isBold: true, color: AppColors.primary),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Info pengiriman
            const Text('Info Pengiriman', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.softShadow),
              child: Column(
                children: [
                  _Row('Metode', currentOrder.orderMethod.label),
                  _Row('Pembayaran', currentOrder.paymentMethod.label),
                  if (currentOrder.address.isNotEmpty) _Row('Alamat', currentOrder.address),
                  if (currentOrder.promoCode != null) _Row('Promo', currentOrder.promoCode!),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  const _Row(this.label, this.value, {this.isBold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textHint))),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: color ?? AppColors.textPrimary))),
        ],
      ),
    );
  }
}
