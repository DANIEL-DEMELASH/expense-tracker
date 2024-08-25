import 'package:flutter/material.dart';
import 'package:interview_task/data/data_sources/expense_db.dart';
import 'package:interview_task/data/data_sources/income_db.dart';
import 'package:interview_task/data/data_sources/total_db.dart';
import 'package:interview_task/data/models/expense.dart';
import 'package:interview_task/data/models/income.dart';
import 'package:interview_task/data/models/total.dart';

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
          child: TextButton(
            onPressed: () async {
              // final result = ExpenseDb();
              // // print(await result.createIncomeType(incomeType: IncomeType(
              // //   name: 'Food'
              // // )));
              // // print(await result.getIncomeTypes());
              // print(await result.createExpense(expense: Expense(
              //   amount: 499,
              //   currency: 'USD',
              //   note: '',
              //   createdDate: '',
              //   expenseType: 2,
              // )));
              // final expensesList = (await result.getAllExpenseWithTypes());
              // for(int i = 0; i < expensesList.length; i++){
              //   print('balance = ${expensesList[i].amount}');
              //   print('total expense = ${expensesList[i].currency}');
              // }
            }, 
            child: const Text('test')
          ),
        ),
      ),
    );
  }
}

