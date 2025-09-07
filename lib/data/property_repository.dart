// Caminho: lib/data/property_repository.dart

import 'package:gestao_aluguel/models/property.dart';
import 'package:gestao_aluguel/data/database_helper.dart';

/// Repositório responsável pelas operações de CRUD relacionadas à tabela `properties`.
class PropertyRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Insere um novo imóvel no banco de dados.
  ///
  /// Retorna o `id` gerado para o novo imóvel.
  Future<int> insertProperty(Property property) async {
    final db = await _databaseHelper.database;
    return await db.insert('properties', property.toMap());
  }

  /// Retorna todos os imóveis cadastrados de um proprietário específico.
  ///
  /// [landlordId] é o identificador do proprietário.
  Future<List<Property>> getPropertiesForLandlord(int landlordId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'properties',
      where: 'landlordId = ?',
      whereArgs: [landlordId],
      orderBy: 'id DESC', // Mantém os últimos cadastrados no topo
    );

    return List.generate(maps.length, (i) => Property.fromMap(maps[i]));
  }

  /// Atualiza os dados de um imóvel existente.
  ///
  /// Retorna o número de linhas afetadas.
  Future<int> updateProperty(Property property) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'properties',
      property.toMap(),
      where: 'id = ?',
      whereArgs: [property.id],
    );
  }

  /// Remove um imóvel do banco de dados pelo [id].
  ///
  /// Retorna o número de linhas deletadas.
  Future<int> deleteProperty(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'properties',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Busca um imóvel específico pelo [id].
  ///
  /// Retorna um [Property] se encontrado, caso contrário `null`.
  Future<Property?> getPropertyById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'properties',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Property.fromMap(maps.first);
    }
    return null;
  }
}
