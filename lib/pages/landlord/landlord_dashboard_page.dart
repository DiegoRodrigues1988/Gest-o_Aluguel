// Caminho: lib/pages/landlord/landlord_dashboard_page.dart

import 'package:flutter/material.dart';

class LandlordDashboardPage extends StatefulWidget {
  const LandlordDashboardPage({super.key});

  @override
  State<LandlordDashboardPage> createState() => _LandlordDashboardPageState();
}

class _LandlordDashboardPageState extends State<LandlordDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Painel'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Navega de volta para a tela de login
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDashboardCard(
            context,
            icon: Icons.home_work,
            title: 'Meus Imóveis',
            subtitle: 'Visualize e adicione novos imóveis',
            onTap: () {
              // Ação futura: Navegar para a lista de imóveis
            },
          ),
          const SizedBox(height: 16),
          _buildDashboardCard(
            context,
            icon: Icons.people,
            title: 'Inquilinos',
            subtitle: 'Gerencie seus inquilinos e contratos',
            onTap: () {
              // Ação futura: Navegar para a lista de inquilinos
            },
          ),
          const SizedBox(height: 16),
          _buildDashboardCard(
            context,
            icon: Icons.request_quote,
            title: 'Financeiro',
            subtitle: 'Acompanhe pagamentos e relatórios',
            onTap: () {
              // Ação futura: Navegar para a área financeira
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Ação futura: Navegar para a tela de adicionar novo imóvel
        },
        label: const Text('Novo Imóvel'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
