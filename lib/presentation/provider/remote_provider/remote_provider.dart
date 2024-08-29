import 'package:flutter/material.dart';
import 'package:interview_task/data/data_sources/remote/api_provider.dart';
import 'package:interview_task/data/models/currency.dart';

class RemoteProvider extends ChangeNotifier {
  ApiProvider apiProvider = ApiProvider();
  Currency? currency;
  double? selectedCurrencyRate;
  
  void getCurrency() async {
    currency = await apiProvider.getData();
    notifyListeners();
  }
  
  void setCurrency(double rate) {
    selectedCurrencyRate = rate;
    notifyListeners();
  }
}
