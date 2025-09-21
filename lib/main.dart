import 'package:flutter/material.dart';
import 'package:flutter_siparis_takip/pages/orders_page.dart';
import 'package:flutter_siparis_takip/theme.dart';

void main() {
  runApp(const OrdersRoot());
}

class OrdersRoot extends StatefulWidget {
  const OrdersRoot({super.key});
  @override
  State<OrdersRoot> createState() => _OrdersRootState();
}

class _OrdersRootState extends State<OrdersRoot> {
  final appTheme = AppTheme();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appTheme,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sipariş Takip',
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: appTheme.mode,
          home: Scaffold(
            body: const OrdersPage(),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: Text('Flutter Sipariş Takip', style: TextStyle(fontWeight: FontWeight.w600))),
                    IconButton(
                      tooltip: 'Tema Değiştir',
                      icon: Icon(appTheme.mode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
                      onPressed: appTheme.toggle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
