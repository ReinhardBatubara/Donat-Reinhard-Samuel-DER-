import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/favorite_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/product_card.dart';
import '../../../providers/cart_provider.dart';
import '../../../models/product_model.dart';

/// Halaman favorit / wishlist customer
class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteProducts = ref.watch(favoriteProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Saya'),
        automaticallyImplyLeading: false,
        actions: [
          if (favoriteProducts.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '${favoriteProducts.length} produk',
                  style: const TextStyle(fontSize: 13, color: AppColors.textHint),
                ),
              ),
            ),
        ],
      ),
      body: favoriteProducts.isEmpty
          ? EmptyState(
              emoji: '💝',
              title: AppStrings.emptyFavorite,
              description: AppStrings.emptyFavoriteDesc,
              buttonLabel: 'Jelajahi Katalog',
              onButtonPressed: () {},
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return ProductCard(
                  product: product,
                  isFavorite: true,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.productDetail,
                    arguments: product,
                  ),
                  onAddToCart: () => _addToCart(context, ref, product),
                  onFavoriteToggle: () => ref.read(favoriteProvider.notifier).toggle(product.id),
                );
              },
            ),
    );
  }

  void _addToCart(BuildContext context, WidgetRef ref, ProductModel product) {
    if (!product.canBuy) return;
    ref.read(cartProvider.notifier).addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} ditambahkan ke keranjang 🛒')),
    );
  }
}
