import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/primary_button.dart';

/// Halaman profil pengguna
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _addressCtrl = TextEditingController(text: user?.address ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).updateProfile(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
    );

    setState(() => _isEditing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui ✅')),
      );
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar?'),
        content: const Text('Apakah kamu yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(authProvider.notifier).logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        automaticallyImplyLeading: false,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            TextButton(
              onPressed: () => setState(() => _isEditing = false),
              child: const Text('Batal'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (user?.name.isNotEmpty == true) ? user!.name[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user?.name ?? '-',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              Text(
                user?.email ?? '-',
                style: const TextStyle(fontSize: 13, color: AppColors.textHint),
              ),
              const SizedBox(height: 28),

              // Form data
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Informasi Akun', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    // Email (readonly)
                    _InfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user?.email ?? '-',
                    ),
                    const Divider(height: 16),

                    if (_isEditing) ...[
                      CustomTextField(
                        label: 'Nama Lengkap',
                        controller: _nameCtrl,
                        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: 'Nomor WhatsApp',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: 'Alamat Utama',
                        controller: _addressCtrl,
                        maxLines: 2,
                      ),
                    ] else ...[
                      _InfoTile(icon: Icons.person_outline, label: 'Nama', value: user?.name ?? '-'),
                      const Divider(height: 16),
                      _InfoTile(icon: Icons.phone_outlined, label: 'No. HP', value: user?.phone.isNotEmpty == true ? user!.phone : 'Belum diisi'),
                      const Divider(height: 16),
                      _InfoTile(
                        icon: Icons.location_on_outlined,
                        label: 'Alamat',
                        value: user?.address.isNotEmpty == true ? user!.address : 'Belum diisi',
                      ),
                    ],
                  ],
                ),
              ),

              if (_isEditing) ...[
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Simpan Perubahan',
                  onPressed: _saveProfile,
                  icon: Icons.save_rounded,
                ),
              ],

              const SizedBox(height: 20),

              // Menu tambahan
              _MenuTile(
                icon: Icons.local_offer_outlined,
                label: 'Promo & Voucher',
                onTap: () => Navigator.pushNamed(context, AppRoutes.promo),
              ),
              _MenuTile(
                icon: Icons.help_outline_rounded,
                label: 'Bantuan & FAQ',
                onTap: () => Navigator.pushNamed(context, AppRoutes.help),
              ),
              const SizedBox(height: 8),
              _MenuTile(
                icon: Icons.logout_rounded,
                label: 'Keluar',
                onTap: _logout,
                color: AppColors.error,
              ),
              const SizedBox(height: 32),

              // Versi aplikasi
              const Text('DRS App v1.0.0', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
              const Text('Donat Reinhard Samuel', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textHint),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
              Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.softShadow,
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.primary),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color ?? AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
