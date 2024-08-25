import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:interview_task/data/models/currency.dart';

class ApiProvider {

  Future<Currency?> getData() async {
    try {
      Dio dio = Dio();
      dio.options.baseUrl = 'https://api.freecurrencyapi.com/v1';

      final response = await dio.get(
        '/latest',
        queryParameters: {
          'apikey': 'fca_live_QJCG7itSy3YfMHVlI9SecW9SzEEeQXZQpckisEd2', // Your API key
          'base_currency': 'USD'
        },
      );
      
      if(response.data != null){
        final currencies = Currency.fromJson(response.data);
        return currencies;
      }
    } catch (e) {
      // Handle errors
      debugPrint('Error: $e');
  }
    return null;
}


}