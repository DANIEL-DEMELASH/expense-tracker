// abstract class TotalEvent {
//   TotalEvent();
// }

// class GetTotalList extends TotalEvent {
//   GetTotalList();
// }

// class GetTotal extends TotalEvent {
//   final int id;
//   GetTotal(this.id);
// }
















import 'package:interview_task/data/models/expense.dart';
import 'package:interview_task/data/models/income.dart';

abstract class LocalEvent {
  LocalEvent();
}

class GetTotalList extends LocalEvent {
  GetTotalList();
}

class GetTotal extends LocalEvent {
  final int id;
  GetTotal(this.id);
}

class GetIncomesByMonth extends LocalEvent {
  final int id;
  GetIncomesByMonth({required this.id});
}

class GetExpensesByMonth extends LocalEvent {
  final int id;
  GetExpensesByMonth({required this.id});
}

class GetExpenseTypes extends LocalEvent {
  GetExpenseTypes();
}

class AddExpenseType extends LocalEvent {
  final ExpenseType expenseType;
  AddExpenseType({required this.expenseType});
}

class AddExpense extends LocalEvent {
  final Expense expense;
  AddExpense({required this.expense});
}

class GetIncomeTypes extends LocalEvent {
  GetIncomeTypes();
}

class AddIncomeType extends LocalEvent {
  final IncomeType incomeType;
  AddIncomeType({required this.incomeType});
}

class AddIncome extends LocalEvent {
  final Income income;
  AddIncome({required this.income});
}