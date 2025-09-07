import 'package:flutter/material.dart';
import 'package:gestao_aluguel/pages/auth/login_page.dart';
import 'package:gestao_aluguel/pages/landlord/landlord_dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proprietário & Inquilino',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const LandlordDashboardPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
