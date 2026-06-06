import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/order_model.dart';
import '../../../widgets/primary_button.dart';

/// Halaman sukses setelah checkout berhasil
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as OrderModel;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),

              // Animasi sukses
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.check_rounded, color: Colors.white, size: 60),
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                '🎉 Pesanan Berhasil!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Pesananmu sudah kami terima. Pantau status pesananmu ya!',
                style: TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Info pesanan
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.creamDark),
                ),
                child: Column(
                  children: [
                    _InfoRow(label: 'Nomor Pesanan', value: order.id),
                    _InfoRow(label: 'Total Bayar', value: CurrencyFormatter.format(order.total)),
                    _InfoRow(label: 'Metode', value: order.orderMethod.label),
                    _InfoRow(label: 'Pembayaran', value: order.paymentMethod.label),
                    _InfoRow(label: 'Status', value: order.status.label, valueColor: AppColors.warning),
                  ],
                ),
              ),

              const Spacer(),

              PrimaryButton(
                label: 'Lihat Status Pesanan',
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.orderStatus,
                  arguments: order,
                ),
                icon: Icons.receipt_long_rounded,
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Kembali ke Beranda',
                isOutlined: true,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.customerMain,
                  (route) => false,
                ),
                icon: Icons.home_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: valueColor ?? AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
