import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/promo_model.dart';

/// Data dummy untuk seluruh aplikasi DRS
/// Semua data awal ada di sini, mudah diedit
class DummyData {
  DummyData._();

  // =============================================
  // AKUN DUMMY
  // =============================================
  static final List<UserModel> users = [
    const UserModel(
      id: 'u001',
      name: 'Samuel Reinhard',
      email: 'customer@drs.com',
      password: 'customer123',
      phone: '081234567890',
      address: 'Jl. Donat Manis No. 12, Jakarta Selatan',
      role: 'customer',
    ),
    const UserModel(
      id: 'u002',
      name: 'Admin DRS',
      email: 'admin@drs.com',
      password: 'admin123',
      phone: '081298765432',
      address: 'Jl. Bakery Central No. 1, Jakarta',
      role: 'admin',
    ),
  ];

  // =============================================
  // DATA PRODUK (12 Donat + 3 Minuman)
  // =============================================
  static final List<ProductModel> products = [
    // --- DONAT COKLAT ---
    const ProductModel(
      id: 'p001',
      name: 'Donat Coklat Klasik',
      category: 'Donat Coklat',
      price: 8000,
      description: 'Donat lembut dengan topping coklat manis yang lumer di mulut. Pilihan sempurna untuk pecinta coklat sejati!',
      composition: 'Tepung terigu, gula, telur, mentega, ragi, coklat batang, meses coklat',
      imageUrl: '🍩',
      rating: 4.8,
      reviewCount: 234,
      soldCount: 1200,
      stock: 30,
      isAvailable: true,
    ),
    const ProductModel(
      id: 'p002',
      name: 'Donat Kacang Coklat',
      category: 'Donat Coklat',
      price: 10000,
      description: 'Perpaduan sempurna antara coklat lembut dan taburan kacang renyah yang menggugah selera.',
      composition: 'Tepung terigu, gula, telur, mentega, ragi, coklat, kacang tanah sangrai',
      imageUrl: '🍩',
      rating: 4.6,
      reviewCount: 178,
      soldCount: 890,
      stock: 25,
      isAvailable: true,
    ),

    // --- DONAT KEJU ---
    const ProductModel(
      id: 'p003',
      name: 'Donat Keju Susu',
      category: 'Donat Keju',
      price: 9000,
      description: 'Donat lembut dengan parutan keju cheddar berlimpah dan drizzle susu manis yang memanjakan.',
      composition: 'Tepung terigu, gula, telur, mentega, ragi, keju cheddar, susu kental manis',
      imageUrl: '🧀',
      rating: 4.7,
      reviewCount: 312,
      soldCount: 1500,
      stock: 28,
      isAvailable: true,
    ),

    // --- DONAT GLAZE ---
    const ProductModel(
      id: 'p004',
      name: 'Donat Strawberry Glaze',
      category: 'Donat Glaze',
      price: 8500,
      description: 'Donat dengan lapisan glaze strawberry segar berwarna pink cantik. Manis, segar, dan instagramable!',
      composition: 'Tepung terigu, gula, telur, mentega, ragi, selai strawberry, glaze gula',
      imageUrl: '🍓',
      rating: 4.9,
      reviewCount: 456,
      soldCount: 2100,
      stock: 20,
      isAvailable: true,
    ),
    const ProductModel(
      id: 'p005',
      name: 'Donat Caramel',
      category: 'Donat Glaze',
      price: 10000,
      description: 'Donat dengan saus caramel emas mengalir yang menciptakan rasa manis legit tak terlupakan.',
      composition: 'Tepung terigu, gula, telur, mentega, ragi, saus karamel, gula aren',
      imageUrl: '🍯',
      rating: 4.7,
      reviewCount: 198,
      soldCount: 780,
      stock: 22,
      isAvailable: true,
    ),
    const ProductModel(
      id: 'p006',
      name: 'Donat Gula Halus',
      category: 'Donat Glaze',
      price: 7000,
      description: 'Donat klasik yang dibalut gula halus putih. Simpel, enak, dan selalu bikin nagih!',
      composition: 'Tepung terigu, gula, telur, mentega, ragi, gula halus',
      imageUrl: '⚪',
      rating: 4.5,
      reviewCount: 145,
      soldCount: 960,
      stock: 35,
      isAvailable: true,
    ),

    // --- DONAT PREMIUM ---
    const ProductModel(
      id: 'p007',
      name: 'Donat Matcha Premium',
      category: 'Donat Premium',
      price: 12000,
      description: 'Donat premium dengan cita rasa matcha Jepang yang lembut dan autentik. Kaya antioksidan, kaya rasa!',
      composition: 'Tepung terigu, gula, telur, mentega, ragi, bubuk matcha premium, white chocolate',
      imageUrl: '🍵',
      rating: 4.9,
      reviewCount: 387,
      soldCount: 1800,
      stock: 15,
      isAvailable: true,
    ),
    const ProductModel(
      id: 'p008',
      name: 'Donat Tiramisu',
      category: 'Donat Premium',
      price: 12000,
      description: 'Donat premium terinspirasi dari dessert Italia klasik. Kopi, mascarpone, dan coklat dalam satu gigitan.',
      composition: 'Tepung terigu, gula, telur, mentega, ragi, espresso, krim mascarpone, coklat bubuk',
      imageUrl: '☕',
      rating: 4.8,
      reviewCount: 267,
      soldCount: 1200,
      stock: 12,
      isAvailable: true,
    ),
    const ProductModel(
      id: 'p009',
      name: 'Donat Oreo Cream',
      category: 'Donat Premium',
      price: 11000,
      description: 'Donat premium dengan krim oreo berlimpah dan taburan biskuit oreo yang renyah di setiap sudutnya.',
      composition: 'Tepung terigu, gula, telur, mentega, ragi, biskuit oreo, krim susu, coklat putih',
      imageUrl: '🍪',
      rating: 4.9,
      reviewCount: 523,
      soldCount: 2500,
      stock: 18,
      isAvailable: true,
    ),
    const ProductModel(
      id: 'p010',
      name: 'Donat Red Velvet',
      category: 'Donat Premium',
      price: 12000,
      description: 'Donat merah menawan dengan krim keju lembut. Cantik di mata, lezat di lidah!',
      composition: 'Tepung terigu, gula, telur, mentega, ragi, pewarna merah alami, krim keju',
      imageUrl: '🔴',
      rating: 4.8,
      reviewCount: 341,
      soldCount: 1650,
      stock: 14,
      isAvailable: true,
    ),

    // --- PAKET HEMAT ---
    const ProductModel(
      id: 'p011',
      name: 'Paket Hemat 6 Donat',
      category: 'Paket Hemat',
      price: 45000,
      description: 'Pilih 6 donat favoritmu dengan harga spesial! Cocok untuk berbagi bersama keluarga atau teman.',
      composition: 'Pilihan 6 donat sesuai selera (tersedia varian coklat, keju, glaze)',
      imageUrl: '📦',
      rating: 4.7,
      reviewCount: 189,
      soldCount: 650,
      stock: 10,
      isAvailable: true,
    ),
    const ProductModel(
      id: 'p012',
      name: 'Paket Keluarga 12 Donat',
      category: 'Paket Hemat',
      price: 85000,
      description: 'Lengkapi momen kebersamaan keluarga dengan 12 donat pilihan terbaik DRS. Hemat lebih banyak!',
      composition: 'Pilihan 12 donat sesuai selera + bonus 2 minuman',
      imageUrl: '🎁',
      rating: 4.9,
      reviewCount: 234,
      soldCount: 430,
      stock: 8,
      isAvailable: true,
    ),

    // --- MINUMAN ---
    const ProductModel(
      id: 'p013',
      name: 'Es Kopi Susu DRS',
      category: 'Minuman',
      price: 15000,
      description: 'Kopi susu dingin khas DRS dengan espresso premium dan susu segar. Teman sempurna donat kesayanganmu!',
      composition: 'Espresso, susu segar, gula aren, es batu',
      imageUrl: '🧋',
      rating: 4.8,
      reviewCount: 298,
      soldCount: 1100,
      stock: 50,
      isAvailable: true,
    ),
    const ProductModel(
      id: 'p014',
      name: 'Coklat Dingin',
      category: 'Minuman',
      price: 13000,
      description: 'Minuman coklat dingin yang kental dan lezat. Manis, creamy, dan menyegarkan!',
      composition: 'Bubuk coklat premium, susu segar, es batu, whipped cream',
      imageUrl: '🍫',
      rating: 4.6,
      reviewCount: 201,
      soldCount: 780,
      stock: 50,
      isAvailable: true,
    ),
    const ProductModel(
      id: 'p015',
      name: 'Teh Lemon',
      category: 'Minuman',
      price: 10000,
      description: 'Teh segar dengan perasan lemon asli yang menyegarkan. Pilihan sehat dan nikmat!',
      composition: 'Teh hitam premium, lemon segar, gula, es batu',
      imageUrl: '🍋',
      rating: 4.5,
      reviewCount: 156,
      soldCount: 590,
      stock: 50,
      isAvailable: true,
    ),
  ];

  // =============================================
  // DATA PROMO
  // =============================================
  static final List<PromoModel> promos = [
    const PromoModel(
      code: 'DRSHEMAT10',
      title: 'Hemat 10% untuk Semua Pesanan',
      description: 'Dapatkan diskon 10% untuk seluruh pesananmu. Berlaku setiap hari!',
      discountPercent: 10,
      discountFlat: 0,
      minOrder: 20000,
      isActive: true,
    ),
    const PromoModel(
      code: 'DONATFRESH',
      title: 'Diskon Rp 5.000',
      description: 'Potongan Rp 5.000 untuk pesanan pertamamu. Yuk cobain donat DRS!',
      discountPercent: 0,
      discountFlat: 5000,
      minOrder: 15000,
      isActive: true,
    ),
    const PromoModel(
      code: 'WEEKENDDRS',
      title: 'Promo Weekend Spesial',
      description: 'Khusus akhir pekan, dapatkan diskon 15% untuk paket hemat!',
      discountPercent: 15,
      discountFlat: 0,
      minOrder: 40000,
      isActive: true,
    ),
  ];

  // =============================================
  // BANNER PROMO (untuk Home Screen)
  // =============================================
  static final List<Map<String, dynamic>> banners = [
    {
      'title': 'Promo Spesial Hari Ini!',
      'subtitle': 'Diskon 10% dengan kode DRSHEMAT10',
      'emoji': '🎉',
      'color': 0xFF8B4513,
    },
    {
      'title': 'Donat Premium Baru!',
      'subtitle': 'Red Velvet & Tiramisu sudah tersedia',
      'emoji': '✨',
      'color': 0xFFE8956D,
    },
    {
      'title': 'Gratis Ongkir',
      'subtitle': 'Ambil langsung di toko kami',
      'emoji': '🛵',
      'color': 0xFF6B3410,
    },
  ];

  // =============================================
  // FAQ
  // =============================================
  static final List<Map<String, String>> faqs = [
    {
      'q': 'Apakah donat DRS dibuat fresh setiap hari?',
      'a': 'Ya! Semua donat kami dibuat fresh setiap pagi menggunakan bahan-bahan berkualitas pilihan.',
    },
    {
      'q': 'Apa metode pembayaran yang tersedia?',
      'a': 'Kami menerima COD (Bayar di Tempat), Transfer Bank, QRIS, dan berbagai E-Wallet.',
    },
    {
      'q': 'Berapa biaya pengiriman?',
      'a': 'Ongkos kirim standar Rp 10.000. Gratis ongkir jika kamu ambil langsung di toko!',
    },
    {
      'q': 'Bagaimana cara menggunakan voucher promo?',
      'a': 'Masukkan kode voucher di halaman checkout sebelum melakukan pembayaran.',
    },
    {
      'q': 'Apakah tersedia layanan antar ke luar kota?',
      'a': 'Saat ini kami melayani pengiriman di area sekitar toko. Hubungi kami untuk info lebih lanjut.',
    },
    {
      'q': 'Bagaimana jika pesanan saya salah atau rusak?',
      'a': 'Hubungi kami via WhatsApp dalam waktu 1 jam setelah pesanan diterima. Kami akan segera membantu!',
    },
  ];
}
