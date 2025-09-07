// Caminho: lib/pages/landlord/property_details_page.dart
import 'package:flutter/material.dart';
import 'package:gestao_aluguel/data/payment_repository.dart';
import 'package:gestao_aluguel/data/tenant_repository.dart';
import 'package:gestao_aluguel/models/payment.dart';
import 'package:gestao_aluguel/models/property.dart';
import 'package:gestao_aluguel/models/tenant.dart';
import 'package:intl/intl.dart';

class PropertyDetailsPage extends StatefulWidget {
  final Property property;
  const PropertyDetailsPage({super.key, required this.property});

  @override
  State<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  final TenantRepository _tenantRepository = TenantRepository();
  final PaymentRepository _paymentRepository = PaymentRepository();
  late Future<List<Tenant>> _tenantsFuture;

  @override
  void initState() {
    super.initState();
    _loadTenants();
  }

  void _loadTenants() {
    setState(() {
      _tenantsFuture =
          _tenantRepository.getTenantsForProperty(widget.property.id!);
    });
  }

  Future<void> _showAddTenantDialog() async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Novo Inquilino'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Nome Completo'),
                    validator: (value) =>
                        value!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration:
                        const InputDecoration(labelText: 'Email (Opcional)'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration:
                        const InputDecoration(labelText: 'Telefone (Opcional)'),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Salvar'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newTenant = Tenant(
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    propertyId: widget.property.id!,
                  );
                  await _tenantRepository.insertTenant(newTenant);
                  Navigator.of(context).pop();
                  _loadTenants(); // Recarrega a lista de inquilinos
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Dialog para adicionar pagamento (será chamado a partir do card do inquilino)
  Future<void> _showAddPaymentDialog(Tenant tenant) async {
    final amountController = TextEditingController();
    final monthController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Registrar Pagamento para ${tenant.name}'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: amountController,
                  decoration:
                      const InputDecoration(labelText: 'Valor (Ex: 1500.00)'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: monthController,
                  decoration: const InputDecoration(
                      labelText: 'Mês de Referência (Ex: Setembro/2025)'),
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Registrar'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newPayment = Payment(
                    amount: double.parse(amountController.text),
                    paymentDate: DateTime.now(),
                    referenceMonth: monthController.text,
                    tenantId: tenant.id!,
                  );
                  await _paymentRepository.insertPayment(newPayment);
                  Navigator.of(context).pop();
                  setState(() {}); // Força a UI a recarregar o histórico
                }
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.property.name),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.property.address,
                style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(widget.property.description),
            const Divider(height: 32),
            const Text('Inquilinos',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            FutureBuilder<List<Tenant>>(
              future: _tenantsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child:
                        Text('Nenhum inquilino cadastrado para este imóvel.'),
                  ));
                }

                final tenants = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tenants.length,
                  itemBuilder: (context, index) {
                    final tenant = tenants[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ExpansionTile(
                        title: Text(tenant.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(tenant.email ?? 'Sem email'),
                        children: [
                          FutureBuilder<List<Payment>>(
                            future: _paymentRepository
                                .getPaymentsForTenant(tenant.id!),
                            builder: (context, paymentSnapshot) {
                              if (paymentSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const LinearProgressIndicator();
                              }
                              if (!paymentSnapshot.hasData ||
                                  paymentSnapshot.data!.isEmpty) {
                                return const ListTile(
                                    title:
                                        Text('Nenhum pagamento registrado.'));
                              }
                              final payments = paymentSnapshot.data!;
                              return Column(
                                children: [
                                  ...payments
                                      .map((p) => ListTile(
                                            title: Text(
                                                '${p.referenceMonth} - ${NumberFormat.simpleCurrency(locale: 'pt_BR').format(p.amount)}'),
                                            subtitle: Text(
                                                'Pago em: ${DateFormat('dd/MM/yyyy').format(p.paymentDate)}'),
                                          ))
                                      .toList(),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton.icon(
                              icon: const Icon(Icons.add_card),
                              label: const Text('Registrar Pagamento'),
                              onPressed: () => _showAddPaymentDialog(tenant),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTenantDialog,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
