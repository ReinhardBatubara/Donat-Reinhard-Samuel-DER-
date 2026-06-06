import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/order_model.dart';

/// Widget timeline untuk menampilkan riwayat status pesanan
class OrderStatusTimeline extends StatelessWidget {
  final OrderStatus currentStatus;

  const OrderStatusTimeline({
    super.key,
    required this.currentStatus,
  });

  static const _statuses = [
    OrderStatus.waiting,
    OrderStatus.process,
    OrderStatus.ready,
    OrderStatus.delivery,
    OrderStatus.done,
  ];

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.waiting:   return AppColors.statusWaiting;
      case OrderStatus.process:   return AppColors.statusProcess;
      case OrderStatus.ready:     return AppColors.statusReady;
      case OrderStatus.delivery:  return AppColors.statusDelivery;
      case OrderStatus.done:      return AppColors.statusDone;
      case OrderStatus.cancelled: return AppColors.statusCancelled;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.waiting:   return Icons.access_time_rounded;
      case OrderStatus.process:   return Icons.restaurant_rounded;
      case OrderStatus.ready:     return Icons.check_circle_outline_rounded;
      case OrderStatus.delivery:  return Icons.local_shipping_rounded;
      case OrderStatus.done:      return Icons.done_all_rounded;
      case OrderStatus.cancelled: return Icons.cancel_rounded;
    }
  }

  bool _isCompleted(OrderStatus status) {
    if (currentStatus == OrderStatus.cancelled) return status == OrderStatus.cancelled;
    return _statuses.indexOf(status) <= _statuses.indexOf(currentStatus);
  }

  @override
  Widget build(BuildContext context) {
    if (currentStatus == OrderStatus.cancelled) {
      return _buildCancelledView();
    }

    return Column(
      children: List.generate(_statuses.length, (index) {
        final status = _statuses[index];
        final isCompleted = _isCompleted(status);
        final isCurrent = status == currentStatus;
        final color = isCompleted ? _getStatusColor(status) : AppColors.textHint.withOpacity(0.3);
        final isLast = index == _statuses.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ikon & garis timeline
            Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isCompleted ? color : AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                    border: isCurrent
                        ? Border.all(color: color, width: 2)
                        : null,
                  ),
                  child: Icon(
                    _getStatusIcon(status),
                    size: 18,
                    color: isCompleted ? Colors.white : AppColors.textHint.withOpacity(0.5),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 36,
                    color: isCompleted && !isCurrent
                        ? color.withOpacity(0.5)
                        : AppColors.surfaceVariant,
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Label status
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                        color: isCompleted ? AppColors.textPrimary : AppColors.textHint,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(height: 2),
                      Text(
                        status.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCancelledView() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.statusCancelled,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.cancel_rounded, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                OrderStatus.cancelled.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.statusCancelled,
                ),
              ),
              Text(
                OrderStatus.cancelled.description,
                style: const TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
