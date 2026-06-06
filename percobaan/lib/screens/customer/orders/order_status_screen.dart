import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/order_model.dart';
import '../../../widgets/order_status_timeline.dart';

/// Halaman detail status pesanan dengan timeline
class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as OrderModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Pesanan'),
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
            // Info pesanan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nomor Pesanan',
                              style: TextStyle(fontSize: 12, color: Colors.white70),
                            ),
                            Text(
                              order.id,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.status.label,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    DateFormatter.formatDateTime(order.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Timeline status
            const Text(
              'Riwayat Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppColors.softShadow,
              ),
              child: OrderStatusTimeline(currentStatus: order.status),
            ),

            const SizedBox(height: 20),

            // Detail item pesanan
            const Text(
              'Detail Pesanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppColors.softShadow,
              ),
              child: Column(
                children: [
                  ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Text(item.product.imageUrl, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${item.product.name} (x${item.quantity})',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(item.totalPrice),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                  const Divider(),
                  _DetailRow('Subtotal', CurrencyFormatter.format(order.subtotal)),
                  if (order.discount > 0)
                    _DetailRow('Diskon', '- ${CurrencyFormatter.format(order.discount)}',
                        color: AppColors.success),
                  _DetailRow(
                      'Ongkir', order.deliveryFee == 0 ? 'Gratis' : CurrencyFormatter.format(order.deliveryFee)),
                  _DetailRow('Total', CurrencyFormatter.format(order.total), isBold: true, color: AppColors.primary),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Info pengiriman
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
                  const Text('Info Pengiriman', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _DetailRow('Penerima', order.customerName),
                  _DetailRow('No. HP', order.phone),
                  _DetailRow('Metode', order.orderMethod.label),
                  _DetailRow('Pembayaran', order.paymentMethod.label),
                  if (order.address.isNotEmpty) _DetailRow('Alamat', order.address),
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  const _DetailRow(this.label, this.value, {this.isBold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textHint)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: color ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
