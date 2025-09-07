// Caminho: lib/pages/landlord/property_list_page.dart
import 'package:flutter/material.dart';
import 'package:gestao_aluguel/data/property_repository.dart';
import 'package:gestao_aluguel/models/property.dart';
import 'package:gestao_aluguel/pages/landlord/add_edit_property_page.dart';
import 'package:gestao_aluguel/pages/landlord/property_details_page.dart';

class PropertyListPage extends StatefulWidget {
  const PropertyListPage({super.key});

  @override
  _PropertyListPageState createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  final PropertyRepository _repository = PropertyRepository();
  late Future<List<Property>> _propertiesFuture;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  void _loadProperties() {
    setState(() {
      // ATENÇÃO: ID do proprietário fixo (ex: 1).
      // Em um app real, pegaria do usuário logado.
      _propertiesFuture = _repository.getPropertiesForLandlord(1);
    });
  }

  void _navigateToAddEditPage({Property? property}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditPropertyPage(property: property),
      ),
    );
    if (result == true) {
      _loadProperties();
    }
  }

  void _deleteProperty(int id) async {
    try {
      await _repository.deleteProperty(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imóvel deletado com sucesso!')),
        );
      }
      _loadProperties();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao deletar imóvel: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Imóveis'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Property>>(
        future: _propertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum imóvel cadastrado.\nClique no botão + para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final properties = snapshot.data!;
          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PropertyDetailsPage(property: property),
                      ),
                    ).then((_) => _loadProperties());
                  },
                  title: Text(
                    property.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(property.address),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _navigateToAddEditPage(property: property),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProperty(property.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditPage(),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
