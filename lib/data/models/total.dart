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
    id: map['id'] ?? -1,
    month: map['month'] ?? '',
    totalIncome: map['totalIncome'] ?? '',
    totalExpense: map['totalExpense'] ?? '',
    balance: map['balance'] ?? 0.0,
    currency: map['currency'] ?? ''
  );
}