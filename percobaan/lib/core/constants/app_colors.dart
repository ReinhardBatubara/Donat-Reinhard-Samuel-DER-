import 'package:flutter/material.dart';

/// Palet warna utama brand DRS - Donat Reinhard Samuel
class AppColors {
  AppColors._();

  // === Warna Utama ===
  static const Color primary = Color(0xFF8B4513);      // Coklat donat
  static const Color primaryLight = Color(0xFFA0522D);  // Coklat muda
  static const Color primaryDark = Color(0xFF6B3410);   // Coklat tua

  // === Warna Aksen ===
  static const Color accent = Color(0xFFE8956D);        // Orange caramel
  static const Color accentLight = Color(0xFFF0A982);   // Orange caramel muda

  // === Warna Pink / Strawberry ===
  static const Color pink = Color(0xFFE91E8C);          // Pink strawberry
  static const Color pinkLight = Color(0xFFFCE4EC);     // Pink sangat muda

  // === Warna Cream ===
  static const Color cream = Color(0xFFFFF8F0);         // Cream hangat
  static const Color creamDark = Color(0xFFF5E6D3);     // Cream sedikit gelap

  // === Warna Netral ===
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAF7F4);    // Latar belakang hangat
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8EFE7); // Surface agak krem

  // === Warna Teks ===
  static const Color textPrimary = Color(0xFF2C1810);   // Teks utama coklat tua
  static const Color textSecondary = Color(0xFF6B4C3B); // Teks sekunder
  static const Color textHint = Color(0xFFB08070);      // Teks placeholder
  static const Color textLight = Color(0xFFFFFFFF);     // Teks putih

  // === Status Warna ===
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // === Warna Status Pesanan ===
  static const Color statusWaiting = Color(0xFFFF9800);
  static const Color statusProcess = Color(0xFF2196F3);
  static const Color statusReady = Color(0xFF9C27B0);
  static const Color statusDelivery = Color(0xFF00BCD4);
  static const Color statusDone = Color(0xFF4CAF50);
  static const Color statusCancelled = Color(0xFFE53935);

  // === Gradient ===
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B4513), Color(0xFFE8956D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFFF8F0), Color(0xFFF5E6D3)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF6B3410), Color(0xFF8B4513), Color(0xFFE8956D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // === Shadow ===
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.10),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
