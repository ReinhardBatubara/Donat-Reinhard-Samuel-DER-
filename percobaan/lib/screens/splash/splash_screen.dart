import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../data/local_storage.dart';
import '../../providers/auth_provider.dart';

/// Splash screen dengan animasi logo DRS
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );

    _animController.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Cek apakah sudah pernah lihat onboarding
    final hasSeenOnboarding = await LocalStorage.hasSeenOnboarding();
    if (!hasSeenOnboarding) {
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      return;
    }

    // Cek status login
    final authState = ref.read(authProvider);
    if (authState.isLoggedIn) {
      if (authState.isAdmin) {
        if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.adminMain);
      } else {
        if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.customerMain);
      }
    } else {
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo bulat
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '🍩',
                              style: TextStyle(fontSize: 60),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Nama brand
                        const Text(
                          'DRS',
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 8,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Sub nama
                        Text(
                          'Donat Reinhard Samuel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.85),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Tagline
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Donat Manis, Lembut, dan Selalu Fresh',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),

                        // Loading indicator
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            color: Colors.white.withOpacity(0.7),
                            strokeWidth: 2.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
