import 'cart_item_model.dart';
import 'product_model.dart';

/// Status pesanan
enum OrderStatus {
  waiting,   // Menunggu Konfirmasi
  process,   // Diproses
  ready,     // Siap Diambil
  delivery,  // Dalam Pengiriman
  done,      // Selesai
  cancelled, // Dibatalkan
}

/// Extension untuk mendapatkan label dan info status pesanan
extension OrderStatusExt on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.waiting:   return 'Menunggu Konfirmasi';
      case OrderStatus.process:   return 'Diproses';
      case OrderStatus.ready:     return 'Siap Diambil';
      case OrderStatus.delivery:  return 'Dalam Pengiriman';
      case OrderStatus.done:      return 'Selesai';
      case OrderStatus.cancelled: return 'Dibatalkan';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.waiting:   return 'Pesanan kamu sedang menunggu konfirmasi dari toko.';
      case OrderStatus.process:   return 'Pesanan sedang diproses dan donat sedang dibuat.';
      case OrderStatus.ready:     return 'Pesanan siap diambil di toko DRS.';
      case OrderStatus.delivery:  return 'Pesanan sedang dalam perjalanan menuju alamatmu.';
      case OrderStatus.done:      return 'Pesanan telah selesai. Terima kasih sudah memesan!';
      case OrderStatus.cancelled: return 'Pesanan dibatalkan.';
    }
  }

  String get value {
    return name;
  }

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OrderStatus.waiting,
    );
  }
}

/// Metode pengiriman pesanan
enum OrderMethod { pickup, delivery }

extension OrderMethodExt on OrderMethod {
  String get label {
    switch (this) {
      case OrderMethod.pickup:   return 'Ambil di Toko';
      case OrderMethod.delivery: return 'Antar ke Alamat';
    }
  }
  String get value => name;
  static OrderMethod fromString(String v) =>
      v == 'delivery' ? OrderMethod.delivery : OrderMethod.pickup;
}

/// Metode pembayaran
enum PaymentMethod { cod, transfer, qris, ewallet }

extension PaymentMethodExt on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.cod:      return 'COD (Bayar di Tempat)';
      case PaymentMethod.transfer: return 'Transfer Bank';
      case PaymentMethod.qris:     return 'QRIS';
      case PaymentMethod.ewallet:  return 'E-Wallet';
    }
  }
  String get value => name;
  static PaymentMethod fromString(String v) =>
      PaymentMethod.values.firstWhere((e) => e.name == v, orElse: () => PaymentMethod.cod);
}

/// Model data pesanan
class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final int subtotal;
  final int discount;
  final int deliveryFee;
  final int total;
  final OrderMethod orderMethod;
  final PaymentMethod paymentMethod;
  final String customerName;
  final String phone;
  final String address;
  final OrderStatus status;
  final DateTime createdAt;
  final String? promoCode;  // Kode promo yang digunakan

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
    required this.orderMethod,
    required this.paymentMethod,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.status,
    required this.createdAt,
    this.promoCode,
  });

  /// Jumlah total item
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Nama produk pertama (untuk preview)
  String get firstProductName => items.isNotEmpty ? items.first.product.name : '-';

  OrderModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? items,
    int? subtotal,
    int? discount,
    int? deliveryFee,
    int? total,
    OrderMethod? orderMethod,
    PaymentMethod? paymentMethod,
    String? customerName,
    String? phone,
    String? address,
    OrderStatus? status,
    DateTime? createdAt,
    String? promoCode,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      orderMethod: orderMethod ?? this.orderMethod,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      promoCode: promoCode ?? this.promoCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => {
        'productId': item.product.id,
        'productName': item.product.name,
        'productPrice': item.product.price,
        'productCategory': item.product.category,
        'productImageUrl': item.product.imageUrl,
        'quantity': item.quantity,
        'note': item.note,
      }).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'deliveryFee': deliveryFee,
      'total': total,
      'orderMethod': orderMethod.value,
      'paymentMethod': paymentMethod.value,
      'customerName': customerName,
      'phone': phone,
      'address': address,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'promoCode': promoCode,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final List<dynamic> itemsList = map['items'] ?? [];
    final items = itemsList.map((itemMap) {
      final product = ProductModel(
        id: itemMap['productId'] ?? '',
        name: itemMap['productName'] ?? '',
        category: itemMap['productCategory'] ?? '',
        price: itemMap['productPrice'] ?? 0,
        description: '',
        imageUrl: itemMap['productImageUrl'] ?? '',
      );
      return CartItemModel(
        product: product,
        quantity: itemMap['quantity'] ?? 1,
        note: itemMap['note'] ?? '',
      );
    }).toList();

    return OrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: items,
      subtotal: map['subtotal'] ?? 0,
      discount: map['discount'] ?? 0,
      deliveryFee: map['deliveryFee'] ?? 0,
      total: map['total'] ?? 0,
      orderMethod: OrderMethodExt.fromString(map['orderMethod'] ?? ''),
      paymentMethod: PaymentMethodExt.fromString(map['paymentMethod'] ?? ''),
      customerName: map['customerName'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      status: OrderStatusExt.fromString(map['status'] ?? ''),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      promoCode: map['promoCode'],
    );
  }
}
