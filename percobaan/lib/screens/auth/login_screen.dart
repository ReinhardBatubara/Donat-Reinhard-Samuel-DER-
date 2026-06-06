import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

/// Layar login untuk customer dan admin
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).login(
      _emailCtrl.text.trim(),
      _passwordCtrl.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      final authState = ref.read(authProvider);
      if (authState.isAdmin) {
        Navigator.pushReplacementNamed(context, AppRoutes.adminMain);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.customerMain);
      }
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('🍩', style: TextStyle(fontSize: 40)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'DRS',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: 6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Donat Reinhard Samuel',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                const Text(
                  'Selamat Datang! 👋',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Masuk untuk menikmati donat favoritmu',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),

                // Form email
                CustomTextField(
                  label: 'Email',
                  hint: 'contoh@email.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColors.textHint),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email tidak boleh kosong';
                    if (!v.contains('@')) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Form password
                CustomTextField(
                  label: 'Kata Sandi',
                  hint: 'Masukkan kata sandi',
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _login(),
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
                const SizedBox(height: 28),

                // Tombol login
                PrimaryButton(
                  label: 'Masuk',
                  onPressed: _login,
                  isLoading: authState.isLoading,
                  icon: Icons.login_rounded,
                ),
                const SizedBox(height: 20),

                // Daftar
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun? ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                        child: const Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Info akun demo
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.creamDark),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                          SizedBox(width: 6),
                          Text(
                            'Akun Demo',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _DemoAccount(label: 'Customer', email: 'customer@drs.com', password: 'customer123'),
                      const SizedBox(height: 4),
                      _DemoAccount(label: 'Admin', email: 'admin@drs.com', password: 'admin123'),
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

class _DemoAccount extends StatelessWidget {
  final String label;
  final String email;
  final String password;

  const _DemoAccount({
    required this.label,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$email / $password',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
