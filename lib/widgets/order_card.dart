import 'package:flutter/material.dart';
import 'package:flutter_siparis_takip/models/order.dart';
import 'package:flutter_siparis_takip/utils/date.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  Color _statusColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return switch (order.status) {
      OrderStatus.newOrder => cs.primary,
      OrderStatus.preparing => cs.tertiary,
      OrderStatus.shipped => cs.secondary,
      OrderStatus.returnOrExchange => cs.error,
      OrderStatus.canceled => cs.error,
      OrderStatus.all => cs.outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final statusColor = _statusColor(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: IntrinsicHeight( // 👈 stretch güvenli hale geldi
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left status stripe takes the intrinsic height of content
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 👈 içerik kadar yükseklik
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              order.customerName,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              order.status.label,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.receipt_long, size: 16, color: cs.outline),
                          const SizedBox(width: 6),
                          Text('#${order.orderNo}', style: TextStyle(color: cs.onSurfaceVariant)),
                          const Spacer(),
                          Icon(Icons.access_time, size: 16, color: cs.outline),
                          const SizedBox(width: 6),
                          Text(
                            DateUtilsX.formatHuman(order.createdAt),
                            style: TextStyle(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.payments, size: 18, color: cs.primary),
                          const SizedBox(width: 6),
                          Text(
                            '${order.total.toStringAsFixed(2)} ₺',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
