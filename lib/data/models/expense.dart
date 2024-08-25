class Expense {
  final int? id;
  final double? amount;
  final String? currency;
  final String? note;
  final String? createdDate;
  final int? expenseType;
  final String? expenseTypeName;

  Expense({
    this.id, 
    this.amount,
    this.currency,
    this.note,
    this.createdDate,
    this.expenseType,
    this.expenseTypeName
  });
  
  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
    id: map['id'] as int?,
    amount: map['amount'] as double,
    currency: map['currency'] as String,
    note: map['note'] as String?,
    createdDate: map['createdDate'] as String,
    expenseType: map['expenseType'] as int,
    expenseTypeName: map['expenseTypeName'] as String?
    );
    
    Map<String, dynamic> toMap() {
      return {
        'amount' : amount,
        'currency' : currency,
        'note' : note,
        'createdDate' : createdDate,
        'expenseType' : expenseType
      };
    }
}

class ExpenseType {
  final int? id;
  final String? name;

  ExpenseType({this.id, this.name});
  
  factory ExpenseType.fromMap(Map<String, dynamic> map) => ExpenseType(id: map['id'] ?? -1, name: map['name'] ?? '');
  
  Map<String, dynamic> toMap() {
    return {
      'name' : name
    };
  }
}