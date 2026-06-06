import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/dummy_data.dart';
import '../../../models/product_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/favorite_provider.dart';
import '../../../providers/product_provider.dart';
import '../../../widgets/product_card.dart';
import '../main_screen.dart';

/// Halaman beranda customer dengan banner promo, kategori, dan produk
class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final productState = ref.watch(productProvider);
    final cartState = ref.watch(cartProvider);
    final favoriteIds = ref.watch(favoriteProvider);
    final userName = authState.user?.name.split(' ').first ?? 'Pelanggan';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  child: Column(
                    children: [
                      // Top bar
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Halo, $userName 👋',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Mau donat apa hari ini?',
                                  style: TextStyle(fontSize: 13, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          // Tombol keranjang
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),
                              ),
                              if (cartState.totalItems > 0)
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: AppColors.pink,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${cartState.totalItems}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search bar
                      GestureDetector(
                        onTap: () {
                          ref.read(customerTabProvider.notifier).state = 1;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Cari donat favoritmu...',
                                style: TextStyle(color: AppColors.textHint, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner promo (horizontal scroll)
                const SizedBox(height: 20),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: DummyData.banners.length,
                    itemBuilder: (context, index) {
                      final banner = DummyData.banners[index];
                      return Container(
                        width: 280,
                        margin: const EdgeInsets.only(right: 14),
                        decoration: BoxDecoration(
                          color: Color(banner['color']),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    banner['title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    banner['subtitle'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.85),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(banner['emoji'], style: const TextStyle(fontSize: 40)),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Kategori cepat
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Kategori',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 85,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: const [
                      _CategoryChip(emoji: '🍫', label: 'Coklat'),
                      _CategoryChip(emoji: '🧀', label: 'Keju'),
                      _CategoryChip(emoji: '🍓', label: 'Glaze'),
                      _CategoryChip(emoji: '✨', label: 'Premium'),
                      _CategoryChip(emoji: '📦', label: 'Paket'),
                      _CategoryChip(emoji: '🧋', label: 'Minuman'),
                    ],
                  ),
                ),

                // Produk Terlaris
                const SizedBox(height: 24),
                _SectionHeader(
                  title: '🔥 Produk Terlaris',
                  onSeeAll: () => ref.read(customerTabProvider.notifier).state = 1,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 220,
                  child: productState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: productState.bestsellers.length,
                          itemBuilder: (context, index) {
                            final product = productState.bestsellers[index];
                            return Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 14),
                              child: ProductCard(
                                product: product,
                                isFavorite: favoriteIds.contains(product.id),
                                onTap: () => _goToDetail(context, product),
                                onAddToCart: () => _addToCart(context, ref, product),
                                onFavoriteToggle: () => ref.read(favoriteProvider.notifier).toggle(product.id),
                              ),
                            );
                          },
                        ),
                ),

                // Rekomendasi
                const SizedBox(height: 24),
                _SectionHeader(
                  title: '⭐ Rekomendasi Untukmu',
                  onSeeAll: () => ref.read(customerTabProvider.notifier).state = 1,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: productState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                          itemCount: productState.recommended.length,
                          itemBuilder: (context, index) {
                            final product = productState.recommended[index];
                            return ProductCard(
                              product: product,
                              isFavorite: favoriteIds.contains(product.id),
                              onTap: () => _goToDetail(context, product),
                              onAddToCart: () => _addToCart(context, ref, product),
                              onFavoriteToggle: () => ref.read(favoriteProvider.notifier).toggle(product.id),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToDetail(BuildContext context, ProductModel product) {
    Navigator.pushNamed(context, AppRoutes.productDetail, arguments: product);
  }

  void _addToCart(BuildContext context, WidgetRef ref, ProductModel product) {
    if (!product.canBuy) return;
    ref.read(cartProvider.notifier).addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ditambahkan ke keranjang 🛒'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: const Text('Lihat Semua'),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String emoji;
  final String label;

  const _CategoryChip({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
