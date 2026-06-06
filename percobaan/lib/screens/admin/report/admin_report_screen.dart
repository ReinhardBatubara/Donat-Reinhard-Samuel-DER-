import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/order_model.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/product_provider.dart';

/// Halaman laporan penjualan untuk admin
class AdminReportScreen extends ConsumerWidget {
  const AdminReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    final productState = ref.watch(productProvider);

    final doneOrders = orderState.orders.where((o) => o.status == OrderStatus.done).toList();
    final totalRevenue = doneOrders.fold(0, (sum, o) => sum + o.total);

    // Hitung produk terlaris dari pesanan
    final Map<String, int> productSales = {};
    for (final order in doneOrders) {
      for (final item in order.items) {
        productSales[item.product.name] = (productSales[item.product.name] ?? 0) + item.quantity;
      }
    }
    final topProducts = productSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Pendapatan harian (7 hari terakhir)
    final now = DateTime.now();
    final dailyRevenue = List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      final dayRevenue = doneOrders
          .where((o) =>
              o.createdAt.year == day.year &&
              o.createdAt.month == day.month &&
              o.createdAt.day == day.day)
          .fold(0, (sum, o) => sum + o.total);
      return {
        'day': ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'][day.weekday % 7],
        'revenue': dayRevenue,
      };
    });
    final maxRevenue = dailyRevenue.fold(0, (max, d) => (d['revenue'] as int) > max ? (d['revenue'] as int) : max);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Penjualan'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan utama
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _SummaryCard(
                  label: 'Total Pendapatan',
                  value: CurrencyFormatter.format(totalRevenue),
                  icon: Icons.account_balance_wallet_rounded,
                  color: AppColors.success,
                  isSmall: true,
                ),
                _SummaryCard(
                  label: 'Pesanan Selesai',
                  value: '${doneOrders.length}',
                  icon: Icons.check_circle_rounded,
                  color: AppColors.statusDone,
                ),
                _SummaryCard(
                  label: 'Total Pesanan',
                  value: '${orderState.orders.length}',
                  icon: Icons.receipt_long_rounded,
                  color: AppColors.info,
                ),
                _SummaryCard(
                  label: 'Total Produk',
                  value: '${productState.products.length}',
                  icon: Icons.inventory_2_rounded,
                  color: AppColors.accent,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Grafik pendapatan harian
            const Text('Pendapatan 7 Hari Terakhir',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppColors.softShadow,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 130,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: dailyRevenue.map((d) {
                        final revenue = d['revenue'] as int;
                        final height = maxRevenue > 0 ? (revenue / maxRevenue * 110) : 0.0;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (revenue > 0)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '${revenue ~/ 1000}k',
                                  style: const TextStyle(fontSize: 9, color: AppColors.textHint),
                                ),
                              ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              width: 32,
                              height: height.clamp(4, 110).toDouble(),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(d['day'] as String,
                                style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Produk terlaris
            const Text('Produk Terlaris',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            if (topProducts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Belum ada data penjualan', style: TextStyle(color: AppColors.textHint)),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  children: topProducts.take(5).toList().asMap().entries.map((entry) {
                    final rank = entry.key + 1;
                    final e = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: rank == 1
                                  ? const Color(0xFFFFC107)
                                  : rank == 2
                                      ? const Color(0xFFBDBDBD)
                                      : rank == 3
                                          ? const Color(0xFFCD7F32)
                                          : AppColors.surfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '#$rank',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(e.key, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            '${e.value} terjual',
                            style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isSmall;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 18),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: isSmall ? 13 : 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
        ],
      ),
    );
  }
}
