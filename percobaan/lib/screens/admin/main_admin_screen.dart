import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard/admin_dashboard_screen.dart';
import 'products/admin_product_screen.dart';
import 'orders/admin_order_screen.dart';
import 'promo/admin_promo_screen.dart';
import 'report/admin_report_screen.dart';

final adminTabProvider = StateProvider<int>((ref) => 0);

/// Wrapper utama admin dengan bottom navigation
class AdminMainScreen extends ConsumerWidget {
  const AdminMainScreen({super.key});

  static const _screens = [
    AdminDashboardScreen(),
    AdminProductScreen(),
    AdminOrderScreen(),
    AdminPromoScreen(),
    AdminReportScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(adminTabProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(adminTabProvider.notifier).state = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2_rounded),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long_rounded),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            activeIcon: Icon(Icons.local_offer_rounded),
            label: 'Promo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart_rounded),
            label: 'Laporan',
          ),
        ],
      ),
    );
  }
}
