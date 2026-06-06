/// Model data promo / voucher diskon
class PromoModel {
  final String code;       // Kode voucher, contoh: DRSHEMAT10
  final String title;
  final String description;
  final int discountPercent;    // Persentase diskon (0 jika flat)
  final int discountFlat;       // Diskon flat dalam Rupiah (0 jika persen)
  final int minOrder;           // Minimum pesanan untuk menggunakan promo
  final bool isActive;

  const PromoModel({
    required this.code,
    required this.title,
    required this.description,
    this.discountPercent = 0,
    this.discountFlat = 0,
    this.minOrder = 0,
    this.isActive = true,
  });

  /// Hitung nilai diskon berdasarkan total belanja
  int calculateDiscount(int total) {
    if (!isActive) return 0;
    if (total < minOrder) return 0;
    if (discountPercent > 0) {
      return (total * discountPercent / 100).round();
    }
    if (discountFlat > 0) {
      return discountFlat;
    }
    return 0;
  }

  /// Label tipe diskon untuk ditampilkan
  String get discountLabel {
    if (discountPercent > 0) return '$discountPercent%';
    if (discountFlat > 0) return 'Rp ${discountFlat ~/ 1000}rb';
    return '-';
  }

  PromoModel copyWith({
    String? code,
    String? title,
    String? description,
    int? discountPercent,
    int? discountFlat,
    int? minOrder,
    bool? isActive,
  }) {
    return PromoModel(
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      discountPercent: discountPercent ?? this.discountPercent,
      discountFlat: discountFlat ?? this.discountFlat,
      minOrder: minOrder ?? this.minOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'title': title,
      'description': description,
      'discountPercent': discountPercent,
      'discountFlat': discountFlat,
      'minOrder': minOrder,
      'isActive': isActive,
    };
  }

  factory PromoModel.fromMap(Map<String, dynamic> map) {
    return PromoModel(
      code: map['code'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      discountPercent: map['discountPercent'] ?? 0,
      discountFlat: map['discountFlat'] ?? 0,
      minOrder: map['minOrder'] ?? 0,
      isActive: map['isActive'] ?? true,
    );
  }
}
