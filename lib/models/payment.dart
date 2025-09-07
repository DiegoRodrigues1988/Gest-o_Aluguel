// Caminho: lib/models/payment.dart
class Payment {
  final int? id;
  final double amount;
  final DateTime paymentDate;
  final String referenceMonth;
  final int tenantId;

  Payment({
    this.id,
    required this.amount,
    required this.paymentDate,
    required this.referenceMonth,
    required this.tenantId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),
      'referenceMonth': referenceMonth,
      'tenantId': tenantId,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      amount: map['amount'],
      paymentDate: DateTime.parse(map['paymentDate']),
      referenceMonth: map['referenceMonth'],
      tenantId: map['tenantId'],
    );
  }
}
