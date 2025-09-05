// Caminho: lib/main.dart
// ATENÇÃO: Atualize esta importação para o novo caminho da sua LoginPage.

import 'package:flutter/material.dart';
import 'package:gestao_aluguel/pages/auth/login_page.dart'; // <-- Caminho corrigido
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
      // Adicionando rotas nomeadas para facilitar a navegação
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const LandlordDashboardPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
