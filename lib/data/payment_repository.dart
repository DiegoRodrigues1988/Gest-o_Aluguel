// Caminho: lib/data/payment_repository.dart
import 'package:gestao_aluguel/data/database_helper.dart';
import 'package:gestao_aluguel/models/payment.dart';

class PaymentRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Adiciona um novo registro de pagamento para um inquilino
  Future<int> insertPayment(Payment payment) async {
    final db = await _databaseHelper.database;
    return await db.insert('payments', payment.toMap());
  }

  // Busca todos os pagamentos de um inquilino específico
  Future<List<Payment>> getPaymentsForTenant(int tenantId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'payments',
      where: 'tenantId = ?',
      whereArgs: [tenantId],
      orderBy:
          'paymentDate DESC', // Ordena dos mais recentes para os mais antigos
    );
    return List.generate(maps.length, (i) => Payment.fromMap(maps[i]));
  }
}
