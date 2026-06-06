import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/product_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/favorite_provider.dart';
import '../../../providers/product_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/product_card.dart';

/// Halaman katalog produk dengan filter dan sorting
class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _searchCtrl = TextEditingController();

  final List<String> _categories = const [
    AppStrings.catAll,
    AppStrings.catChocolate,
    AppStrings.catCheese,
    AppStrings.catGlaze,
    AppStrings.catPremium,
    AppStrings.catBundle,
    AppStrings.catDrink,
  ];

  final List<Map<String, String>> _sortOptions = const [
    {'value': 'default', 'label': 'Default'},
    {'value': 'cheapest', 'label': 'Termurah'},
    {'value': 'expensive', 'label': 'Termahal'},
    {'value': 'bestseller', 'label': 'Terlaris'},
    {'value': 'rating', 'label': 'Rating Tertinggi'},
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    final favoriteIds = ref.watch(favoriteProvider);
    final filtered = productState.filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Donat'),
        automaticallyImplyLeading: false,
        actions: [
          // Sort button
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Urutkan',
            onSelected: (v) => ref.read(productProvider.notifier).setSort(v),
            itemBuilder: (context) => _sortOptions.map((opt) {
              return PopupMenuItem(
                value: opt['value'],
                child: Row(
                  children: [
                    Icon(
                      productState.sortBy == opt['value']
                          ? Icons.check_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 16,
                      color: productState.sortBy == opt['value']
                          ? AppColors.primary
                          : AppColors.textHint,
                    ),
                    const SizedBox(width: 8),
                    Text(opt['label']!),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => ref.read(productProvider.notifier).setSearch(v),
              decoration: InputDecoration(
                hintText: AppStrings.search,
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          ref.read(productProvider.notifier).clearSearch();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Filter kategori
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == productState.selectedCategory;
                return GestureDetector(
                  onTap: () => ref.read(productProvider.notifier).setCategory(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : const Color(0xFFEEE0D5),
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Jumlah hasil
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${filtered.length} produk ditemukan',
                  style: const TextStyle(fontSize: 12, color: AppColors.textHint),
                ),
              ],
            ),
          ),

          // Daftar produk
          Expanded(
            child: productState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? EmptyState(
                        emoji: '🔍',
                        title: AppStrings.emptyProduct,
                        description: AppStrings.emptyProductDesc,
                        buttonLabel: 'Reset Filter',
                        onButtonPressed: () {
                          _searchCtrl.clear();
                          ref.read(productProvider.notifier).setCategory(AppStrings.catAll);
                          ref.read(productProvider.notifier).clearSearch();
                        },
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final product = filtered[index];
                          return ProductCard(
                            product: product,
                            isFavorite: favoriteIds.contains(product.id),
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.productDetail,
                              arguments: product,
                            ),
                            onAddToCart: () => _addToCart(context, ref, product),
                            onFavoriteToggle: () =>
                                ref.read(favoriteProvider.notifier).toggle(product.id),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, WidgetRef ref, ProductModel product) {
    if (!product.canBuy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk ini tidak tersedia'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    ref.read(cartProvider.notifier).addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} ditambahkan ke keranjang 🛒')),
    );
  }
}
