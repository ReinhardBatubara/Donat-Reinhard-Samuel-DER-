import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/promo_model.dart';

/// Widget card promo/voucher
class PromoCard extends StatelessWidget {
  final PromoModel promo;
  final bool isSelected;
  final VoidCallback onTap;

  const PromoCard({
    super.key,
    required this.promo,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: promo.isActive ? onTap : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFEEE0D5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            // Strip warna kiri
            Container(
              width: 10,
              height: 90,
              decoration: BoxDecoration(
                color: promo.isActive ? AppColors.primary : AppColors.textHint,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),

            // Lingkaran notch kiri
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.only(left: -8),
            ),

            // Konten
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Kode voucher
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: promo.isActive
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            promo.code,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: promo.isActive ? AppColors.primary : AppColors.textHint,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Label diskon
                        Text(
                          promo.discountLabel,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: promo.isActive ? AppColors.primary : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      promo.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      promo.description,
                      style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (promo.minOrder > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Min. belanja Rp ${promo.minOrder ~/ 1000}rb',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Lingkaran notch kanan
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.only(right: -8),
            ),

            const SizedBox(width: 8),

            // Centang jika terpilih
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: isSelected ? AppColors.primary : AppColors.textHint,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
