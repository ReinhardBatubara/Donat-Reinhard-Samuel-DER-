# 🍩 DRS (Donat Reinhard Samuel) - Full-Stack Mobile App & Go Backend

[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D%203.5.0-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D%203.5.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Go Version](https://img.shields.io/badge/Go-%3E%3D%201.20-00ADD8?style=for-the-badge&logo=go&logoColor=white)](https://go.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue?style=for-the-badge)](https://flutter.dev)
[![Database](https://img.shields.io/badge/Database-MySQL-orange?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com)

Proyek **DRS (Donat Reinhard Samuel)** adalah sebuah ekosistem aplikasi penjualan donat modern yang dirancang untuk memberikan pengalaman transaksi digital terbaik bagi pelanggan dan kemudahan operasional bagi admin toko. 

Repositori ini menggabungkan dua komponen utama:
1. **Frontend (`percobaan/`)**: Aplikasi mobile cross-platform berbasis **Flutter & Riverpod** yang mendukung alur lengkap untuk **Customer** dan **Admin**.
2. **Backend (`backend/`)**: REST API server berkinerja tinggi yang ditulis menggunakan **Go (Golang)** dengan integrasi database **MySQL**.

---

## 🚀 Komponen Sistem

### 1. 📱 Frontend Mobile App (`percobaan/`)
Aplikasi mobile modern berorientasi visual tinggi, dibangun dengan Flutter yang berfokus pada kemudahan transaksi dan manajemen produk donat.

#### ✨ Fitur Aktor Utama:
*   **Aktor Pelanggan (Customer)**:
    *   **Katalog Donat**: Telusuri beragam varian donat dengan visual menarik, detail harga, deskripsi, dan status stok.
    *   **Keranjang Belanja (Cart) & Checkout**: Kelola kuantitas pesanan, masukkan kode promo, isi alamat pengiriman, dan buat pesanan.
    *   **Daftar Favorit**: Simpan varian donat favorit untuk akses pembelian cepat di kemudian hari.
    *   **Riwayat & Pelacakan Pesanan (Timeline)**: Lacak status pesanan secara real-time melalui visual lini masa (*timeline*).
    *   **Manajemen Promo**: Lihat kode diskon aktif yang dapat digunakan.
*   **Aktor Administrator (Admin Toko)**:
    *   **Dashboard Statistik**: Grafik ringkasan penjualan, total pendapatan, jumlah pesanan, dan donat terlaris.
    *   **CRUD Produk (Kelola Produk)**: Menambah, mengubah detail, mengganti gambar, atau menghapus menu donat.
    *   **Manajemen Order Masuk**: Memproses status pesanan pelanggan (*Menunggu*, *Diproses*, *Dikirim*, *Selesai*).
    *   **Laporan Penjualan (Report)**: Rekap pendapatan harian/bulanan.
    *   **Kelola Kode Promo**: Membuat voucher diskon baru atau menonaktifkannya.

#### ⚙️ Arsitektur Flutter:
*   **State Management**: **Flutter Riverpod (v2.x)** untuk pengelolaan state yang modular dan responsif.
*   **Penyimpanan Lokal**: **Shared Preferences** untuk menyimpan data persistensi seperti status login pengguna, isi keranjang belanja, status pesanan, dan menu donat kustom.
*   **Theme & Typography**: Desain visual bergaya Material 3 dengan palet warna donat pastel hangat, menggunakan **Google Fonts**.

---

### 2. 🔌 Backend API Server (`backend/`)
Server backend berkinerja tinggi yang dikembangkan dengan **Go (Golang)** untuk memfasilitasi kebutuhan layanan web data dinamis.

#### ✨ Fitur & Karakteristik:
*   **RESTful API**: Menyediakan *endpoints* standar untuk manajemen tugas/data (GET, POST).
*   **MySQL Database Driver**: Menghubungkan langsung server Go dengan server database MySQL lokal (Laragon/XAMPP).
*   **CORS Enabled**: Mendukung pengaksesan API secara lintas domain/asal (CORS) agar dapat dikonsumsi oleh aplikasi mobile dalam jaringan WiFi lokal.
*   **Low Latency & High Performance**: Memanfaatkan concurrency model Go yang efisien.

---

## 📂 Struktur Folder Proyek

```text
Donat-Reinhard-Samuel-DER-/
├── backend/                       # Komponen Server Go (Golang)
│   ├── go.mod                     # File definisi modul Go
│   ├── go.sum                     # Checksum dependensi Go
│   └── main.go                    # Kode utama server & konfigurasi REST API
│
└── percobaan/                     # Komponen Frontend App (Flutter)
    ├── assets/                    # Aset gambar donat dan ikon aplikasi
    ├── lib/
    │   ├── core/
    │   │   ├── constants/         # Rute aplikasi & konstanta string/warna
    │   │   ├── theme/             # Tema warna pastel donat (Material 3)
    │   │   └── utils/             # Formatter uang (Rupiah) & format tanggal
    │   ├── data/
    │   │   ├── dummy_data.dart    # Data katalog donat awal & akun simulasi
    │   │   └── local_storage.dart # Helper SharedPreferences untuk persistensi lokal
    │   ├── models/                # Objek data (User, Product, Cart, Order, Promo)
    │   ├── providers/             # State provider Riverpod (Auth, Cart, Orders, dll.)
    │   ├── screens/
    │   │   ├── splash/            # Layar awal Splash Screen dengan logo
    │   │   ├── onboarding/        # Panduan penggunaan awal aplikasi
    │   │   ├── auth/              # Form Login & Registrasi (Customer/Admin)
    │   │   ├── customer/          # Halaman khusus pelanggan (Home, Catalog, Cart, dll.)
    │   │   └── admin/             # Dashboard manajemen data admin (Order, Product)
    │   └── widgets/               # Komponen UI reusable (Card, Button, Timeline)
    └── pubspec.yaml               # Definisi package Flutter
```

---

## 🚀 Panduan Instalasi & Menjalankan Aplikasi

### 1. Menjalankan Backend Go (Golang)
1.  **Prasyarat**: Pastikan [Go SDK](https://go.dev/dl/) dan database **MySQL** (via Laragon / XAMPP) telah terinstal dan aktif.
2.  **Buat Database**: Buat database baru bernama `task_db` pada server MySQL lokal Anda.
    ```sql
    CREATE DATABASE task_db;
    USE task_db;
    CREATE TABLE tasks (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        is_completed BOOLEAN DEFAULT FALSE
    );
    ```
3.  **Jalankan Server**:
    Masuk ke direktori backend lalu jalankan server:
    ```bash
    cd backend
    go run main.go
    ```
    *Server backend akan aktif di port `8080` (`http://localhost:8080`).*

### 2. Menjalankan Frontend Flutter (`percobaan`)
1.  **Prasyarat**: Pastikan [Flutter SDK](https://docs.flutter.dev/get-started/install) versi terbaru telah terpasang.
2.  **Unduh Dependensi**:
    ```bash
    cd percobaan
    flutter pub get
    ```
3.  **Jalankan Emulator & Run**:
    Jalankan aplikasi di emulator Android, iOS, atau browser web:
    ```bash
    flutter run
    ```

---

## 🔑 Akun Uji Coba (Simulasi Login)

Untuk memudahkan pengujian alur kerja, aplikasi telah dibekali beberapa akun dummy di database lokal (`dummy_data.dart`):

| Role / Peran | Email | Kata Sandi | Kegunaan |
| --- | --- | --- | --- |
| **Customer (Pelanggan)** | `user@gmail.com` | `user123` | Belanja donat, favorit, klaim voucher, checkout, pelacakan |
| **Admin (Pemilik Toko)** | `admin@gmail.com` | `admin123` | Input donat baru, konfirmasi order, kelola diskon, pantau statistik |

---

## 🎨 Panduan Desain UI/UX
*   **Warm Pastel Design**: Penggunaan visual dominan warna krim, oranye pastel, dan cokelat donat yang mengunggah selera.
*   **Interactive Cards**: Transisi halus saat berinteraksi dengan item menu donat.
*   **Modern Checkouts & Timelines**: Tampilan check-out intuitif dan visualisasi status pesanan interaktif.

---

## 👤 Pengembang (Developer)

*   **Nama**: Reinhard Batubara
*   **Pendidikan**: S1 Sistem Informasi - Institut Teknologi Del
*   **GitHub**: [@ReinhardBatubara](https://github.com/ReinhardBatubara)
*   **Email**: [reinhardbatubara607@gmail.com](mailto:reinhardbatubara607@gmail.com)

---
*Dibuat dengan penuh rasa manis 🍩 oleh Reinhard Batubara.*