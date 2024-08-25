class Total {
  final int? id;
  final String? month;
  final double? totalIncome;
  final double? totalExpense;
  final double? balance;
  final String? currency;
  
  Total({
    this.id,
    this.month,
    this.totalIncome,
    this.totalExpense,
    this.balance,
    this.currency
  });
  
  factory Total.fromMap(Map<String, dynamic> map) => Total(
    id: map['id'] as int?,
    month: map['month'] as String?,
    totalIncome: map['totalIncome'] as double?,
    totalExpense: map['totalExpense'] as double?,
    balance: map['balance'] as double?,
    currency: map['currency'] as String?
  );
  
  Map<String, dynamic> toMap() {
      return {
        'month' : month,
        'totalIncome' : totalIncome,
        'totalExpense' : totalExpense,
        'balance' : balance,
        'currency' : currency,
      };
    }
}