import 'package:flutter/material.dart';
import 'package:interview_task/data/data_sources/remote/api_provider.dart';
// import 'package:interview_task/data/data_sources/expense_db.dart';
// import 'package:interview_task/data/data_sources/income_db.dart';
// import 'package:interview_task/data/data_sources/total_db.dart';
// import 'package:interview_task/data/models/expense.dart';
// import 'package:interview_task/data/models/income.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () async {
                  ApiProvider apiProvider = ApiProvider();
                  final result = await apiProvider.getData();
                  for(int i = 0; i < result!.data.length; i++){
                    debugPrint('${result.data.keys.elementAt(i)} ${result.data.values.elementAt(i)}'); 
                  }
                  // final result = IncomeDb();
                  // result.createIncomeType(incomeType: IncomeType(name: 'salary'));
                  // result.createIncome(income: Income(
                  //   amount: 999,
                  //   currency: 'ETB',
                  //   note: '',
                  //   createdDate: '2024-09',
                  //   incomeType: 1
                  // ));
                  // print(await result.updateIncome(income: Income(
                  //   amount: 2500,
                  //   currency: 'ETB',
                  //   createdDate: '2024-10',
                  //   incomeType: 1,
                  //   note: ''
                  // )));
                  // final resultsList = await result.getAllTotals();
                  // print('${resultsList.length} records found');
                }, 
                child: const Text('add income')
              ),
              
              TextButton(
                onPressed: () async {
                  // final result = ExpenseDb();
                  // result.createExpenseType(expenseType: ExpenseType(name: 'transport'));
                  // result.createExpense(expense: Expense(
                  //   amount: 999,
                  //   currency: 'ETB',
                  //   note: '',
                  //   createdDate: '2024-09',
                  //   expenseType: 1
                  // ));
                  // print(await result.updateExpense(expense: Expense(
                  //   amount: 2500,
                  //   currency: 'ETB',
                  //   createdDate: '2024-09',
                  //   expenseType: 1,
                  //   note: ''
                  // )));
                  // final resultsList = await result.getAllTotals();
                  // print('${resultsList.length} records found');
                  
                }, 
                child: const Text('add expense')
              ),
              
              
              TextButton(
                onPressed: () async {
                  // final result = TotalDb();
                  // result.deleteAllRecords();
                  // final resultsList = await result.getAllTotals();
                  // print('${resultsList.length} record found');
                }, 
                child: const Text('delete')
              ),
              
              TextButton(
                onPressed: () async {
                  // final result = ExpenseDb();
                  // final resultsList = await result.getAllExpenseWithTypes();
                  // print('${resultsList.length} record found');
                  // for(int i = 0; i < resultsList.length; i++){
                  //   print('balance = ${resultsList[i].amount}');
                  //   print('total income = ${resultsList[i].createdDate}');
                    // print('total expense = ${resultsList[i].totalExpense}');
                  // }
                }, 
                child: const Text('display')
              ),
              
              TextButton(
                onPressed: () async {
                  // final result = ExpenseDb();
                  // final resultsList = await result.getExpenseWithTypesByMonth('2024-09');
                  // print('${resultsList.length} record found');
                  // for(int i = 0; i < resultsList.length; i++){
                  //   print('month - ${resultsList[i].expenseTypeName}');
                  // }
                  //  final result = IncomeDb();
                  // final resultsList = await result.getIncomeWithTypesByMonth('2024-09');
                  // print('${resultsList.length} record found');
                  // for(int i = 0; i < resultsList.length; i++){
                  //   print('month - ${resultsList[i].incomeTypeName}');
                  // }
                  // final result  = TotalDb();
                  // final resultsList = await result.getDistinctMonths();
                  // for(int i = 0; i < resultsList.length; i++){
                  //   print('month - ${resultsList[i]}');
                  // }
                }, 
                child: const Text('month lists')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

