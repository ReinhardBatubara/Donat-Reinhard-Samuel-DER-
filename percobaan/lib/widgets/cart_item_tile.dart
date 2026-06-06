import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/currency_formatter.dart';
import '../models/cart_item_model.dart';

/// Widget tile untuk item di keranjang belanja
class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        children: [
          // Gambar produk
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.creamDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                item.product.imageUrl.isNotEmpty ? item.product.imageUrl : '🍩',
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama produk & tombol hapus
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(Icons.close, size: 18, color: AppColors.textHint),
                    ),
                  ],
                ),

                // Catatan jika ada
                if (item.note.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Catatan: ${item.note}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 8),

                // Harga & kontrol jumlah
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CurrencyFormatter.format(item.totalPrice),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    // Kontrol jumlah
                    Row(
                      children: [
                        _QtyButton(
                          icon: Icons.remove,
                          onTap: onDecrease,
                          isActive: item.quantity > 1,
                        ),
                        Container(
                          width: 32,
                          alignment: Alignment.center,
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        _QtyButton(
                          icon: Icons.add,
                          onTap: onIncrease,
                          isActive: item.quantity < item.product.stock,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isActive ? Colors.white : AppColors.textHint,
        ),
      ),
    );
  }
}
