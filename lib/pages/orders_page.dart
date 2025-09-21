import 'package:flutter/material.dart';
import 'package:flutter_siparis_takip/models/order.dart';
import 'package:flutter_siparis_takip/pages/order_detail_page.dart';
import 'package:flutter_siparis_takip/services/order_service.dart';
import 'package:flutter_siparis_takip/utils/date.dart';
import 'package:flutter_siparis_takip/widgets/order_card.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _service = OrderService();
  List<Order> _all = [];
  String _query = '';
  bool _loading = true;

  SortMode _sortMode = SortMode.dateDesc;
  DateTime? _start;
  DateTime? _end;

  final tabs = const [
    OrderStatus.all,
    OrderStatus.newOrder,
    OrderStatus.preparing,
    OrderStatus.shipped,
    OrderStatus.returnOrExchange,
    OrderStatus.canceled,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _init();
  }

  Future<void> _init() async {
    final prefs = await UserPrefs.load();
    setState(() {
      _sortMode = prefs.sortMode;
      _start = prefs.start;
      _end = prefs.end;
    });
    await _load();
  }

  Future<void> _savePrefs() async {
    await UserPrefs.save(
        UserPrefs(sortMode: _sortMode, dark: false, start: _start, end: _end));
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _service.fetchOrders();
    setState(() {
      _all = data;
      _loading = false;
    });
  }

  List<Order> _filtered() {
    final status = tabs[_tabController.index];
    return _service.applyFilters(
      orders: _all,
      status: status,
      query: _query.toLowerCase(),
      sortMode: _sortMode,
      start: _start,
      end: _end,
    );
  }

  Map<OrderStatus, int> _counts() {
    final map = {for (var s in tabs) s: 0};
    for (final o in _all) {
      for (final s in tabs) {
        if (s == OrderStatus.all || o.status == s) {
          map[s] = (map[s] ?? 0) + 1;
        }
      }
    }
    return map;
  }

  Future<void> _pickRange() async {
    final init = DateTimeRange(
        start: _start ?? DateTime.now().subtract(const Duration(days: 7)),
        end: _end ?? DateTime.now());
    final res = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        initialDateRange: init);
    if (res != null) {
      setState(() {
        _start = res.start;
        _end = res.end;
      });
      _savePrefs();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final counts = _counts();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sipariş Takip'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tabs.map((t) {
            final c = counts[t] ?? 0;
            return Tab(text: '${t.label} ($c)');
          }).toList(),
          onTap: (_) => setState(() {}),
        ),
        actions: [
          IconButton(
            tooltip: 'Tarih Aralığı',
            onPressed: _pickRange,
            icon: const Icon(Icons.date_range),
          ),
          PopupMenuButton<SortMode>(
            tooltip: 'Sırala',
            onSelected: (v) {
              setState(() => _sortMode = v);
              _savePrefs();
            },
            itemBuilder: (ctx) => const [
              PopupMenuItem(
                  value: SortMode.dateDesc, child: Text('Tarih: Yeni→Eski')),
              PopupMenuItem(
                  value: SortMode.dateAsc, child: Text('Tarih: Eski→Yeni')),
              PopupMenuItem(
                  value: SortMode.totalDesc,
                  child: Text('Tutar: Yüksek→Düşük')),
              PopupMenuItem(
                  value: SortMode.totalAsc, child: Text('Tutar: Düşük→Yüksek')),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Müşteri / Sipariş No ara...',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_start != null || _end != null)
                      IconButton(
                        tooltip: 'Tarih filtresini temizle',
                        icon: const Icon(Icons.clear_all),
                        onPressed: () {
                          setState(() {
                            _start = null;
                            _end = null;
                          });
                          _savePrefs();
                        },
                      ),
                    if (_query.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _query = ''),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                if (_start != null || _end != null)
                  Chip(
                    label: Text(
                        '${_start != null ? DateUtilsX.formatDate(_start!) : '…'} - ${_end != null ? DateUtilsX.formatDate(_end!) : '…'}'),
                    onDeleted: () {
                      setState(() {
                        _start = null;
                        _end = null;
                      });
                      _savePrefs();
                    },
                  ),
                const Spacer(),
                Text(
                  '${_filtered().length} kayıt',
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _load,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : Builder(
                      builder: (context) {
                        final items = _filtered();
                        if (items.isEmpty) {
                          return ListView(
                            children: [
                              const SizedBox(height: 120),
                              Icon(Icons.inbox, size: 64, color: cs.outline),
                              const SizedBox(height: 12),
                              const Center(child: Text('Kayıt bulunamadı')),
                            ],
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 12),
                          itemCount: items.length,
                          itemBuilder: (context, i) {
                            final o = items[i];
                            return OrderCard(
                              order: o,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => OrderDetailPage(order: o)),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _load,
        icon: const Icon(Icons.refresh),
        label: const Text('Yenile'),
      ),
    );
  }
}
