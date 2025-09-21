import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_siparis_takip/models/order.dart';

enum SortMode { dateDesc, dateAsc, totalDesc, totalAsc }

class UserPrefs {
  final SortMode sortMode;
  final bool dark;
  final DateTime? start;
  final DateTime? end;
  UserPrefs({required this.sortMode, required this.dark, this.start, this.end});

  Map<String, dynamic> toMap() => {
    'sortMode': sortMode.index,
    'dark': dark,
    'start': start?.toIso8601String(),
    'end': end?.toIso8601String(),
  };

  static UserPrefs fromMap(Map<String, dynamic> m) => UserPrefs(
    sortMode: SortMode.values[m['sortMode'] as int],
    dark: m['dark'] as bool,
    start: m['start'] != null ? DateTime.parse(m['start'] as String) : null,
    end: m['end'] != null ? DateTime.parse(m['end'] as String) : null,
  );

  static Future<UserPrefs> load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString('prefs');
    if (raw == null) return UserPrefs(sortMode: SortMode.dateDesc, dark: false);
    return UserPrefs.fromMap(json.decode(raw) as Map<String, dynamic>);
  }

  static Future<void> save(UserPrefs prefs) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('prefs', json.encode(prefs.toMap()));
  }
}

class OrderService {
  Future<List<Order>> fetchOrders() async {
    // Mock veri: assets'ten okunur. Gerçek API için http.get ile değiştirin.
    final jsonStr = await rootBundle.loadString('assets/orders.json');
    final orders = Order.fromJsonList(jsonStr);
    return orders;
  }

  List<Order> applyFilters({
    required List<Order> orders,
    required OrderStatus status,
    required String query,
    required SortMode sortMode,
    DateTime? start,
    DateTime? end,
  }) {
    var list = orders.where((o) {
      final okStatus = status == OrderStatus.all ? true : o.status == status;
      final okQuery = query.isEmpty ||
          o.customerName.toLowerCase().contains(query) ||
          o.orderNo.toLowerCase().contains(query);
      final okDate = (start == null || o.createdAt.isAfter(start.subtract(const Duration(seconds: 1)))) &&
                     (end == null || o.createdAt.isBefore(end.add(const Duration(days: 1))));
      return okStatus && okQuery && okDate;
    }).toList();

    switch (sortMode) {
      case SortMode.dateDesc:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortMode.dateAsc:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortMode.totalDesc:
        list.sort((a, b) => b.total.compareTo(a.total));
        break;
      case SortMode.totalAsc:
        list.sort((a, b) => a.total.compareTo(b.total));
        break;
    }
    return list;
  }
}
