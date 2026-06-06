import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/order_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/promo_provider.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/primary_button.dart';

/// Halaman checkout pesanan
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  OrderMethod _orderMethod = OrderMethod.pickup;
  PaymentMethod _paymentMethod = PaymentMethod.cod;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Isi data dari profil pengguna
    final user = ref.read(authProvider).user;
    if (user != null) {
      _nameCtrl.text = user.name;
      _phoneCtrl.text = user.phone;
      _addressCtrl.text = user.address;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  int get _deliveryFee => _orderMethod == OrderMethod.delivery ? 10000 : 0;

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_orderMethod == OrderMethod.delivery && _addressCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alamat pengiriman wajib diisi untuk pengiriman'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final cartState = ref.read(cartProvider);
    final selectedPromo = ref.read(selectedPromoProvider);
    final user = ref.read(authProvider).user!;

    final discount = selectedPromo?.calculateDiscount(cartState.subtotal) ?? 0;
    final total = cartState.subtotal - discount + _deliveryFee;

    final order = await ref.read(orderProvider.notifier).createOrder(
      userId: user.id,
      items: cartState.items,
      subtotal: cartState.subtotal,
      discount: discount,
      deliveryFee: _deliveryFee,
      total: total,
      orderMethod: _orderMethod,
      paymentMethod: _paymentMethod,
      customerName: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      promoCode: selectedPromo?.code,
    );

    // Kosongkan keranjang & promo
    ref.read(cartProvider.notifier).clearCart();
    ref.read(selectedPromoProvider.notifier).state = null;

    setState(() => _isLoading = false);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.orderSuccess, arguments: order);
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final selectedPromo = ref.watch(selectedPromoProvider);
    final discount = selectedPromo?.calculateDiscount(cartState.subtotal) ?? 0;
    final total = cartState.subtotal - discount + _deliveryFee;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Ringkasan item
            _SectionCard(
              title: '🛍️ Ringkasan Pesanan',
              child: Column(
                children: [
                  ...cartState.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Text(item.product.imageUrl, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  Text('x${item.quantity}',
                                      style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                                ],
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(item.totalPrice),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Data penerima
            _SectionCard(
              title: '📋 Data Penerima',
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Nama Penerima',
                    hint: 'Nama lengkap',
                    controller: _nameCtrl,
                    validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Nomor WhatsApp',
                    hint: '0812xxxxxxx',
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Metode pesanan
            _SectionCard(
              title: '🛵 Metode Pesanan',
              child: Column(
                children: OrderMethod.values.map((method) {
                  return RadioListTile<OrderMethod>(
                    value: method,
                    groupValue: _orderMethod,
                    onChanged: (v) => setState(() => _orderMethod = v!),
                    title: Text(method.label),
                    subtitle: method == OrderMethod.delivery
                        ? const Text('Ongkos kirim Rp 10.000')
                        : const Text('Gratis - Ambil di Jl. Bakery No. 1'),
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.primary,
                    dense: true,
                  );
                }).toList(),
              ),
            ),

            // Alamat (jika delivery)
            if (_orderMethod == OrderMethod.delivery) ...[
              const SizedBox(height: 14),
              _SectionCard(
                title: '📍 Alamat Pengiriman',
                child: CustomTextField(
                  label: 'Alamat Lengkap',
                  hint: 'Jalan, RT/RW, Kelurahan, Kota',
                  controller: _addressCtrl,
                  maxLines: 3,
                  validator: (v) => (_orderMethod == OrderMethod.delivery && (v == null || v.isEmpty))
                      ? 'Alamat wajib diisi untuk pengiriman'
                      : null,
                ),
              ),
            ],

            const SizedBox(height: 14),

            // Metode pembayaran
            _SectionCard(
              title: '💳 Metode Pembayaran',
              child: Column(
                children: PaymentMethod.values.map((method) {
                  return RadioListTile<PaymentMethod>(
                    value: method,
                    groupValue: _paymentMethod,
                    onChanged: (v) => setState(() => _paymentMethod = v!),
                    title: Text(method.label),
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.primary,
                    dense: true,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 14),

            // Total bayar
            _SectionCard(
              title: '💰 Rincian Pembayaran',
              child: Column(
                children: [
                  _Row('Subtotal', CurrencyFormatter.format(cartState.subtotal)),
                  if (discount > 0)
                    _Row('Diskon', '- ${CurrencyFormatter.format(discount)}', color: AppColors.success),
                  _Row('Ongkos Kirim', _deliveryFee == 0 ? 'Gratis' : CurrencyFormatter.format(_deliveryFee)),
                  const Divider(height: 16),
                  _Row('Total Bayar', CurrencyFormatter.format(total), isBold: true, color: AppColors.primary),
                ],
              ),
            ),

            const SizedBox(height: 24),

            PrimaryButton(
              label: 'Buat Pesanan',
              onPressed: _placeOrder,
              isLoading: _isLoading,
              icon: Icons.check_rounded,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  const _Row(this.label, this.value, {this.isBold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: isBold ? 15 : 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: color ?? AppColors.textPrimary)),
        ],
      ),
    );
  }
}
