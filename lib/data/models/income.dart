class Income {
  final int? id;
  final double? amount;
  final String? currency;
  final String? note;
  final String? createdDate;
  final IncomeType? incomeType;

  Income({
    this.id, 
    this.amount,
    this.currency,
    this.note,
    this.createdDate,
    this.incomeType
  });
  
  factory Income.fromMap(Map<String, dynamic> map) => Income(
    id: map['id'] ?? -1,
    amount: map['amount'] ?? 0.0,
    currency: map['currency'] ?? '',
    note: map['note'] ?? '',
    createdDate: map['createdDate'] ?? '',
    incomeType: IncomeType.fromMap(map['incomeType'])
    );
}

class IncomeType {
  final int? id;
  final String? name;

  IncomeType({required this.id, required this.name});
  
  factory IncomeType.fromMap(Map<String, dynamic> map) => IncomeType(id: map['id'] ?? -1, name: map['name'] ?? '');
}