import 'dart:convert';

enum OrderStatus {
  all,
  newOrder,
  preparing,
  shipped,
  returnOrExchange,
  canceled,
}

extension OrderStatusX on OrderStatus {
  int get code => switch (this) {
        OrderStatus.all => 0,
        OrderStatus.newOrder => 1,
        OrderStatus.preparing => 2,
        OrderStatus.shipped => 3,
        OrderStatus.returnOrExchange => 4,
        OrderStatus.canceled => 5,
      };

  String get label => switch (this) {
        OrderStatus.all => 'Tümü',
        OrderStatus.newOrder => 'Yeni',
        OrderStatus.preparing => 'Hazırlanıyor',
        OrderStatus.shipped => 'Kargoda',
        OrderStatus.returnOrExchange => 'İptal/Değişim/İade',
        OrderStatus.canceled => 'İptal',
      };

  static OrderStatus fromCode(int code) {
    return switch (code) {
      1 => OrderStatus.newOrder,
      2 => OrderStatus.preparing,
      3 => OrderStatus.shipped,
      4 => OrderStatus.returnOrExchange,
      5 => OrderStatus.canceled,
      _ => OrderStatus.all,
    };
  }
}

class OrderItem {
  final String sku;
  final String name;
  final int qty;
  final double unitPrice;
  OrderItem({required this.sku, required this.name, required this.qty, required this.unitPrice});
  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
    sku: map['sku'] as String,
    name: map['name'] as String,
    qty: map['qty'] as int,
    unitPrice: (map['unitPrice'] as num).toDouble(),
  );
}

class Address {
  final String fullName;
  final String phone;
  final String addressLine;
  final String city;
  final String country;
  Address({required this.fullName, required this.phone, required this.addressLine, required this.city, required this.country});
  factory Address.fromMap(Map<String, dynamic> m) => Address(
    fullName: m['fullName'] as String,
    phone: m['phone'] as String,
    addressLine: m['addressLine'] as String,
    city: m['city'] as String,
    country: m['country'] as String,
  );
}

class Order {
  final String id;
  final String orderNo;
  final String customerName;
  final double total;
  final DateTime createdAt;
  final OrderStatus status;
  final List<OrderItem> items;
  final Address shippingAddress;

  Order({
    required this.id,
    required this.orderNo,
    required this.customerName,
    required this.total,
    required this.createdAt,
    required this.status,
    required this.items,
    required this.shippingAddress,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      orderNo: map['orderNo'] as String,
      customerName: map['customerName'] as String,
      total: (map['total'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      status: OrderStatusX.fromCode(map['status'] as int),
      items: (map['items'] as List<dynamic>).map((e) => OrderItem.fromMap(e as Map<String, dynamic>)).toList(),
      shippingAddress: Address.fromMap(map['shippingAddress'] as Map<String, dynamic>),
    );
  }

  static List<Order> fromJsonList(String jsonStr) {
    final data = json.decode(jsonStr) as List<dynamic>;
    return data.map((e) => Order.fromMap(e as Map<String, dynamic>)).toList();
  }
}
