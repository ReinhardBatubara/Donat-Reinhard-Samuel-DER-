import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/order_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/product_provider.dart';

/// Dashboard admin dengan statistik dan pesanan terbaru
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    final productState = ref.watch(productProvider);
    final authState = ref.watch(authProvider);
    final stats = orderState.isLoading ? {} : ref.read(orderProvider.notifier).getStats();
    final recentOrders = orderState.orders.take(5).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
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
                                  'Dashboard Admin 📊',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                Text(
                                  authState.user?.name ?? 'Admin',
                                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          // Tombol logout
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                            ),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Keluar?'),
                                  content: const Text('Keluar dari akun admin?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Keluar', style: TextStyle(color: AppColors.error)),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await ref.read(authProvider.notifier).logout();
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card statistik
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _StatCard(
                        label: 'Pesanan Hari Ini',
                        value: '${stats['todayOrders'] ?? 0}',
                        icon: Icons.receipt_long_rounded,
                        color: AppColors.info,
                      ),
                      _StatCard(
                        label: 'Pendapatan Hari Ini',
                        value: CurrencyFormatter.format(stats['todayRevenue'] ?? 0),
                        icon: Icons.attach_money_rounded,
                        color: AppColors.success,
                        isSmallText: true,
                      ),
                      _StatCard(
                        label: 'Total Produk',
                        value: '${productState.products.length}',
                        icon: Icons.inventory_2_rounded,
                        color: AppColors.accent,
                      ),
                      _StatCard(
                        label: 'Menunggu Konfirmasi',
                        value: '${stats['waitingOrders'] ?? 0}',
                        icon: Icons.pending_actions_rounded,
                        color: AppColors.warning,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Total pendapatan keseluruhan
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Total Pendapatan', style: TextStyle(fontSize: 13, color: AppColors.textHint)),
                              Text(
                                CurrencyFormatter.format(stats['totalRevenue'] ?? 0),
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Total Pesanan', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                            Text(
                              '${stats['totalOrders'] ?? 0}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Pesanan terbaru
                  const Text(
                    'Pesanan Terbaru',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),

                  if (recentOrders.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('Belum ada pesanan', style: TextStyle(color: AppColors.textHint)),
                      ),
                    )
                  else
                    ...recentOrders.map((order) => _RecentOrderTile(
                          order: order,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.adminOrderDetail,
                            arguments: order,
                          ),
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isSmallText;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isSmallText = false,
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
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallText ? 13 : 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
        ],
      ),
    );
  }
}

class _RecentOrderTile extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const _RecentOrderTile({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            Text(order.items.first.product.imageUrl, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.id, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(order.customerName, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(order.total),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    order.status.label,
                    style: TextStyle(fontSize: 10, color: _getStatusColor(order.status), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
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
