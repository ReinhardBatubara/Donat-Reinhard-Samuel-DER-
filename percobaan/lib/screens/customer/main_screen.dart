import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

import 'home/customer_home_screen.dart';
import 'catalog/product_list_screen.dart';
import 'orders/order_history_screen.dart';
import 'favorite/favorite_screen.dart';
import 'profile/profile_screen.dart';

/// Provider untuk index tab yang aktif
final customerTabProvider = StateProvider<int>((ref) => 0);

/// Wrapper utama customer dengan bottom navigation bar
class CustomerMainScreen extends ConsumerWidget {
  const CustomerMainScreen({super.key});

  static const _screens = [

    CustomerHomeScreen(),
    ProductListScreen(),
    OrderHistoryScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(customerTabProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => ref.read(customerTabProvider.notifier).state = index,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: AppStrings.navHome,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store_rounded),
              label: AppStrings.navCatalog,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long_rounded),
              label: AppStrings.navOrder,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: AppStrings.navFavorite,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: AppStrings.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
