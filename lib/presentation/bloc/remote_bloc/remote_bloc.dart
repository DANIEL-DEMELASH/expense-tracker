import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_task/data/data_sources/remote/api_provider.dart';
import 'package:interview_task/data/models/currency.dart';
import 'package:interview_task/presentation/bloc/remote_bloc/remote_event.dart';
import 'package:interview_task/presentation/bloc/remote_bloc/remote_state.dart';

class RemoteBloc extends Bloc<RemoteEvent, RemoteState> {
  RemoteBloc():super(LoadingCurrencyList()) {
    on<GetCurrency>(_onGetCurrency);
  }
  
  Future<void> _onGetCurrency(GetCurrency event, Emitter<RemoteState> emit) async {
    try {
      final ApiProvider apiProvider = ApiProvider();
      emit(LoadingCurrencyList());
      final Currency? currency = await apiProvider.getData();
      if(currency != null){
        emit(LoadedCurrencyList(currency: currency));
      }else{
        emit(RemoteError(error: 'error loading currency exchanges'));
      }  
    } catch (e) {
      emit(RemoteError(error: 'error loading currency exchanges $e'));
    }
    
  }
}