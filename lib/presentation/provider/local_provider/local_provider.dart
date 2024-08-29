import 'package:flutter/material.dart';
import 'package:interview_task/data/data_sources/local/expense_db.dart';
import 'package:interview_task/data/data_sources/local/income_db.dart';
import 'package:interview_task/data/data_sources/local/total_db.dart';
import 'package:interview_task/data/models/expense.dart';
import 'package:interview_task/data/models/income.dart';
import 'package:interview_task/data/models/total.dart';

class LocalProvider extends ChangeNotifier{
  List<Total>? totalList;
  Total? selectedTotal;
  List<Income>? incomeList;
  List<Expense>? expenseList;
  List<ExpenseType>? expenseTypes;
  List<IncomeType>? incomeTypes;
  
  final _incomeDb = IncomeDb();
  final _expenseDb = ExpenseDb();
  final _totalDb = TotalDb();
  
  void getTotalList() async {
    totalList = await _totalDb.getAllTotals();
    notifyListeners();
  }
  
  void setCurrentTotal(Total total) {
    selectedTotal = total;
    getExpenseList();
    getIncomeList();
    getTotalList();
    notifyListeners();
  }
  
  void getIncomeList() async {
    selectedTotal?.id != null ?     
    incomeList = await _incomeDb.getIncomeWithTypesByMonth(selectedTotal!.id!) : null;
    notifyListeners();
  }
  
  void getExpenseList() async {
    selectedTotal?.id != null ?   
    expenseList = await _expenseDb.getExpenseWithTypesByMonth(selectedTotal!.id!) : null;
    notifyListeners();
  }
  
  void getExpenseTypes() async {
    expenseTypes = await _expenseDb.getExpenseTypes();
    notifyListeners();
  }
  
  void getIncomeTypes() async {
    incomeTypes = await _incomeDb.getIncomeTypes();
    notifyListeners();
  }
  
  void addIncome(Income income) async {
    await _incomeDb.createIncome(income: income);
    getIncomeList();
    getExpenseList();
    getTotalList();
    notifyListeners();
  }
  
  void addExpense(Expense expense) async {
    await _expenseDb.createExpense(expense: expense);
    getExpenseList();
    getIncomeList();
    getTotalList();
    notifyListeners();
  }
  
  void addIncomeType(IncomeType incomeType) async {
    await _incomeDb.createIncomeType(incomeType: incomeType);
    getIncomeTypes();
    getTotalList();
    notifyListeners();
  }
  
  void addExpenseType(ExpenseType expenseType) async {
    await _expenseDb.createExpenseType(expenseType: expenseType);
    getExpenseTypes();
    getTotalList();
    notifyListeners();
  }
  
  void refreshTotal() async{
    selectedTotal = await _totalDb.getById(selectedTotal!.id!);
    notifyListeners();
  }
}