// Caminho: lib/models/property.dart

class Property {
  final int? id;
  final String name;
  final String address;
  final String description;
  final String status; // "Disponível", "Ocupado", "Em Manutenção"
  final int landlordId;

  Property({
    this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.status,
    required this.landlordId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'status': status,
      'landlordId': landlordId,
    };
  }

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      description: map['description'] ?? '', // Garantir que não seja nulo
      status: map['status'],
      landlordId: map['landlordId'],
    );
  }
}
