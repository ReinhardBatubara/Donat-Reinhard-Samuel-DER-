/// Semua string konstan yang digunakan dalam aplikasi DRS
class AppStrings {
  AppStrings._();

  // === Brand ===
  static const String appName = 'DRS';
  static const String appFullName = 'Donat Reinhard Samuel';
  static const String tagline = 'Donat Manis, Lembut, dan Selalu Fresh';

  // === Onboarding ===
  static const String onboarding1Title = 'Donat Fresh Setiap Hari';
  static const String onboarding1Desc =
      'Nikmati donat yang dibuat segar setiap pagi dengan bahan-bahan berkualitas pilihan. Kelembutan di setiap gigitan!';

  static const String onboarding2Title = 'Pilih Varian Favoritmu';
  static const String onboarding2Desc =
      'Tersedia berbagai varian donat dari coklat klasik, keju, strawberry glaze, hingga premium matcha dan tiramisu.';

  static const String onboarding3Title = 'Pesan Mudah, Ambil atau Antar';
  static const String onboarding3Desc =
      'Pesan kapan saja lewat aplikasi. Ambil langsung di toko atau kami antar ke depan pintumu!';

  // === Auth ===
  static const String login = 'Masuk';
  static const String register = 'Daftar';
  static const String logout = 'Keluar';
  static const String email = 'Email';
  static const String password = 'Kata Sandi';
  static const String confirmPassword = 'Konfirmasi Kata Sandi';
  static const String name = 'Nama Lengkap';
  static const String phone = 'Nomor HP';
  static const String forgotPassword = 'Lupa kata sandi?';
  static const String noAccount = 'Belum punya akun? ';
  static const String hasAccount = 'Sudah punya akun? ';

  // === Bottom Navigation ===
  static const String navHome = 'Beranda';
  static const String navCatalog = 'Katalog';
  static const String navOrder = 'Pesanan';
  static const String navFavorite = 'Favorit';
  static const String navProfile = 'Profil';

  // === Admin Navigation ===
  static const String navDashboard = 'Dashboard';
  static const String navProduct = 'Produk';
  static const String navPromo = 'Promo';
  static const String navReport = 'Laporan';

  // === Categories ===
  static const String catAll = 'Semua';
  static const String catChocolate = 'Donat Coklat';
  static const String catCheese = 'Donat Keju';
  static const String catGlaze = 'Donat Glaze';
  static const String catPremium = 'Donat Premium';
  static const String catBundle = 'Paket Hemat';
  static const String catDrink = 'Minuman';

  // === Order Status ===
  static const String statusWaiting = 'Menunggu Konfirmasi';
  static const String statusProcess = 'Diproses';
  static const String statusReady = 'Siap Diambil';
  static const String statusDelivery = 'Dalam Pengiriman';
  static const String statusDone = 'Selesai';
  static const String statusCancelled = 'Dibatalkan';

  // === Order Method ===
  static const String methodPickup = 'Ambil di Toko';
  static const String methodDelivery = 'Antar ke Alamat';

  // === Payment Method ===
  static const String paymentCOD = 'COD (Bayar di Tempat)';
  static const String paymentTransfer = 'Transfer Bank';
  static const String paymentQRIS = 'QRIS';
  static const String paymentEWallet = 'E-Wallet';

  // === Common ===
  static const String save = 'Simpan';
  static const String cancel = 'Batal';
  static const String confirm = 'Konfirmasi';
  static const String delete = 'Hapus';
  static const String edit = 'Edit';
  static const String add = 'Tambah';
  static const String search = 'Cari donat favoritmu...';
  static const String loading = 'Memuat...';
  static const String retry = 'Coba Lagi';

  // === Cart ===
  static const String cart = 'Keranjang';
  static const String cartEmpty = 'Keranjangmu masih kosong';
  static const String cartEmptyDesc = 'Yuk, tambahkan donat favoritmu ke keranjang!';
  static const String subtotal = 'Subtotal';
  static const String discount = 'Diskon';
  static const String deliveryFee = 'Ongkos Kirim';
  static const String totalPayment = 'Total Bayar';
  static const String checkout = 'Checkout';

  // === Checkout ===
  static const String recipientName = 'Nama Penerima';
  static const String whatsappNumber = 'Nomor WhatsApp';
  static const String deliveryAddress = 'Alamat Pengiriman';
  static const String orderMethod = 'Metode Pesanan';
  static const String paymentMethod = 'Metode Pembayaran';
  static const String orderSummary = 'Ringkasan Pesanan';
  static const String placeOrder = 'Buat Pesanan';

  // === Success ===
  static const String orderSuccess = 'Pesanan Berhasil!';
  static const String orderSuccessDesc =
      'Pesananmu sudah kami terima. Pantau status pesananmu di halaman Pesanan ya!';
  static const String viewOrder = 'Lihat Pesanan';
  static const String backToHome = 'Kembali ke Beranda';

  // === Empty States ===
  static const String emptyOrder = 'Belum ada pesanan';
  static const String emptyOrderDesc = 'Pesananmu akan muncul di sini setelah kamu checkout.';
  static const String emptyFavorite = 'Belum ada favorit';
  static const String emptyFavoriteDesc = 'Tap ikon hati di produk untuk menyimpan favoritmu.';
  static const String emptyProduct = 'Produk tidak ditemukan';
  static const String emptyProductDesc = 'Coba cari dengan kata kunci lain.';
  static const String emptyPromo = 'Tidak ada promo aktif';
  static const String emptyPromoDesc = 'Pantau terus halaman ini untuk mendapatkan promo terbaik!';
}
