// Caminho: lib/models/tenant.dart
class Tenant {
  final int? id;
  final String name;
  final String? email;
  final String? phone;
  final int propertyId;

  Tenant({
    this.id,
    required this.name,
    this.email,
    this.phone,
    required this.propertyId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'propertyId': propertyId,
    };
  }

  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      propertyId: map['propertyId'],
    );
  }
}
