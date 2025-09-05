// Caminho: lib/models/property.dart

class Property {
  final int? id;
  final String name; // Ex: "Apto 101 - Edifício Sol"
  final String address; // Ex: "Rua das Flores, 123, São Paulo"
  final int landlordId; // ID do proprietário (usuário) dono do imóvel

  Property({
    this.id,
    required this.name,
    required this.address,
    required this.landlordId,
  });

  // Converte o objeto Property para um Map, para salvar no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'landlordId': landlordId,
    };
  }

  // Converte um Map vindo do banco de dados para um objeto Property
  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      landlordId: map['landlordId'],
    );
  }
}
