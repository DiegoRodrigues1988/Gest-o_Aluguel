// Caminho: lib/data/tenant_repository.dart
import 'package:gestao_aluguel/data/database_helper.dart';
import 'package:gestao_aluguel/models/tenant.dart';

class TenantRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Adiciona um novo inquilino a um imóvel
  Future<int> insertTenant(Tenant tenant) async {
    final db = await _databaseHelper.database;
    return await db.insert('tenants', tenant.toMap());
  }

  // Busca todos os inquilinos de um imóvel específico
  Future<List<Tenant>> getTenantsForProperty(int propertyId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tenants',
      where: 'propertyId = ?',
      whereArgs: [propertyId],
    );
    return List.generate(maps.length, (i) => Tenant.fromMap(maps[i]));
  }

  // Deleta um inquilino
  Future<int> deleteTenant(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'tenants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
