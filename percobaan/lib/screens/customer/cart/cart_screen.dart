import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/promo_provider.dart';
import '../../../widgets/cart_item_tile.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/primary_button.dart';

/// Halaman keranjang belanja
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _promoCtrl = TextEditingController();

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;

    final promo = ref.read(promoProvider.notifier).validateCode(code);
    if (promo != null) {
      final cartState = ref.read(cartProvider);
      if (cartState.subtotal < promo.minOrder) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Minimum belanja ${CurrencyFormatter.format(promo.minOrder)} untuk promo ini'),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }
      ref.read(selectedPromoProvider.notifier).state = promo;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Promo ${promo.code} berhasil diterapkan! ✅')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode promo tidak valid atau tidak aktif'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removePromo() {
    ref.read(selectedPromoProvider.notifier).state = null;
    _promoCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final selectedPromo = ref.watch(selectedPromoProvider);

    final discount = selectedPromo?.calculateDiscount(cartState.subtotal) ?? 0;
    final total = cartState.subtotal - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!cartState.isEmpty)
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Kosongkan Keranjang?'),
                    content: const Text('Semua item akan dihapus dari keranjang.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                      TextButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).clearCart();
                          _removePromo();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
              label: const Text('Hapus', style: TextStyle(color: AppColors.error, fontSize: 13)),
            ),
        ],
      ),
      body: cartState.isEmpty
          ? EmptyState(
              emoji: '🛒',
              title: AppStrings.cartEmpty,
              description: AppStrings.cartEmptyDesc,
              buttonLabel: 'Lihat Katalog',
              onButtonPressed: () => Navigator.pop(context),
            )
          : Column(
              children: [
                // Daftar item
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ...cartState.items.map((item) => CartItemTile(
                            item: item,
                            onIncrease: () =>
                                ref.read(cartProvider.notifier).increaseItem(item.product.id),
                            onDecrease: () =>
                                ref.read(cartProvider.notifier).decreaseItem(item.product.id),
                            onRemove: () =>
                                ref.read(cartProvider.notifier).removeItem(item.product.id),
                          )),

                      const SizedBox(height: 16),

                      // Input promo
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
                            const Text(
                              '🎫 Kode Promo',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            if (selectedPromo != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            selectedPromo.code,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                          Text(
                                            'Hemat ${CurrencyFormatter.format(discount)}',
                                            style: const TextStyle(fontSize: 12, color: AppColors.success),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textHint),
                                      onPressed: _removePromo,
                                    ),
                                  ],
                                ),
                              )
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _promoCtrl,
                                      textCapitalization: TextCapitalization.characters,
                                      decoration: const InputDecoration(
                                        hintText: 'Masukkan kode promo',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      ),
                                      onSubmitted: (_) => _applyPromo(),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: _applyPromo,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      minimumSize: Size.zero,
                                    ),
                                    child: const Text('Pakai'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Ringkasan harga & tombol checkout
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(label: 'Subtotal', value: CurrencyFormatter.format(cartState.subtotal)),
                      if (discount > 0)
                        _SummaryRow(
                          label: 'Diskon (${selectedPromo?.code})',
                          value: '- ${CurrencyFormatter.format(discount)}',
                          valueColor: AppColors.success,
                        ),
                      const Divider(height: 16),
                      _SummaryRow(
                        label: 'Total',
                        value: CurrencyFormatter.format(total),
                        isBold: true,
                        valueColor: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: 'Checkout (${cartState.totalItems} item)',
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.checkout),
                        icon: Icons.shopping_cart_checkout_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
