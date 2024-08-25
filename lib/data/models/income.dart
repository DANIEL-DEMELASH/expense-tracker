class Income {
  final int? id;
  final double? amount;
  final String? currency;
  final String? note;
  final String? createdDate;
  final int? incomeType;
  final String? incomeTypeName;

  Income({
    this.id, 
    this.amount,
    this.currency,
    this.note,
    this.createdDate,
    this.incomeType,
    this.incomeTypeName
  });
  
  factory Income.fromMap(Map<String, dynamic> map) => Income(
    id: map['id'] as int?,
    amount: map['amount'] as double?,
    currency: map['currency'] as String?,
    note: map['note'] as String?,
    createdDate: map['createdDate'] as String?,
    incomeType: map['incomeType'] as int?,
    incomeTypeName: map['incomeTypeName'] as String?
    );
    
    Map<String, dynamic> toMap() {
      return {
        'amount' : amount,
        'currency' : currency,
        'note' : note,
        'createdDate' : createdDate,
        'incomeType' : incomeType
      };
    }
}

class IncomeType {
  final int? id;
  final String? name;

  IncomeType({this.id, required this.name});
  
  factory IncomeType.fromMap(Map<String, dynamic> map) => IncomeType(id: map['id'] ?? -1, name: map['name'] ?? '');
  
  Map<String, dynamic> toMap() {
    return {
      'name' : name
    };
  }
}