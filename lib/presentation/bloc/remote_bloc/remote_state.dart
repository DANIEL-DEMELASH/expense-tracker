import 'package:interview_task/data/models/currency.dart';

abstract class RemoteState {
  RemoteState();
}

class LoadingCurrencyList extends RemoteState {
  LoadingCurrencyList();
} 

class LoadedCurrencyList extends RemoteState {
  final Currency currency;
  LoadedCurrencyList({required this.currency});
}

class RemoteError extends RemoteState {
  final String error;
  RemoteError({required this.error});
}
