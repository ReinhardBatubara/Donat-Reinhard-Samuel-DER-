import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/promo_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/promo_card.dart';

/// Halaman daftar promo untuk customer
class PromoScreen extends ConsumerWidget {
  const PromoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promos = ref.watch(promoProvider);
    final activePromos = promos.where((p) => p.isActive).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo & Voucher'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Banner info
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B4513), Color(0xFFE8956D)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Text('🎫', style: TextStyle(fontSize: 32)),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hemat Lebih Banyak!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Gunakan kode promo saat checkout',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Daftar promo
          Expanded(
            child: activePromos.isEmpty
                ? EmptyState(
                    emoji: '🎁',
                    title: AppStrings.emptyPromo,
                    description: AppStrings.emptyPromoDesc,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: activePromos.length,
                    itemBuilder: (context, index) {
                      final promo = activePromos[index];
                      return PromoCard(
                        promo: promo,
                        onTap: () {
                          // Tampilkan detail dan salin kode
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Kode promo: ${promo.code} - Masukkan saat checkout!'),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {},
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
