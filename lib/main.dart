import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_application_1/views/login_view.dart';
import 'package:flutter_application_1/views/dashboard.dart';
import 'package:flutter_application_1/views/product_view.dart';
import 'package:flutter_application_1/views/transaksi_view.dart';
import 'package:flutter_application_1/views/cart_screen.dart';        // ← TAMBAH
import 'package:flutter_application_1/views/register_user_view.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rizza's Store",
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/': (context) => const RegisterUserView(),
        '/login': (context) => const LoginView(),
        '/dashboard': (context) => const DashboardView(),
        '/product': (context) => const ProductView(),
        '/transaksi': (context) => const TransaksiView(),
        '/cart': (context) => const CartScreen(),             // ← TAMBAH
      },
    );
  }
}