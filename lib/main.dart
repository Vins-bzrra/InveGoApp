import 'package:flutter/material.dart';
import 'package:invego_app/pages/inventory_page.dart';
import 'package:invego_app/pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de Inventário',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: LoginPage(),
      home: const InventoryPage(),
    );
  }
}