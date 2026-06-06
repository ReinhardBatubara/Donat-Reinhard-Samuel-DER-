import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/promo_model.dart';
import '../../../providers/promo_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/custom_text_field.dart';

/// Halaman manajemen promo untuk admin
class AdminPromoScreen extends ConsumerWidget {
  const AdminPromoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promos = ref.watch(promoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Promo'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Tambah Promo',
            onPressed: () => _showPromoDialog(context, ref, null),
          ),
        ],
      ),
      body: promos.isEmpty
          ? const EmptyState(emoji: '🎫', title: 'Belum ada promo', description: 'Tambahkan kode promo baru')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: promos.length,
              itemBuilder: (context, index) {
                final promo = promos[index];
                return _PromoAdminCard(
                  promo: promo,
                  onEdit: () => _showPromoDialog(context, ref, promo),
                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus Promo?'),
                        content: Text('Promo "${promo.code}" akan dihapus.'),
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
                      await ref.read(promoProvider.notifier).deletePromo(promo.code);
                    }
                  },
                  onToggle: () => ref.read(promoProvider.notifier).toggleActive(promo.code),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPromoDialog(context, ref, null),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Tambah Promo', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<void> _showPromoDialog(BuildContext context, WidgetRef ref, PromoModel? existing) async {
    final isEditing = existing != null;
    final codeCtrl = TextEditingController(text: existing?.code ?? '');
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final percentCtrl = TextEditingController(text: existing?.discountPercent.toString() ?? '0');
    final flatCtrl = TextEditingController(text: existing?.discountFlat.toString() ?? '0');
    final minOrderCtrl = TextEditingController(text: existing?.minOrder.toString() ?? '0');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isEditing ? 'Edit Promo' : 'Tambah Promo',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              CustomTextField(label: 'Kode Promo', hint: 'Contoh: DRSHEMAT10', controller: codeCtrl),
              const SizedBox(height: 10),
              CustomTextField(label: 'Judul Promo', controller: titleCtrl),
              const SizedBox(height: 10),
              CustomTextField(label: 'Deskripsi', controller: descCtrl, maxLines: 2),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: CustomTextField(label: 'Diskon % (0 jika flat)', hint: '10', controller: percentCtrl, keyboardType: TextInputType.number)),
                  const SizedBox(width: 10),
                  Expanded(child: CustomTextField(label: 'Diskon Flat (Rp)', hint: '5000', controller: flatCtrl, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 10),
              CustomTextField(label: 'Min. Order (Rp)', hint: '20000', controller: minOrderCtrl, keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              PrimaryButton(
                label: isEditing ? 'Simpan' : 'Tambahkan',
                onPressed: () async {
                  final newPromo = PromoModel(
                    code: codeCtrl.text.trim().toUpperCase(),
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    discountPercent: int.tryParse(percentCtrl.text) ?? 0,
                    discountFlat: int.tryParse(flatCtrl.text) ?? 0,
                    minOrder: int.tryParse(minOrderCtrl.text) ?? 0,
                    isActive: existing?.isActive ?? true,
                  );
                  if (isEditing) {
                    await ref.read(promoProvider.notifier).updatePromo(newPromo);
                  } else {
                    await ref.read(promoProvider.notifier).addPromo(newPromo);
                  }
                  Navigator.pop(ctx);
                },
                icon: Icons.save_rounded,
              ),
            ],
          ),
        ),
      ),
    );

    codeCtrl.dispose();
    titleCtrl.dispose();
    descCtrl.dispose();
    percentCtrl.dispose();
    flatCtrl.dispose();
    minOrderCtrl.dispose();
  }
}

class _PromoAdminCard extends StatelessWidget {
  final PromoModel promo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const _PromoAdminCard({
    required this.promo,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.softShadow,
        border: Border.all(
          color: promo.isActive ? AppColors.primary.withOpacity(0.3) : const Color(0xFFEEE0D5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: promo.isActive ? AppColors.primary.withOpacity(0.1) : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              promo.code,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: promo.isActive ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(promo.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(promo.discountLabel,
                    style: const TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Switch(
            value: promo.isActive,
            onChanged: (_) => onToggle(),
            activeColor: AppColors.primary,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.textHint),
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') onDelete();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'edit', child: Text('✏️ Edit')),
              const PopupMenuItem(value: 'delete', child: Text('🗑️ Hapus', style: TextStyle(color: AppColors.error))),
            ],
          ),
        ],
      ),
    );
  }
}
