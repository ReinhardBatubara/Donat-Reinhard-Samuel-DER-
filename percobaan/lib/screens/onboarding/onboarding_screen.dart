import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../data/local_storage.dart';
import '../../widgets/primary_button.dart';

class _OnboardingPage {
  final String emoji;
  final String title;
  final String description;
  final Color color;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
  });
}

/// Layar onboarding 3 halaman dengan PageView
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      emoji: '🍩',
      title: AppStrings.onboarding1Title,
      description: AppStrings.onboarding1Desc,
      color: Color(0xFF8B4513),
    ),
    _OnboardingPage(
      emoji: '🌟',
      title: AppStrings.onboarding2Title,
      description: AppStrings.onboarding2Desc,
      color: Color(0xFFE8956D),
    ),
    _OnboardingPage(
      emoji: '🛵',
      title: AppStrings.onboarding3Title,
      description: AppStrings.onboarding3Desc,
      color: Color(0xFF6B3410),
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await LocalStorage.setHasSeenOnboarding(true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final page = _pages[index];
              return _OnboardingPageView(page: page);
            },
          ),

          // Kontrol bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.05)],
                ),
              ),
              child: Column(
                children: [
                  // Indikator halaman
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : AppColors.creamDark,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 28),

                  // Tombol
                  PrimaryButton(
                    label: _currentPage == _pages.length - 1 ? 'Mulai Sekarang' : 'Selanjutnya',
                    onPressed: _next,
                    icon: _currentPage == _pages.length - 1
                        ? Icons.rocket_launch_rounded
                        : Icons.arrow_forward_rounded,
                  ),
                  const SizedBox(height: 12),

                  // Tombol lewati
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _finish,
                      child: const Text(
                        'Lewati',
                        style: TextStyle(color: AppColors.textHint),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.background),
      child: Column(
        children: [
          // Ilustrasi atas
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [page.color, page.color.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(page.emoji, style: const TextStyle(fontSize: 100)),
                    const SizedBox(height: 16),
                    Text(
                      'DRS',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white.withOpacity(0.3),
                        letterSpacing: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Teks bawah
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    page.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    page.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
