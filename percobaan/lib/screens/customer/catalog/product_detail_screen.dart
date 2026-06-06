import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/product_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/favorite_provider.dart';
import '../../../widgets/primary_button.dart';

/// Halaman detail produk
class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _quantity = 1;
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductModel;
    final favoriteIds = ref.watch(favoriteProvider);
    final isFavorite = favoriteIds.contains(product.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar dengan gambar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: AppColors.softShadow,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.textPrimary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 20,
                    color: isFavorite ? AppColors.pink : AppColors.textHint,
                  ),
                ),
                onPressed: () => ref.read(favoriteProvider.notifier).toggle(product.id),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.creamDark,
                child: Center(
                  child: Text(
                    product.imageUrl.isNotEmpty ? product.imageUrl : '🍩',
                    style: const TextStyle(fontSize: 120),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nama & Harga
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(product.price),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Rating & Terjual
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFC107)),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${product.reviewCount} ulasan)',
                        style: const TextStyle(fontSize: 13, color: AppColors.textHint),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.shopping_bag_outlined, size: 16, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        '${product.soldCount}+ terjual',
                        style: const TextStyle(fontSize: 13, color: AppColors.textHint),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Status stok
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.canBuy
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.canBuy
                          ? 'Stok Tersedia: ${product.stock}'
                          : product.stockLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: product.canBuy ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Divider(height: 28),

                  // Deskripsi
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),

                  // Komposisi
                  if (product.composition.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Komposisi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, size: 16, color: AppColors.textHint),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              product.composition,
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Divider(height: 28),

                  // Pilih jumlah
                  Row(
                    children: [
                      const Text(
                        'Jumlah',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const Spacer(),
                      _QtyControl(
                        quantity: _quantity,
                        maxQty: product.stock,
                        onDecrease: () {
                          if (_quantity > 1) setState(() => _quantity--);
                        },
                        onIncrease: () {
                          if (_quantity < product.stock) setState(() => _quantity++);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Catatan
                  const Text(
                    'Catatan (opsional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Contoh: jangan terlalu manis, tanpa kacang, dll.',
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Tombol aksi
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Ke Keranjang',
                          isOutlined: true,
                          onPressed: product.canBuy ? () => _addToCart(context, ref, product) : null,
                          icon: Icons.shopping_cart_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Beli Sekarang',
                          onPressed: product.canBuy ? () => _buyNow(context, ref, product) : null,
                          icon: Icons.bolt_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, WidgetRef ref, ProductModel product) {
    ref.read(cartProvider.notifier).addItem(product, quantity: _quantity, note: _noteCtrl.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} (x$_quantity) ditambahkan ke keranjang 🛒')),
    );
  }

  void _buyNow(BuildContext context, WidgetRef ref, ProductModel product) {
    ref.read(cartProvider.notifier).addItem(product, quantity: _quantity, note: _noteCtrl.text.trim());
    Navigator.pushNamed(context, AppRoutes.cart);
  }
}

class _QtyControl extends StatelessWidget {
  final int quantity;
  final int maxQty;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _QtyControl({
    required this.quantity,
    required this.maxQty,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Btn(icon: Icons.remove, onTap: quantity > 1 ? onDecrease : null),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$quantity',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ),
        _Btn(icon: Icons.add, onTap: quantity < maxQty ? onIncrease : null),
      ],
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _Btn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: onTap != null ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: onTap != null ? Colors.white : AppColors.textHint),
      ),
    );
  }
}
