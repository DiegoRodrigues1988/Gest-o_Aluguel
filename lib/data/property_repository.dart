// Caminho: lib/data/property_repository.dart

import 'package:gestao_aluguel/models/property.dart';
import 'package:gestao_aluguel/data/database_helper.dart';

class PropertyRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Insere um novo imóvel no banco de dados
  Future<int> insertProperty(Property property) async {
    final db = await _databaseHelper.database;
    return await db.insert('properties', property.toMap());
  }

  // Busca todos os imóveis de um proprietário específico
  Future<List<Property>> getPropertiesForLandlord(int landlordId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'properties',
      where: 'landlordId = ?',
      whereArgs: [landlordId],
    );

    return List.generate(maps.length, (i) {
      return Property.fromMap(maps[i]);
    });
  }

  // (Futuramente, adicionaremos métodos para atualizar e deletar)
}
