import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_task/data/data_sources/local/expense_db.dart';
import 'package:interview_task/data/data_sources/local/income_db.dart';
import 'package:interview_task/data/data_sources/local/total_db.dart';
import 'package:interview_task/data/models/expense.dart';
import 'package:interview_task/data/models/income.dart';
import 'package:interview_task/presentation/bloc/local_db_bloc/local_event.dart';
import 'package:interview_task/presentation/bloc/local_db_bloc/local_state.dart';

class LocalBloc extends Bloc<LocalEvent, LocalState> {
  final _incomeDb = IncomeDb();
  final _expenseDb = ExpenseDb();
  final _totalDb = TotalDb();
  
  LocalBloc():super(LoadingTotalList()) {
    on<GetTotalList>(_onGetTotalList);
    on<GetTotal>(_onGetTotal);
    on<GetIncomesByMonth>(_onGetIncomes);
    on<GetExpensesByMonth>(_onGetExpenses);
    on<GetExpenseTypes>(_onGetExpenseTypes);
    on<AddExpenseType>(_onAddExpenseType);
    on<AddExpense>(_onAddExpense);
    on<AddIncome>(_onAddIncome);
    on<AddIncomeType>(_onAddIncomeType);
    on<GetIncomeTypes>(_onGetIncomeTypes);
  }
  
  Future<void> _onGetTotalList (GetTotalList event, Emitter<LocalState> emit) async {
    try {
      emit(LoadingTotalList());
      final result = await _totalDb.getAllTotals();
      emit(LoadedTotalList(totalLists: result));      
    } catch (e) {
      emit(ErrorState(error: 'error loading total list $e'));
    }
  }
  
  Future<void> _onGetTotal (GetTotal event, Emitter<LocalState> emit) async {
    try {
      emit(LoadingTotal());
      dynamic result = await _totalDb.getById(event.id);
      emit(LoadedTotal(total: result));    
      result = await _totalDb.getAllTotals();  
      emit(LoadedTotalList(totalLists: result)); 
    } catch (e) {
      emit(ErrorState(error: 'error loading total list $e'));
    }
  }
  
  Future<void> _onGetIncomes (GetIncomesByMonth event, Emitter<LocalState> emit) async {
    try {
      // print(event.id);
      emit(LoadingIncome());
      List<Income> result = await _incomeDb.getIncomeWithTypesByMonth(event.id);
      emit(LoadedIncome(incomeList: result));      
      final result2 = await _totalDb.getAllTotals();  
      emit(LoadedTotalList(totalLists: result2)); 
    } catch (e) {
      emit(ErrorState(error: 'error loading total list $e'));
    }
  }
  
   Future<void> _onGetExpenses (GetExpensesByMonth event, Emitter<LocalState> emit) async {
    try {
      emit(LoadingExpense());
      List<Expense> result = await _expenseDb.getExpenseWithTypesByMonth(event.id);
      emit(LoadedExpense(expenseList: result));
      final result2 = await _totalDb.getAllTotals();  
      emit(LoadedTotalList(totalLists: result2)); 
    } catch (e) {
      emit(ErrorState(error: 'error loading total list $e'));
    }
  }
  
  Future<void> _onGetExpenseTypes (GetExpenseTypes event, Emitter<LocalState> emit) async {
    try {
      emit(LoadingExpense());
      List<ExpenseType> expenseType = await _expenseDb.getExpenseTypes();
      if(expenseType.isNotEmpty){
        emit(LoadedExpenseTypes(expenseTypes: expenseType));
      }else{
        emit(LoadedExpenseTypes(expenseTypes: []));
      }
    } catch (e) {
      emit(ErrorState(error: 'error loading total list $e'));
    }
  }
  
  Future<void> _onAddExpenseType (AddExpenseType event, Emitter<LocalState> emit) async {
    try {
      final int result = await _expenseDb.createExpenseType(expenseType: event.expenseType);
      if(result > 0){
        emit(ExpenseTypeSaved(id: result));
      }else{
        emit(ErrorState(error: 'error saving expense type'));  
      }
      final result2 = await _expenseDb.getExpenseTypes();  
      emit(LoadedExpenseTypes(expenseTypes: result2)); 
    } catch (e) {
      emit(ErrorState(error: 'error saving expense type $e'));
    }
  }
  
  Future<void> _onAddExpense (AddExpense event, Emitter<LocalState> emit) async {
    try {
      final id = await _expenseDb.createExpense(expense: event.expense);
      if(id > 0){
        emit(ExpenseSaved(id: id));
      }else{
        emit(ErrorState(error: 'error saving expense'));
      }
      final result2 = await _totalDb.getAllTotals();  
      emit(LoadedTotalList(totalLists: result2)); 
    } catch (e) {
      emit(ErrorState(error: 'error saving expense $e'));
    }
  }
  
  Future<void> _onGetIncomeTypes (GetIncomeTypes event, Emitter<LocalState> emit) async {
    try {
      emit(LoadingIncomeTypes());
      List<IncomeType> incomeType = await _incomeDb.getIncomeTypes();
      if(incomeType.isNotEmpty){
        emit(LoadedIncomeTypes(incomeTypes: incomeType));
      }else{
        emit(LoadedIncomeTypes(incomeTypes : []));
      }
    } catch (e) {
      emit(ErrorState(error: 'error loading total list $e'));
    }
  }
  
  Future<void> _onAddIncomeType (AddIncomeType event, Emitter<LocalState> emit) async {
    try {
      final int result = await _incomeDb.createIncomeType(incomeType: event.incomeType);
      if(result > 0){
        emit(IncomeTypeSaved(id: result));
      }else{
        emit(ErrorState(error: 'error saving expense type'));  
      }
      final result2 = await _totalDb.getAllTotals();  
      emit(LoadedTotalList(totalLists: result2)); 
    } catch (e) {
      emit(ErrorState(error: 'error saving expense type $e'));
    }
  }
  
  Future<void> _onAddIncome (AddIncome event, Emitter<LocalState> emit) async {
    try {
      final id = await _incomeDb.createIncome(income: event.income);
      if(id > 0){
        emit(IncomeSaved(id: id));
      }else{
        emit(ErrorState(error: 'error saving expense'));
      }
      final result2 = await _totalDb.getAllTotals();  
      emit(LoadedTotalList(totalLists: result2)); 
    } catch (e) {
      emit(ErrorState(error: 'error saving expense $e'));
    }
  }
}