class Currency {
  final Map<String, double> data;

  Currency({required this.data});

  factory Currency.fromJson(Map<String, dynamic> json) {
    final dataMap = Map<String, double>.from(json['data'].map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    ));
    return Currency(data: dataMap);
  }
}