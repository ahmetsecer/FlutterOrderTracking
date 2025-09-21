import 'package:flutter/material.dart';
import 'package:flutter_siparis_takip/models/order.dart';
import 'package:flutter_siparis_takip/utils/date.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;
  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final totalQty = order.items.fold<int>(0, (p, e) => p + e.qty);
    final totalAmount = order.items.fold<double>(0, (p, e) => p + (e.unitPrice * e.qty));

    return Scaffold(
      appBar: AppBar(title: const Text('Sipariş Detayı')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header summary card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(order.customerName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(order.status.label),
                        backgroundColor: cs.primary.withOpacity(0.08),
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
                      Text(DateUtilsX.formatHuman(order.createdAt), style: TextStyle(color: cs.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _StatPill(icon: Icons.inventory_2, label: 'Toplam Adet', value: '$totalQty'),
                      _StatPill(icon: Icons.payments, label: 'Toplam Tutar', value: '${totalAmount.toStringAsFixed(2)} ₺'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Items
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  leading: Icon(Icons.list_alt),
                  title: Text('Kalemler'),
                ),
                const Divider(height: 1),
                ...order.items.map((it) => ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(it.name),
                  subtitle: Text('SKU: ${it.sku} • Adet: ${it.qty} • Birim: ${it.unitPrice.toStringAsFixed(2)} ₺'),
                  trailing: Text(
                    '${(it.unitPrice * it.qty).toStringAsFixed(2)} ₺',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Address
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  leading: Icon(Icons.local_shipping_outlined),
                  title: Text('Teslimat Adresi'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(order.shippingAddress.fullName),
                  subtitle: Text(
                    '${order.shippingAddress.addressLine}\n'
                    '${order.shippingAddress.city}, ${order.shippingAddress.country}\n'
                    '${order.shippingAddress.phone}',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatPill({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: cs.primary),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(color: cs.onSurfaceVariant)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
