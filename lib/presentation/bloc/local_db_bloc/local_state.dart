import 'package:interview_task/data/models/expense.dart';
import 'package:interview_task/data/models/income.dart';
import 'package:interview_task/data/models/total.dart';

abstract class LocalState {
  LocalState();
}

class LoadingTotalList extends LocalState {
  LoadingTotalList();
} 

class LoadedTotalList extends LocalState {
  final List<Total> totalLists;
  LoadedTotalList({required this.totalLists});
}

class ErrorState extends LocalState {
  final String error;
  ErrorState({required this.error});
}

class LoadingTotal extends LocalState {
  LoadingTotal();
}

class LoadedTotal extends LocalState {
  final Total total;
  LoadedTotal({required this.total});
}

class LoadingIncome extends LocalState {
  LoadingIncome();
}

class LoadedIncome extends LocalState {
  final List<Income> incomeList;
  LoadedIncome({required this.incomeList});
}

class LoadingExpense extends LocalState {
  LoadingExpense();
}

class LoadedExpense extends LocalState {
  final List<Expense> expenseList;
  LoadedExpense({required this.expenseList});
}

class LoadingExpenseTypes extends LocalState {
  LoadingExpenseTypes();
}

class LoadedExpenseTypes extends LocalState {
  final List<ExpenseType> expenseTypes;
  LoadedExpenseTypes({required this.expenseTypes});
}

class ExpenseTypeSaved extends LocalState {
  final int id;
  ExpenseTypeSaved({required this.id});
}

class ExpenseSaved extends LocalState {
  final int id;
  ExpenseSaved({required this.id});
}

class LoadingIncomeTypes extends LocalState {
  LoadingIncomeTypes();
}

class LoadedIncomeTypes extends LocalState {
  final List<IncomeType> incomeTypes;
  LoadedIncomeTypes({required this.incomeTypes});
}

class IncomeTypeSaved extends LocalState {
  final int id;
  IncomeTypeSaved({required this.id});
}

class IncomeSaved extends LocalState {
  final int id;
  IncomeSaved({required this.id});
}
