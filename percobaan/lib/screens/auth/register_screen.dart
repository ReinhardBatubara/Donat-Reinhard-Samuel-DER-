import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

/// Layar registrasi akun baru
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.customerMain);
    } else {
      final error = ref.read(authProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Terjadi kesalahan'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buat Akun Baru ✨',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Daftar sekarang dan nikmati donat DRS terbaik!',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 28),

                // Nama lengkap
                CustomTextField(
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap',
                  controller: _nameCtrl,
                  prefixIcon: const Icon(Icons.person_outline, size: 20, color: AppColors.textHint),
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Nama tidak boleh kosong';
                    if (v.trim().length < 2) return 'Nama minimal 2 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Email
                CustomTextField(
                  label: 'Email',
                  hint: 'contoh@email.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColors.textHint),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email tidak boleh kosong';
                    if (!v.contains('@') || !v.contains('.')) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // No HP
                CustomTextField(
                  label: 'Nomor WhatsApp',
                  hint: 'Contoh: 0812xxxxxxx',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20, color: AppColors.textHint),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Nomor HP tidak boleh kosong';
                    if (v.length < 10) return 'Nomor HP tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Password
                CustomTextField(
                  label: 'Kata Sandi',
                  hint: 'Minimal 6 karakter',
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textHint),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.textHint,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Kata sandi tidak boleh kosong';
                    if (v.length < 6) return 'Kata sandi minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Konfirmasi password
                CustomTextField(
                  label: 'Konfirmasi Kata Sandi',
                  hint: 'Ulangi kata sandi',
                  controller: _confirmPasswordCtrl,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _register(),
                  prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textHint),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.textHint,
                    ),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Konfirmasi kata sandi tidak boleh kosong';
                    if (v != _passwordCtrl.text) return 'Kata sandi tidak cocok';
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Tombol daftar
                PrimaryButton(
                  label: 'Daftar Sekarang',
                  onPressed: _register,
                  isLoading: authState.isLoading,
                  icon: Icons.person_add_rounded,
                ),
                const SizedBox(height: 16),

                // Sudah punya akun
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun? ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
