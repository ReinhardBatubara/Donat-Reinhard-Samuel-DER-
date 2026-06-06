import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/product_model.dart';
import '../../../providers/product_provider.dart';
import '../../../widgets/empty_state.dart';

/// Halaman manajemen produk untuk admin
class AdminProductScreen extends ConsumerStatefulWidget {
  const AdminProductScreen({super.key});

  @override
  ConsumerState<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends ConsumerState<AdminProductScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    var products = productState.products;

    if (_searchQuery.isNotEmpty) {
      products = products.where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Produk'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Tambah Produk',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.adminAddProduct),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
              ),
            ),
          ),

          // Jumlah produk
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${products.length} produk',
                  style: const TextStyle(fontSize: 12, color: AppColors.textHint),
                ),
              ],
            ),
          ),

          // Daftar produk
          Expanded(
            child: products.isEmpty
                ? const EmptyState(
                    emoji: '📦',
                    title: 'Produk tidak ditemukan',
                    description: 'Belum ada produk yang ditambahkan.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _ProductAdminTile(
                        product: product,
                        onEdit: () => Navigator.pushNamed(
                          context,
                          AppRoutes.adminEditProduct,
                          arguments: product,
                        ),
                        onDelete: () => _deleteProduct(context, ref, product),
                        onToggleAvailable: () => ref.read(productProvider.notifier).updateProduct(
                          product.copyWith(isAvailable: !product.isAvailable),
                        ),
                        onToggleHidden: () => ref.read(productProvider.notifier).updateProduct(
                          product.copyWith(isHidden: !product.isHidden),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.adminAddProduct),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Tambah Produk', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<void> _deleteProduct(BuildContext context, WidgetRef ref, ProductModel product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Produk?'),
        content: Text('Produk "${product.name}" akan dihapus permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(productProvider.notifier).deleteProduct(product.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} dihapus')),
        );
      }
    }
  }
}

class _ProductAdminTile extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleAvailable;
  final VoidCallback onToggleHidden;

  const _ProductAdminTile({
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAvailable,
    required this.onToggleHidden,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.softShadow,
        border: product.isHidden
            ? Border.all(color: AppColors.textHint.withOpacity(0.3))
            : null,
      ),
      child: Opacity(
        opacity: product.isHidden ? 0.6 : 1.0,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.creamDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(product.imageUrl.isNotEmpty ? product.imageUrl : '🍩',
                  style: const TextStyle(fontSize: 28)),
            ),
          ),
          title: Text(product.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(CurrencyFormatter.format(product.price),
                  style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  _StatusBadge(product.stockLabel,
                      color: product.canBuy ? AppColors.success : AppColors.error),
                  const SizedBox(width: 6),
                  Text('Stok: ${product.stock}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                ],
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, size: 20, color: AppColors.textHint),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  onEdit();
                  break;
                case 'toggle_available':
                  onToggleAvailable();
                  break;
                case 'toggle_hidden':
                  onToggleHidden();
                  break;
                case 'delete':
                  onDelete();
                  break;
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'edit', child: Text('✏️ Edit Produk')),
              PopupMenuItem(
                value: 'toggle_available',
                child: Text(product.isAvailable ? '🚫 Tandai Habis' : '✅ Tandai Tersedia'),
              ),
              PopupMenuItem(
                value: 'toggle_hidden',
                child: Text(product.isHidden ? '👁️ Tampilkan' : '🙈 Sembunyikan'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('🗑️ Hapus', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge(this.label, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
