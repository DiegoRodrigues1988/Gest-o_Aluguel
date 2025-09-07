// Caminho: lib/pages/landlord/add_edit_property_page.dart
// ATENÇÃO: Este é um arquivo novo que precisa ser criado.

import 'package:flutter/material.dart';
import 'package:gestao_aluguel/data/property_repository.dart';
import 'package:gestao_aluguel/models/property.dart';

class AddEditPropertyPage extends StatefulWidget {
  final Property? property;

  const AddEditPropertyPage({super.key, this.property});

  @override
  _AddEditPropertyPageState createState() => _AddEditPropertyPageState();
}

class _AddEditPropertyPageState extends State<AddEditPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final _repository = PropertyRepository();
  bool _isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;
  late String _selectedStatus;

  final List<String> _statusOptions = [
    'Disponível',
    'Ocupado',
    'Em Manutenção'
  ];

  @override
  void initState() {
    super.initState();
    final isEditing = widget.property != null;

    _nameController =
        TextEditingController(text: isEditing ? widget.property!.name : '');
    _addressController =
        TextEditingController(text: isEditing ? widget.property!.address : '');
    _descriptionController = TextEditingController(
        text: isEditing ? widget.property!.description : '');
    _selectedStatus =
        isEditing ? widget.property!.status : _statusOptions.first;
  }

  Future<void> _saveProperty() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // ATENÇÃO: ID do proprietário fixo por enquanto.
      // Em um app real, você pegaria o ID do usuário logado.
      const landlordId = 1;

      final property = Property(
        id: widget.property?.id,
        name: _nameController.text,
        address: _addressController.text,
        description: _descriptionController.text,
        status: _selectedStatus,
        landlordId: landlordId,
      );

      try {
        if (widget.property == null) {
          await _repository.insertProperty(property);
        } else {
          await _repository.updateProperty(property);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Imóvel salvo com sucesso!')),
          );
          // Retorna 'true' para a página anterior saber que deve recarregar a lista
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar imóvel: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.property == null ? 'Novo Imóvel' : 'Editar Imóvel'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Imóvel (Ex: Apto 101)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Endereço Completo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: _statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveProperty,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Salvar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
